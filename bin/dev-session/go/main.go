package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

const sessionDir = ".dev-sessions"

// Tab structure to hold title and current working directory
type Tab struct {
	Title string `json:"title"`
	Cwd   string `json:"cwd"`
}

// Ensure session directory exists
func ensureSessionDir() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatalf("Error finding user home directory: %v", err)
	}
	sessionPath := filepath.Join(homeDir, sessionDir)

	if _, err := os.Stat(sessionPath); os.IsNotExist(err) {
		err := os.MkdirAll(sessionPath, 0755)
		if err != nil {
			log.Fatalf("Error creating session directory: %v", err)
		}
	}
	return sessionPath
}

// Save the current Kitty session to a file
func saveState(sessionName string) {
	if sessionName == "" {
		sessionName = "kitty_state"
	}
	sessionPath := filepath.Join(ensureSessionDir(), sessionName+".json")

	// Run Kitty command to get session state
	cmd := exec.Command("kitty", "@", "ls")
	stateOutput, err := cmd.Output()
	if err != nil {
		log.Fatalf("Error running kitty @ ls: %v", err)
	}

	// Parse the output and filter out the necessary fields
	var parsedState []map[string]interface{}
	err = json.Unmarshal(stateOutput, &parsedState)
	if err != nil {
		log.Fatalf("Error parsing Kitty state: %v", err)
	}

	var tabs []Tab
	for _, tabData := range parsedState[0]["tabs"].([]interface{}) {
		tab := tabData.(map[string]interface{})
		title := tab["title"].(string)
		cwd := tab["windows"].([]interface{})[0].(map[string]interface{})["cwd"].(string)
		tabs = append(tabs, Tab{Title: title, Cwd: cwd})
	}

	// Save to file
	tabsJSON, err := json.MarshalIndent(tabs, "", "  ")
	if err != nil {
		log.Fatalf("Error marshalling tab data: %v", err)
	}
	err = ioutil.WriteFile(sessionPath, tabsJSON, 0644)
	if err != nil {
		log.Fatalf("Error writing session file: %v", err)
	}

	fmt.Printf("Kitty state saved to %s\n", sessionPath)
}

// Restore the Kitty session from a file
func restoreState(sessionName string) {
	if sessionName == "" {
		sessionName = "kitty_state"
	}
	sessionPath := filepath.Join(ensureSessionDir(), sessionName+".json")

	// Check if the session file exists
	if _, err := os.Stat(sessionPath); os.IsNotExist(err) {
		log.Fatalf("No state file found at %s", sessionPath)
	}

	// Read the session file
	data, err := ioutil.ReadFile(sessionPath)
	if err != nil {
		log.Fatalf("Error reading session file: %v", err)
	}

	// Parse the saved tabs
	var tabs []Tab
	err = json.Unmarshal(data, &tabs)
	if err != nil {
		log.Fatalf("Error parsing saved state: %v", err)
	}

	// Restore tabs
	for index, tab := range tabs {
		if index == 0 {
			// Restore first tab by setting title and changing directory
			exec.Command("kitty", "@", "set-tab-title", tab.Title).Run()
			os.Chdir(tab.Cwd)
		} else {
			// Open new tabs
			exec.Command("kitty", "@", "launch", "--type=tab", "--tab-title="+tab.Title, "--cwd="+tab.Cwd).Run()
		}
	}

	fmt.Printf("Kitty state restored from %s\n", sessionPath)
}

// Destroy all tabs except the first one
func destroyTabs() {
	// Get the current Kitty tabs
	cmd := exec.Command("kitty", "@", "ls")
	stateOutput, err := cmd.Output()
	if err != nil {
		log.Fatalf("Error running kitty @ ls: %v", err)
	}

	// Parse the state output to get tab IDs
	var parsedState []map[string]interface{}
	err = json.Unmarshal(stateOutput, &parsedState)
	if err != nil {
		log.Fatalf("Error parsing Kitty state: %v", err)
	}

	tabs := parsedState[0]["tabs"].([]interface{})
	if len(tabs) <= 1 {
		fmt.Println("There is only one tab open, nothing to destroy.")
		return
	}

	// Close all tabs except the first one
	for _, tabData := range tabs[1:] {
		tab := tabData.(map[string]interface{})
		tabID := tab["id"].(float64)
		exec.Command("kitty", "@", "close-tab", "--match", fmt.Sprintf("id:%v", int(tabID))).Run()
	}

	fmt.Println("All tabs except one have been destroyed.")
}

// List available session files
func listSessions() {
	sessionPath := ensureSessionDir()
	files, err := ioutil.ReadDir(sessionPath)
	if err != nil {
		log.Fatalf("Error reading session directory: %v", err)
	}

	fmt.Println("Available sessions:")
	for _, file := range files {
		if filepath.Ext(file.Name()) == ".json" {
			fmt.Println(file.Name()[:len(file.Name())-5])
		}
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: dev_sessions {save|-s|restore|-r|destroy|-d|list|-l} [session_name]")
		os.Exit(1)
	}

	command := os.Args[1]
	sessionName := ""
	if len(os.Args) > 2 {
		sessionName = os.Args[2]
	}

	switch command {
	case "save", "-s":
		saveState(sessionName)
	case "restore", "-r":
		restoreState(sessionName)
	case "destroy", "-d":
		destroyTabs()
	case "list", "-l":
		listSessions()
	default:
		fmt.Println("Usage: dev_sessions {save|-s|restore|-r|destroy|-d|list|-l} [session_name]")
		os.Exit(1)
	}
}
