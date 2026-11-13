# ZimaOS Dotfiles

Shell dotfiles for ZimaOS: `.bashrc`, `.bash_profile`, and `.wgetrc`. The setup is a Solarized-inspired Bash prompt, practical aliases, and wget settings that fit an immutable, minimal Linux environment (no `xclip`, `pbcopy`, or `git` by default).

## Status

2026-11-13, Europe/Berlin: public repository on the repo standard. The license is PolyForm Noncommercial 1.0.0. Versions published before this commit remain under CC0-1.0. Axel is the sole contributor.

## Start here

1. `AGENTS.md`
2. This file
3. `BUGFIXES.md` and `SECURITY.md`
4. `HANDOFF.md`, the last three entries in `CHANGELOG.md`, and `git log -5`. `HANDOFF.md` is gitignored in this public repository.
5. The current ticket, or else `TODO.md` and `ROADMAP.md`
6. `docs/README.md`

## Layout

| Path | What |
| --- | --- |
| `AGENTS.md` | Agent rules. `CLAUDE.md` is a symlink to this file. |
| `README.md` | This page. |
| `CHANGELOG.md` | What changed, newest first. |
| `ROADMAP.md` | Now, next, later, ideas, done recently. |
| `TODO.md` | Interim tasks until the agent-ops board exists. |
| `BUGFIXES.md` | Durable bug writeups (`BF-NNN`). vi and nano limits live here. |
| `HANDOFF.md` | Done, next, open questions. Tracked in a private repo. Gitignored in a public repo. |
| `SECURITY.md` | Threat model and where secrets live. |
| `LICENSE` | Rights for this repo. |
| `justfile` | Recipes. `just` lists them. `just setup` installs the git hook. Imports `just/dotfiles.just`. |
| `just/dotfiles.just` | Preview recipe. It does not apply these files. |
| `docs/` | Longer docs. Index: `docs/README.md`. |
| `.bashrc` | Interactive shell: prompt, aliases, and welcome text. |
| `.bash_profile` | Login shell. Sources the bashrc. |
| `.wgetrc` | wget settings. |
| `.env.example` | Setting names only. This repo has no settings. |
| `.githooks/` | `pre-commit` runs the secret check. |
| `scripts/check-secrets.sh` | Secret check for the working tree, the index, or history. |

## Features

### Prompt

* **Dynamic Solarized Prompt**: Displays `username@hostname:directory ➜ $` with:
  * Username and hostname in light gray (`tput setaf 247`, Solarized Base1).
  * Directory in a slightly darker gray (`tput setaf 244`, Solarized Base0).
  * A dynamic arrow (`➜`) in green (`tput setaf 100`) for command success or red (`tput setaf 124`) for failure.
  * Prompt symbol (`$` or `#`) in yellow (`tput setaf 136`).
* **Example**: `<username>@<yourhostname>:~/Sites ➜ $` (green arrow after a successful `ls`).

The prompt uses the generic username and hostname escapes. It does not name a machine.

### Welcome Message

* **ASCII Art**: A stylish "Zima OS" banner in yellow, followed by a break for readability:
```
 ____  __  _  _   __      __   ____ 
(__  )(  )( \/ ) / _\    /  \ / ___)
 / _/  )( / \/ \/    \  (  O )\___ \
(____)(__)\_)(_/\_/\_/   \__/ (____/
```
* **Greeting**: `─── Welcome to Zima OS, username ───` with yellow dashes and the username in light gray.
* **Info**: Date (e.g., "Thursday, April 03, 2040") and uptime (e.g., "up 2 hours, 15 minutes") in default terminal color.

### Color Support

* **Colored `ls`**: Uses `dircolors` to enable colored output for `ls` (e.g., blue directories, green executables).
* **Customization Tip**: Edit `~/.dircolors` (if writable) for Solarized-specific colors.

### History Settings

* **Command History**: Stores up to 1000 commands in memory (`HISTSIZE`) and 2000 in `~/.bash_history` (`HISTFILESIZE`).
* **Behavior**: Ignores duplicates and space-prefixed commands (`ignoreboth`), appends to history file (`histappend`).

### Tab Completion

* **Optional Completion**: Sources `/etc/bash_completion` if available for enhanced tab completion (e.g., command options).

### Aliases

#### Common Shortcuts

* `ll`: `ls -la` — Lists all files (including hidden) in long format.
* `l`: `ls -l` — Long listing without hidden files.
* `cls`: `clear` — Clears the terminal screen.

#### System Monitoring

* `ttop`: `top -d 2 -n 30` — Runs `top` with 2-second updates for 30 iterations.
* `mem`: `free -h` — Shows memory usage (if `free` exists).
* `cpu`: `top -n 1` — Quick CPU/process snapshot.
* `pg`: `ps aux | grep -i` — Searches processes (e.g., `pg bash`).
* `df`: `df -h` — Shows disk usage in human-readable format (if `df` exists).
* `stat`: Prints uptime and memory status (e.g., "Uptime: up 2 hours | Memory: ...").

#### Network Tools

* `listen`: Lists listening ports using `lsof` or `netstat` (falls back if one isn’t available).

#### Directory Navigation

* `..`: `cd ..` — Moves up one directory level.
* `...`: `cd ../..` — Moves up two directory levels.

#### File Management

* `rm`: `rm -i` — Prompts before removing files for safety.
* `size`: `du -h` — Shows file/directory size (e.g., `size file.txt`).
* `la`: Alias for `ll`.
* `h`: `history | grep` — Searches command history (e.g., `h cd`).

#### Nerd Stuff (Playful Aliases)

* `wtf`: `dmesg` — System logs.
* `rtfm`: `man` — Manual pages.
* `visible`: `echo` — Prints text.
* `invisible`: `cat` — Displays file contents.
* `moar`: `more` — Paginates output.
* `icanhas`: `mkdir` — Creates directories.
* `donotwant`: `rm` — Removes files (with `rm -i` prompt).
* `dowant`: `cp` — Copies files.
* `gtfo`: `mv` — Moves files.
* `hai`: `cd` — Changes directory.
* `plz`: `/bin/pwd` — Prints current directory.
* `nomz`: `ps aux | less` — Lists processes with pagination.
* `nomnom`: `killall` — Kills processes by name.
* `cya`: `reboot` — Reboots the system.
* `kthxbai`: `halt` — Shuts down the system.

### Autocd

* **Feature**: Enables changing directories by typing their names (e.g., `Downloads` instead of `cd Downloads`), if Bash 4.0+ supports it. Falls back with a note if unavailable.

### Wget Configuration

* **File**: `wgetrc` — Customizes `wget` behavior for efficient downloads, optimized for ZimaOS.
* **Settings**:
* `timestamping = on`: Uses server-provided last modification dates.
* `dns_timeout = 30`: 30-second timeout for DNS lookups.
* `connect_timeout = 30`: 30-second timeout for connection attempts.
* `read_timeout = 120`: 120-second timeout for reading data.
* `tries = 5`: Retries downloads 5 times on failure.
* `waitretry = 10`: Waits 10 seconds between retries.
* `retry_connrefused = on`: Retries even if the connection is refused.
* `continue = on`: Resumes interrupted downloads.
* `trust_server_names = on`: Uses redirection URL’s last component for local filenames.
* `follow_ftp = off`: Disables following FTP links from HTML.
* `adjust_extension = on`: Adds `.html` or `.css` extensions based on MIME types.
* `robots = off`: Ignores `robots.txt` and nofollow tags for unrestricted downloads.
* `verbose = on`: Provides detailed feedback during downloads.
* `reject = exe,tar.gz,rar,dmg,iso`: Excludes specified file types, allowing `.zip` downloads.
* **Optional Settings (Commented)**:
* `no_parent`: Prevents ascending directory structures in recursive downloads.
* `reclevel`: Sets maximum recursion depth (e.g., 5).
* `dir_prefix`: Defines a download directory (e.g., `~/downloads`).
* `concurrent`: Sets concurrent connections (e.g., 5).

## Installation

These steps are for a person at the machine. An agent working in this repository does not apply the files, does not open a shell on a host, and does not change a live home directory. `just preview` only prints a reminder.

### Files

* **`.bashrc`**: The main configuration file with prompt, aliases, and welcome message.
* **`.bash_profile`**: A login shell script that sources `.bashrc` automatically on SSH login, ensuring the configuration loads without manual intervention.
* **`.wgetrc`**: A configuration file for `wget` to optimize downloading behavior.

### Steps

1. **Download All Files**:
 * Since ZimaOS lacks `git`, use `curl` or `wget` to fetch from the repository:
   ```bash
   sudo curl -o /DATA/.bashrc https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/main/.bashrc
   sudo curl -o /DATA/.bash_profile https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/main/.bash_profile
   sudo curl -o ~/.wgetrc https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/refs/heads/main/.wgetrc
   ```
   Or with `wget`:
   ```bash
   sudo wget -O /DATA/.bashrc https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/main/.bashrc
   sudo wget -O /DATA/.bash_profile https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/main/.bash_profile
   sudo wget -O ~/.wgetrc https://raw.githubusercontent.com/axelquack/dotfiles-zimaos/refs/heads/main/.wgetrc
   ```
 * Notes:
   * `.bashrc` and `.bash_profile` go in `/DATA/` (ZimaOS-specific).
   * `.wgetrc` goes in `~/` (standard `wget` user config location).

2. **Set Permissions**:
 * Ensure both files are readable:
   ```bash
   sudo chmod 644 /DATA/.bashrc /DATA/.bash_profile ~/.wgetrc
   ```

3. **Source Bash Configuration**:
 * Apply the Bash configuration for the current session:
   ```bash
   source /DATA/.bashrc
   ```
 * On subsequent SSH logins, `.bash_profile` will autoload `.bashrc`.

## Usage

* **Bash Prompt**: Run commands and watch the `➜` turn green (success) or red (failure).
* **Bash Welcome**: Open a terminal or SSH in to see the "Zima OS" banner and greeting.
* **Bash Aliases**: Use shortcuts like `ll`, `ttop`, `df`, `stat`, or `nomz` for quick tasks.
* **Safety**: `rm` prompts for confirmation (e.g., `donotwant file.txt` asks before deleting).
* **Wget Downloads**: Use `wget` with customized settings:
* Example: `wget https://example.com/file.zip` — Downloads `.zip` files with timestamping, retries, etc.
* Recursive: `wget -r https://example.com/` — Downloads a site, unrestricted by `robots.txt`.

## Customization

* **Bash Colors**: Adjust `tput setaf` values (e.g., `136` for yellow) in the `# PROMPT` section of `.bashrc`.
* **Bash Aliases**: Add or modify aliases under `# ALIASES` in `.bashrc`.
* **Bash Welcome**: Tweak the ASCII art or message in the `# Welcome message` section of `.bashrc`.
* **Autoload**: Modify `.bash_profile` for additional login shell customizations.
* **Wget Settings**: Edit `~/.wgetrc` to uncomment and set optional parameters (e.g., `reclevel = 5`, `dir_prefix = /downloads`).
* **Editors**: vi and nano stay minimal. See `docs/vi_nano_summary.md` and `BUGFIXES.md`.

## Requirements

* **ZimaOS**: Optimized for this immutable OS, but works on any Bash-compatible Linux system.
* **Tools**: Assumes `tput`, `dircolors`, `top`, `free`, `df`, `uptime`, `ps`, `grep`, `ls`, `wget`, etc., are available. Fallbacks (e.g., `echo unknown`) handle missing tools gracefully.
* **curl or wget**: Required for downloading from GitHub, as ZimaOS lacks `git`.

## Contributing

Fork this repository and open a pull request. Suggestions for new aliases, ASCII art, or ZimaOS-specific tweaks are welcome. Changes to `main` go through a pull request.

`just` lists the recipes. `just setup` points this clone at `.githooks`. `just preview` does not copy files onto a machine.

## License

PolyForm Noncommercial 1.0.0. See `LICENSE`.

Axel is the sole contributor.

Versions published before this commit remain under CC0-1.0.
