# Changelog

All notable changes to this project will be documented in this file.

The format is based on **Keep a Changelog**
<https://keepachangelog.com/en/1.1.0/>
and this project adheres to **Semantic Versioning**
<https://semver.org/spec/v2.0.0.html>

---

## [0.2.0] - 2026-04-15

### Added

- Multi-selection system with visual indicators (`*`)
- Clipboard functionality:
  - Copy (`y`)
  - Cut (`x`)
  - Paste copy (`p`)
  - Paste move (`P`)

- Collision detection with warning indicator (`⚠`)
- Status bar showing:
  - Current directory
  - Clipboard mode (COPY / CUT)
  - Clipboard item count
  - Selected items count

- Help bar with keybindings
- Directory creation mode (`m`) with live input buffer

### Improved

- Rendering performance:
  - Eliminated flickering by avoiding full screen redraw
  - Implemented cursor-based partial rendering

- Scroll behavior:
  - Centered viewport around selected item

- Navigation:
  - Restores cursor position when returning to parent directory

- UI consistency:
  - Proper alignment using Nerd Font icons

- Input handling:
  - Centralized into a single input loop (removed conflicting readers)

### Fixed

- ANSI color issues:
  - Prevented color bleeding between lines
  - Ensured proper reset (`sgr0`) after each render line
  - Added global terminal reset at render start

- Directory color detection:
  - Fixed bug caused by mixing ANSI codes with filenames

- Selection highlighting:
  - Fixed incorrect visual state for selected items

- Clipboard bugs:
  - Cleared selection after copy/move operations
  - Prevented stale selections after paste

- Input mode issues:
  - Fixed Enter key handling in directory creation mode
  - Removed lag and skipped characters
  - Ensured status bar remains visible in all modes

- File operations:
  - Fixed incorrect paths in `cp` and `mv`

- UI glitches:
  - Removed debug output interfering with rendering
  - Fixed inconsistent line clearing

### Refactored

- Code structure:
  - Separated input, rendering, and filesystem logic

- Rendering pipeline:
  - Introduced metadata caching (`FILE_META`)
  - Removed subshell overhead in render loop

- Input system:
  - Enforced single source of input handling
  - Removed duplicate `read` calls across functions

---

## [0.1.0] - Initial Release

### Added

- Basic file browser
- Directory navigation with arrow keys
- File listing
- Simple terminal rendering
