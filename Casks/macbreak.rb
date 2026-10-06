cask "macbreak" do
  version "1.2.1"
  sha256 "89d2c18fcc6e05d11bcd76be63c2fd6202b7a63e8836c87d1cecdcf034c87ff8"

  url "https://github.com/deepakk33/macbreak/releases/download/v#{version}/MacBreak-#{version}.zip"
  name "MacBreak"
  desc "Break reminder that holds the screen until the rest is actually over"
  homepage "https://github.com/deepakk33/macbreak"

  depends_on macos: :ventura

  app "MacBreak.app"

  # `delete` and `trash` both shell out to sudo for this path, which turns an
  # upgrade into a password prompt the installer has no terminal to answer. The
  # launch agent is in the user's own home, so remove it as the user.
  uninstall launchctl: "com.user.macbreak",
            quit:      "com.user.macbreak",
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
    MacBreak is not code-signed, so install it with --no-quarantine:

      brew install --cask --no-quarantine deepakk33/tap/macbreak

    Without that flag macOS will refuse to open it, and you will need:

      xattr -dr com.apple.quarantine "#{appdir}/MacBreak.app"

    MacBreak runs in the menu bar with no Dock icon. Open it once to start
    it and to switch on "Start at login":

      open -a MacBreak
  EOS
end
