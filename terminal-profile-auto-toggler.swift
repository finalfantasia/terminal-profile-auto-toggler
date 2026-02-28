import Cocoa

func applyTerminalProfile() {
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"

    let darkProfile = "Solarized Dark"
    let lightProfile = "Solarized Light"

    let profileToApply = isDark ? darkProfile : lightProfile

    let script = """
    tell application "Terminal"
        repeat with w in windows
            try
                set current settings of w to settings set "\(profileToApply)"
            end try
        end repeat
    end tell
    """

    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: script) {
        scriptObject.executeAndReturnError(&error)
    }
}

DistributedNotificationCenter.default().addObserver(
    forName: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: .main
) { _ in
    applyTerminalProfile()
}

// Apply immediately on launch
applyTerminalProfile()

RunLoop.main.run()
