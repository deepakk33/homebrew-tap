cask "macbreak" do
  version "1.2.2"
  sha256 "fd6d0f974d6ab7811819afc9540b3c81e560ed82d94398f3455bef69baeae60e"

  url "https://github.com/deepakk33/macbreak/releases/download/v#{version}/MacBreak-#{version}.zip"
  name "MacBreak"
  desc "Break reminder that holds the screen until the rest is actually over"
  homepage "https://github.com/deepakk33/macbreak"

  depends_on macos: :ventura

  app "MacBreak.app"

  # The release build is not code-signed, so a downloaded copy stays
  # quarantined and macOS refuses to open it. Clearing the attribute is what a
  # right-click -> Open would do, minus the dialog.
  postflight_steps do
    run "/bin/sh",
        args:         ["-c",
                       "xattr -dr com.apple.quarantine /Applications/MacBreak.app " \
                       "\"$HOME/Applications/MacBreak.app\" 2>/dev/null; true"],
        must_succeed: false
  end

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
    MacBreak runs in the menu bar with no Dock icon. Open it once to start
    it and to switch on "Start at login":

      open -a MacBreak

    Or press Cmd-Space and type "macbreak".
  EOS
end
