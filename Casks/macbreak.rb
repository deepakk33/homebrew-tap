cask "macbreak" do
  version "1.2.1"
  sha256 "89d2c18fcc6e05d11bcd76be63c2fd6202b7a63e8836c87d1cecdcf034c87ff8"

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

  # Both `delete` and `trash` end up shelling out to sudo for this path, which
  # turns an upgrade into a password prompt the installer has no terminal to
  # answer. The launch agent is in the user's own home, so remove it as the
  # user and say so explicitly.
  uninstall quit:      "com.user.macbreak",
            launchctl: "com.user.macbreak",
            script:    {
              executable:   "/bin/rm",
              args:         ["-f", "#{Dir.home}/Library/LaunchAgents/com.user.macbreak.plist"],
              sudo:         false,
              must_succeed: false,
            }

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
