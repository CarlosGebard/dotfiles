# Plan: replace Tetris launcher with ChatGPT Desktop

## Goal

Make Helium start normally without forcing X11, replace the Tetris rofi entry with ChatGPT Desktop, and remove the local Tetris launcher.

## Scope

- Update the Helium desktop entry.
- Update the rofi whitelist priority previously used by Tetris.
- Remove the Tetris desktop entry from this dotfiles repository.
- Attempt to remove the installed `tetris-tui` executable.

## Assumptions

- The installed ChatGPT Desktop package provides `/usr/share/applications/ChatGPT.desktop`.
- The rofi whitelist uses desktop IDs without the `.desktop` suffix.
- Removing the local Tetris desktop entry is enough to remove it from the launcher list managed by these dotfiles.

## Steps

1. Remove the X11 ozone flag from `applications/helium.desktop`.
2. Replace priority `40` in `.config/rofi/whitelist.tsv` with `ChatGPT Desktop` targeting `ChatGPT`.
3. Delete `applications/tetris.desktop`.
4. Remove the active symlink at `~/.local/share/applications/tetris.desktop`.
5. Attempt to delete `/usr/local/bin/tetris-tui`.

## Validation

- Search for remaining Tetris and X11 ozone references in launcher/config files.
- Validate relevant `.desktop` files when `desktop-file-validate` is available.
- Run `bin/rofi-whitelist` and verify ChatGPT Desktop appears with the expected icon.
- Check whether `tetris-tui` remains in `PATH`.

## Risks

- `/usr/local/bin/tetris-tui` may require an interactive root password and cannot be removed non-interactively from this session.
