# 🗂️ Bash File Browser

A fast, minimal, and keyboard-driven file browser written in pure Bash.
Inspired by tools like `ranger` and `lf`, but built from scratch with a custom TUI.

---

## ✨ Features

- 📁 Directory navigation with arrow keys
- ⭐ Multi-selection system
- 📋 Clipboard operations:
  - Copy (`y`)
  - Paste (`p`)
  - Move (`P`)

- ⚠ Collision detection (duplicate filename warning)
- 🎯 Centered scrolling
- 🎨 Colored output (directories, files, selection)
- 🧠 Metadata caching for performance
- 🧾 Status bar with real-time info
- 🧰 Help bar with keybindings
- 📁 Create directories (`m`)
- 🚀 Flicker-free rendering

---

## ⌨️ Keybindings

| Key   | Action                 |
| ----- | ---------------------- |
| ↑ / ↓ | Move selection         |
| →     | Enter directory        |
| ←     | Go to parent directory |
| Space | Select / unselect item |
| y     | Copy selected items    |
| p     | Paste (copy)           |
| P     | Paste (move)           |
| d     | Delete selected items  |
| r     | Rename (single file)   |
| m     | Create directory       |
| q     | Quit                   |

---

## 🖥️ UI Overview

- **Help bar** → top line with shortcuts
- **File list** → main viewport
- **Status bar** → bottom line with:
  - current path
  - clipboard mode
  - selection count

---

## 🧠 Architecture

The application is structured into modular components:

- `main.sh` → main loop
- `ui.sh` → rendering & UI
- `input.sh` → keyboard handling
- `fs.sh` → filesystem logic
- `state.sh` → global state
- `icons.sh` → icon definitions
- `colors.sh` → ANSI color config

### Design principles

- Single input loop
- Stateless rendering
- Cached metadata (`FILE_META`)
- No subshells in render loop
- Minimal terminal redraw

---

## ⚙️ Requirements

- Bash 5+
- `tput`
- Nerd Font (for icons)

---

## 🚀 Usage

```bash
chmod +x main.sh
./main.sh
```

---

## 🧪 Known Limitations

- No mouse support
- No file preview (yet)
- No sorting/filtering (planned)
- Basic input line (no cursor editing yet)

---

## 🛣️ Roadmap

- 🔍 Search / fuzzy finder
- 📄 File preview panel
- ↕ Sorting (name, size, type)
- 🧠 Command mode (like Vim `:`)
- 📂 Tabs or bookmarks
- ⚡ Async file operations

---

## 🤝 Contributing

Contributions are welcome!
Feel free to open issues or submit pull requests.

---

## 📜 License

## ![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)

## © Copyright

© 2026 Hugo Morago Martín. All rights reserved.

---

## ⚠️ Disclaimer

This software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of:

merchantability
fitness for a particular purpose
noninfringement

In no event shall the authors or copyright holders be liable for any claim,
damages, or other liability, whether in an action of contract, tort, or
otherwise, arising from:

the use of this software
or other dealings in the software

Use at your own risk.

---

## 💡 Inspiration

- ranger
- lf
- nnn

---

## 👀 Preview (idea)

```
📁 /home/user/projects

> 📁 src
  📁 docs
  ⚠ 📄 README.md
  📄 main.sh

📁 /home/user/projects | 📋 COPY ⚠ | 📋 2 | ⭐ 1
```
