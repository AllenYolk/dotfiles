# Zed Configuration

Zed has no built-in settings sync, so this repository is the sync mechanism. `zed/settings.json` and `zed/keymap.json` are the managed sources; on each machine the matching files under `~/.config/zed/` are symlinks into this repository. Every change made in Zed's Settings Editor or keymap editor therefore lands in the working tree and travels with a commit.

Read the [Linking Protocol](linking.md) before deployment.

## Managed and Unmanaged Files

| Path | Managed | Reason |
| --- | --- | --- |
| `~/.config/zed/settings.json` | Yes | User settings |
| `~/.config/zed/keymap.json` | Yes | User key bindings |
| `~/.config/zed/prompts/` | No | LMDB prompt library, machine-local state |
| `~/.config/zed/themes/` | No | Local theme files; add one to the repository only on request |
| `~/Library/Application Support/Zed/` (macOS) | No | Extensions, credentials, database, logs |

Nothing under the unmanaged paths may be committed. Settings must not contain API keys or tokens; configure providers through Zed's own credential store or the environment.

## Dependencies

The Zed application is required. Confirm the configuration directory before linking; do not create a guessed directory tree.

| Platform | Configuration directory |
| --- | --- |
| macOS | `~/.config/zed` |
| Linux | `~/.config/zed`, or `$XDG_CONFIG_HOME/zed` when set |

## Setup

Handle each of the two files independently. After confirmation and only when the target is absent, create one link per file:

```bash
repo=$(git rev-parse --show-toplevel)
ln -s "$repo/zed/settings.json" "$HOME/.config/zed/settings.json"
ln -s "$repo/zed/keymap.json" "$HOME/.config/zed/keymap.json"
```

If the target exists as a regular file, stop work on that file and report it. Adopting an existing file is a separate, explicit decision: move its content into `zed/` first, confirm the result, then link.

`keymap.json` may not exist on a machine that has never customized key bindings; the repository file is an empty list and Zed reads it as such.

## Daily Sync Workflow

Zed writes to the symlink target, so the repository working tree changes without any export step.

1. Change settings in Zed, or edit `zed/settings.json` directly.
2. In the repository, review `git diff` and commit the change.
3. On another machine, `git pull`. The existing symlinks pick the change up; restart Zed or reload the window if a setting does not apply live.

Installed extensions are not part of this workflow. Declare them in `settings.json` instead so every machine installs the same set:

```json
{
  "auto_install_extensions": {
    "html": true,
    "dockerfile": true
  }
}
```

## Verification

```bash
readlink ~/.config/zed/settings.json
readlink ~/.config/zed/keymap.json
```

Both must resolve inside this repository. Then open Zed, run `zed: open settings file`, and confirm the editor shows the repository path. Changing one harmless setting, such as `ui_font_size`, should leave a modification in `git status`.
