# Terminal Profile Auto Toggler

This guide sets up a Swift tool and LaunchAgent that runs continuously and automatically toggles the light/dark profile in the **Terminal.app** in response to a change to macOS' Light/Dark appearance.

Tested on macOS Tahoe.

---

## 1. Customize the Swift Source

Open the source file:

```sh
nano terminal-profile-auto-toggler.swift
```

- Edit the sections for **Light and Dark mode profiles** to match your desired Terminal profiles.
- Make sure any profile names used in the script exist in Terminal.app.

Save your changes before compiling.

---

## 2. Compile the Swift Tool

From the directory containing:

```sh
terminal-profile-auto-toggler.swift
```

Compile it:

```sh
swiftc terminal-profile-auto-toggler.swift -O -o terminal-profile-auto-toggler
```

Create the destination directory if needed:

```sh
mkdir -p ~/.local/bin
```

Move the binary:

```sh
mv terminal-profile-auto-toggler ~/.local/bin/
```

Make it executable:

```sh
chmod +x ~/.local/bin/terminal-profile-auto-toggler
```

Verify it runs:

```sh
~/.local/bin/terminal-profile-auto-toggler
```

---

## 3. Create the LaunchAgent

Create:

```sh
~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
```

Use this configuration (replace `YOUR_USERNAME`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.terminal-profile-auto-toggler</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/YOUR_USERNAME/.local/bin/terminal-profile-auto-toggler</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>

    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>

    <key>StandardOutPath</key>
    <string>/tmp/terminal-profile-auto-toggler.out</string>

    <key>StandardErrorPath</key>
    <string>/tmp/terminal-profile-auto-toggler.err</string>
</dict>
</plist>
```

---

## 4. Fix Permissions

```sh
chmod 644 ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
chown $(whoami) ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
```

Validate:

```sh
plutil ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
```

---

## 5. Load the LaunchAgent

```sh
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
```

If updating:

```sh
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist

launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.terminal-profile-auto-toggler.plist
```

Start immediately:

```sh
launchctl kickstart -k gui/$(id -u)/com.user.terminal-profile-auto-toggler
```

---

## 6. Verify It’s Running

```sh
launchctl print gui/$(id -u)/com.user.terminal-profile-auto-toggler
```

Or:

```sh
launchctl list | grep terminal-profile
```

---

## 7. Grant Automation Permissions (If Needed)

If the tool controls Terminal, macOS may require:
1. System Settings → Privacy & Security
2. Automation
3. Allow your binary to control Terminal
4. Also check Accessibility if required

---

## 8. Debugging

Check logs:

```sh
tail -f /tmp/terminal-profile-auto-toggler.err
```

Common causes of failure:
- Wrong path in `ProgramArguments`
- Binary not executable
- Missing `PATH` dependencies
- Incorrect file permissions

---

## Notes
- Must be placed in `~/Library/LaunchAgents`
- Must be bootstrapped into `gui/$(id -u)`
- Do not use deprecated `launchctl load/unload`
- Runs continuously and restarts only on crash
- Ensure Terminal profile names in the Swift source match your existing profiles
