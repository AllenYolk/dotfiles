# Ghostty Configuration

The repository file `ghostty-config` sets Catppuccin Macchiato, MesloLGS NF at 12pt, and SSH shell integration. It contains no credentials or host information.

## Dependencies

The Ghostty application and the `MesloLGS NF` font are required. Ghostty resolves the theme name from its bundled theme set. SSH shell integration applies only when SSH is used and requires appropriate terminal support and terminfo on the remote system. Use `ghostty +show-config --default --docs` to check that the CLI is available and the theme is recognized. If the application or font is missing, report the requirement without changing system fonts or guessing an installation path.

## Target Paths

The target differs by platform. Confirm the actual Ghostty installation and configuration path with `ghostty +show-config --default --docs` or the local application documentation:

| Platform | Common target |
| --- | --- |
| macOS | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Linux (XDG) | `$XDG_CONFIG_HOME/ghostty/config`; `$HOME/.config/ghostty/config` when unset |

These paths are references only. An agent must not create a guessed directory tree.

## Setup and Verification

After confirmation and only when the confirmed target is absent, create one link from `ghostty-config` to that target. Reload Ghostty configuration or open a new window, then confirm the theme, font, and SSH shell integration.

If `MesloLGS NF` is absent, report the missing font and possible alternatives. Do not modify system fonts or change the repository configuration.
