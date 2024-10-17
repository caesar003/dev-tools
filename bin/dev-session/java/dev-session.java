import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DevSession {
    private static final String SESSION_DIR = System.getProperty("user.home") + "/.dev-sessions";
    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("Usage: devs {save|-s|restore|-r|destroy|-d|list|-l}");
            System.exit(1);
        }

        switch (args[0]) {
            case "save":
            case "-s":
                saveState(args.length > 1 ? args[1] : null);
                break;
            case "restore":
            case "-r":
                restoreState(args.length > 1 ? args[1] : null);
                break;
            case "destroy":
            case "-d":
                destroyTabs();
                break;
            case "list":
            case "-l":
                listSessions();
                break;
            default:
                System.out.println("Usage: devs {save|-s|restore|-r|destroy|-d|list|-l}");
                System.exit(1);
        }
    }

    private static void saveState(String sessionName) throws Exception {
        sessionName = (sessionName == null) ? "kitty_state" : sessionName;
        String stateFile = SESSION_DIR + "/" + sessionName + ".txt";

        createSessionDir();

        Process process = new ProcessBuilder("kitty", "@", "ls").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String json = reader.lines().collect(Collectors.joining());

        JsonNode node = objectMapper.readTree(json);
        List<Map<String, String>> tabs = new ArrayList<>();

        node.get(0).get("tabs").forEach(tab -> {
            String title = tab.get("title").asText();
            String cwd = tab.get("windows").get(0).get("cwd").asText();
            Map<String, String> tabInfo = new HashMap<>();
            tabInfo.put("title", title);
            tabInfo.put("cwd", cwd);
            tabs.add(tabInfo);
        });

        try (PrintWriter out = new PrintWriter(stateFile)) {
            for (Map<String, String> tab : tabs) {
                out.println(tab.get("title") + " " + tab.get("cwd"));
            }
        }

        System.out.println("Kitty state saved to " + stateFile);
    }

    private static void restoreState(String sessionName) throws Exception {
        sessionName = (sessionName == null) ? "kitty_state" : sessionName;
        String stateFile = SESSION_DIR + "/" + sessionName + ".txt";

        if (!Files.exists(Paths.get(stateFile))) {
            System.out.println("No state file found at " + stateFile);
            System.exit(1);
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(stateFile))) {
            String line;
            int tabNumber = 0;

            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(" ");
                String title = parts[0];
                String cwd = parts[1];
                String numberedTitle = (tabNumber + 1) + ". " + title;

                if (tabNumber == 0) {
                    new ProcessBuilder("kitty", "@", "set-tab-title", numberedTitle).start().waitFor();
                    new ProcessBuilder("cd", cwd).start().waitFor();
                } else {
                    new ProcessBuilder("kitty", "@", "launch", "--type=tab", "--tab-title=" + numberedTitle, "--cwd=" + cwd).start().waitFor();
                }

                tabNumber++;
            }
        }

        System.out.println("Kitty state restored from " + stateFile);
    }

    private static void destroyTabs() throws Exception {
        Process process = new ProcessBuilder("kitty", "@", "ls").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String json = reader.lines().collect(Collectors.joining());

        JsonNode node = objectMapper.readTree(json);
        List<String> tabIds = new ArrayList<>();

        node.get(0).get("tabs").forEach(tab -> tabIds.add(tab.get("id").asText()));

        if (tabIds.size() <= 1) {
            System.out.println("There is only one tab open, nothing to destroy.");
            return;
        }

        for (int i = 1; i < tabIds.size(); i++) {
            String tabId = tabIds.get(i);
            new ProcessBuilder("kitty", "@", "close-tab", "--match", "id:" + tabId).start().waitFor();
        }

        System.out.println("All tabs except one have been destroyed.");
    }

    private static void listSessions() {
        File dir = new File(SESSION_DIR);
        File[] files = dir.listFiles((d, name) -> name.endsWith(".txt"));

        if (files == null || files.length == 0) {
            System.out.println("No sessions found.");
            return;
        }

        System.out.println("Available sessions:");
        for (File file : files) {
            System.out.println(file.getName().replace(".txt", ""));
        }
    }

    private static void createSessionDir() throws IOException {
        Files.createDirectories(Paths.get(SESSION_DIR));
    }
}
