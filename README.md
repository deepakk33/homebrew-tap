# deepakk33/tap

Homebrew tap for my macOS tools.

```bash
brew tap deepakk33/tap
```

## Casks

### [MacBreak](https://github.com/deepakk33/macbreak)

A break reminder that holds the screen until the rest is actually over — a 30
second eye rest every 30 minutes, a 10 minute walk every 2 hours.

```bash
brew install --cask deepakk33/tap/macbreak
open -a MacBreak        # then tick "Start at login"
```

Uninstall:

```bash
brew uninstall --cask macbreak          # stops it and removes the login agent
brew uninstall --zap --cask macbreak    # also forgets your saved intervals
```
