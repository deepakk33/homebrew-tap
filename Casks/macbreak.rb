cask "macbreak" do
  version "1.2.0"
  sha256 "8b7b69e7a593d4d08c696ca7baee04276a0dddb8a7a48448b7006c7a52b0d99f"

  url "https://github.com/deepakk33/macbreak/releases/download/v#{version}/MacBreak-#{version}.zip",
      verified: "github.com/deepakk33/macbreak/"
  name "MacBreak"
  desc "Break reminder that holds the screen until the rest is actually over"
  homepage "https://github.com/deepakk33/macbreak"

  depends_on macos: ">= :ventura"

  app "MacBreak.app"

  # The release build is not code-signed or notarised, so macOS would refuse to
  # open it straight from a download. Clearing the quarantine attribute is what
  # a right-click -> Open would do, minus the dialog.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/MacBreak.app"]
  end

  uninstall quit:      "com.user.macbreak",
            launchctl: "com.user.macbreak",
            delete:    "~/Library/LaunchAgents/com.user.macbreak.plist"

  zap trash: [
    "~/Library/LaunchAgents/com.user.macbreak.plist",
    "~/Library/Preferences/com.user.macbreak.plist",
  ]

  caveats <<~EOS
    MacBreak runs in the menu bar with no Dock icon.

    Open it once to start it and to switch on "Start at login":

      open -a MacBreak

    Or press Cmd-Space and type "macbreak".
  EOS
end
