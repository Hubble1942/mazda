# mazda

My bash and zsh dotfiles.

## Prerequisites

- bash
- zsh and [Oh My Zsh](https://ohmyz.sh/#install) (optional, for the zsh setup)

`setup.sh` does not install either of them.

## Install

```sh
git clone <this repo> ~/mazda
~/mazda/setup.sh
```

`setup.sh` symlinks every file in `home/` into `$HOME`. Any file in the way is
moved to `<name>.bak-<timestamp>`. Run it again after adding
files or installing Oh My Zsh.

## Layout

| File | Purpose |
| --- | --- |
| `home/.profile` | Login shells: `PATH` |
| `home/.zprofile` | zsh login shells: reads `.profile` |
| `home/.shellrc` | Settings shared by bash and zsh: `EDITOR`, `LESS`, aliases |
| `home/.bashrc` | bash interactive shells |
| `home/.zshrc` | zsh interactive shells (Oh My Zsh) |
| `home/.oh-my-zsh/custom/themes/mazda.zsh-theme` | zsh prompt |
| `home/.git-plugin-bash.sh` | Oh My Zsh git aliases for bash (generated) |

Both shells share one ssh-agent:

1. a forwarded agent, if `SSH_AUTH_SOCK` is already set
2. on WSL, the Windows ssh-agent through
   [wsl2-ssh-agent](https://github.com/mame/wsl2-ssh-agent). `setup.sh`
   downloads a pinned, hash-checked release to `~/.local/bin`
3. the systemd user agent (`ssh-agent.socket`)
4. an agent on `~/.ssh/agent.sock`

`setup.sh` adds `AddKeysToAgent yes` to `~/.ssh/config` unless the option is
already set there, so keys are loaded on first use.

Machine-specific settings that should not be committed go in `~/.local_env`.
`.shellrc` sources it if it exists.

## Updating the bash git aliases

`home/.git-plugin-bash.sh` is generated from the installed Oh My Zsh git plugin:

```sh
tools/update-git-plugin-bash.sh
```
