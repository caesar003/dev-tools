#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

#include "cJSON.h"

#define SESSION_DIR "/.dev-sessions"
#define BUFFER_SIZE 1024

// Function to check if a directory exists and create it if not
void ensureSessionDirExists(const char *sessionDir) {
    struct stat st = {0};
    if (stat(sessionDir, &st) == -1) {
        mkdir(sessionDir, 0700);
    }
}

// Function to execute a shell command and return its output
char *execCommand(const char *command) {
    FILE *fp;
    char buffer[BUFFER_SIZE];
    char *result = malloc(BUFFER_SIZE * sizeof(char));
    result[0] = '\0';  // Empty the string

    if ((fp = popen(command, "r")) == NULL) {
        printf("Error executing command: %s\n", command);
        return NULL;
    }

    while (fgets(buffer, sizeof(buffer), fp) != NULL) {
        strcat(result, buffer);
    }

    pclose(fp);
    return result;
}

// Function to save the state of Kitty tabs
void saveState(const char *sessionName, const char *sessionDir) {
    char stateFile[BUFFER_SIZE];
    snprintf(stateFile, sizeof(stateFile), "%s/%s.json", sessionDir, sessionName);

    char *state = execCommand("kitty @ ls");
    if (state == NULL) {
        printf("Error: Could not retrieve kitty state.\n");
        return;
    }

    // Parse JSON
    cJSON *parsedState = cJSON_Parse(state);
    if (parsedState == NULL) {
        printf("Error parsing Kitty state JSON.\n");
        free(state);
        return;
    }

    // Extract tab titles and working directories
    cJSON *tabs = cJSON_GetArrayItem(parsedState, 0);
    cJSON *tabArray = cJSON_GetObjectItem(tabs, "tabs");

    FILE *file = fopen(stateFile, "w");
    if (file == NULL) {
        printf("Error: Could not open file to save state.\n");
        cJSON_Delete(parsedState);
        free(state);
        return;
    }

    fprintf(file, "[");
    for (int i = 0; i < cJSON_GetArraySize(tabArray); i++) {
        cJSON *tab = cJSON_GetArrayItem(tabArray, i);
        cJSON *title = cJSON_GetObjectItem(tab, "title");
        cJSON *windows = cJSON_GetObjectItem(tab, "windows");
        cJSON *cwd = cJSON_GetObjectItem(cJSON_GetArrayItem(windows, 0), "cwd");

        fprintf(file, "{\"title\":\"%s\", \"cwd\":\"%s\"}", title->valuestring, cwd->valuestring);
        if (i < cJSON_GetArraySize(tabArray) - 1) {
            fprintf(file, ",");
        }
    }
    fprintf(file, "]");

    fclose(file);
    printf("Kitty state saved to %s\n", stateFile);

    cJSON_Delete(parsedState);
    free(state);
}

// Function to restore the state of Kitty tabs
void restoreState(const char *sessionName, const char *sessionDir) {
    char stateFile[BUFFER_SIZE];
    snprintf(stateFile, sizeof(stateFile), "%s/%s.json", sessionDir, sessionName);

    FILE *file = fopen(stateFile, "r");
    if (file == NULL) {
        printf("Error: No state file found at %s\n", stateFile);
        return;
    }

    char buffer[BUFFER_SIZE];
    fread(buffer, sizeof(char), BUFFER_SIZE, file);
    fclose(file);

    cJSON *parsedState = cJSON_Parse(buffer);
    if (parsedState == NULL) {
        printf("Error parsing state JSON.\n");
        return;
    }

    for (int i = 0; i < cJSON_GetArraySize(parsedState); i++) {
        cJSON *tab = cJSON_GetArrayItem(parsedState, i);
        cJSON *title = cJSON_GetObjectItem(tab, "title");
        cJSON *cwd = cJSON_GetObjectItem(tab, "cwd");

        if (i == 0) {
            char setTabTitleCommand[BUFFER_SIZE];
            snprintf(setTabTitleCommand, sizeof(setTabTitleCommand), "kitty @ set-tab-title \"%s\"", title->valuestring);
            system(setTabTitleCommand);
            chdir(cwd->valuestring);
        } else {
            char launchTabCommand[BUFFER_SIZE];
            snprintf(launchTabCommand, sizeof(launchTabCommand), "kitty @ launch --type=tab --tab-title=\"%s\" --cwd=\"%s\"", title->valuestring, cwd->valuestring);
            system(launchTabCommand);
        }
    }

    printf("Kitty state restored from %s\n", stateFile);
    cJSON_Delete(parsedState);
}

// Function to destroy tabs in Kitty, leaving only one
void destroyTabs() {
    char *state = execCommand("kitty @ ls");
    if (state == NULL) {
        printf("Error: Could not retrieve kitty state.\n");
        return;
    }

    cJSON *parsedState = cJSON_Parse(state);
    cJSON *tabs = cJSON_GetArrayItem(parsedState, 0);
    cJSON *tabArray = cJSON_GetObjectItem(tabs, "tabs");

    int numTabs = cJSON_GetArraySize(tabArray);
    if (numTabs <= 1) {
        printf("There is only one tab open, nothing to destroy.\n");
        cJSON_Delete(parsedState);
        free(state);
        return;
    }

    for (int i = 1; i < numTabs; i++) {
        cJSON *tab = cJSON_GetArrayItem(tabArray, i);
        cJSON *tabId = cJSON_GetObjectItem(tab, "id");

        char closeTabCommand[BUFFER_SIZE];
        snprintf(closeTabCommand, sizeof(closeTabCommand), "kitty @ close-tab --match id:%d", tabId->valueint);
        system(closeTabCommand);
    }

    printf("All tabs except one have been destroyed.\n");
    cJSON_Delete(parsedState);
    free(state);
}

// Function to list available sessions
void listSessions(const char *sessionDir) {
    DIR *d;
    struct dirent *dir;
    d = opendir(sessionDir);
    if (d == NULL) {
        printf("Error: Could not open session directory.\n");
        return;
    }

    printf("Available sessions:\n");
    while ((dir = readdir(d)) != NULL) {
        if (strstr(dir->d_name, ".json") != NULL) {
            printf("%s\n", strtok(dir->d_name, "."));
        }
    }
    closedir(d);
}

// Main function to handle command-line arguments
int main(int argc, char *argv[]) {
    char *homeDir = getenv("HOME");
    char sessionDir[BUFFER_SIZE];
    snprintf(sessionDir, sizeof(sessionDir), "%s%s", homeDir, SESSION_DIR);

    ensureSessionDirExists(sessionDir);

    if (argc < 2) {
        printf("Usage: devs {save|-s|restore|-r|destroy|-d|list|-l} [sessionName]\n");
        return 1;
    }

    const char *command = argv[1];
    const char *sessionName = (argc > 2) ? argv[2] : "kitty_state";

    if (strcmp(command, "save") == 0 || strcmp(command, "-s") == 0) {
        saveState(sessionName, sessionDir);
    } else if (strcmp(command, "restore") == 0 || strcmp(command, "-r") == 0) {
        restoreState(sessionName, sessionDir);
    } else if (strcmp(command, "destroy") == 0 || strcmp(command, "-d") == 0) {
        destroyTabs();
    } else if (strcmp(command, "list") == 0 || strcmp(command, "-l") == 0) {
        listSessions(sessionDir);
    } else {
        printf("Usage: devs {save|-s|restore|-r|destroy|-d|list|-l}\n");
    }

    return 0;
}
