#!/bin/bash
# Symlink every file in home/ into $HOME. A file that is in the way is moved
# to <name>.bak-<timestamp>. Safe to run repeatedly.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$ROOT_DIR/home"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Prerequisites are not installed automatically
if ! command -v zsh >/dev/null; then
  echo "warning: zsh is not installed, only the bash config will be usable" >&2
fi

# Linking into ~/.oh-my-zsh before Oh My Zsh is installed would make its
# installer refuse to run, so only do it once it exists.
skip_omz=()
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  echo "warning: Oh My Zsh is not installed, skipping the zsh theme." >&2
  echo "         Install it (https://ohmyz.sh/#install), then run $0 again." >&2
  skip_omz=(-not -path './.oh-my-zsh/*')
fi

cd "$SRC_DIR"
find . -type f "${skip_omz[@]}" -print0 | while IFS= read -r -d '' rel; do
  rel="${rel#./}"
  src="$SRC_DIR/$rel"
  dest="$HOME/$rel"

  if [ "$(readlink "$dest" || true)" = "$src" ]; then
    continue # already linked
  fi

  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak-$STAMP"
    echo "backed up ~/$rel -> ~/$rel.bak-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked ~/$rel"
done

# On WSL, install wsl2-ssh-agent so the shells can use the Windows ssh-agent
# (see ~/.shellrc). The release is pinned and checked against known hashes, as
# upstream publishes no checksums. To upgrade, bump the version and hashes.
WSL2_SSH_AGENT_VERSION=v0.9.7
WSL2_SSH_AGENT="$HOME/.local/bin/wsl2-ssh-agent"
if [ -n "${WSL_DISTRO_NAME:-}" ] && [ ! -x "$WSL2_SSH_AGENT" ]; then
  case "$(uname -m)" in
    x86_64)  asset=wsl2-ssh-agent       sha=281c64f6079598de1a455292d533f3ae21837980a3d3012074bc14ad695325d8 ;;
    aarch64) asset=wsl2-ssh-agent-arm64 sha=e9cb0347a72ca68a511e48779080b80a22af1bf670e5a52c9f35f95951ce5221 ;;
    *)       asset= ;;
  esac
  if [ -z "$asset" ]; then
    echo "warning: no wsl2-ssh-agent build for $(uname -m), skipping" >&2
  elif ! command -v curl >/dev/null; then
    echo "warning: curl is not installed, skipping wsl2-ssh-agent" >&2
  else
    mkdir -p "$(dirname "$WSL2_SSH_AGENT")"
    tmp="$(mktemp "$WSL2_SSH_AGENT.XXXXXX")"
    url="https://github.com/mame/wsl2-ssh-agent/releases/download/$WSL2_SSH_AGENT_VERSION/$asset"
    if curl -fsSL -o "$tmp" "$url" && echo "$sha  $tmp" | sha256sum -c --status; then
      chmod 755 "$tmp"
      mv "$tmp" "$WSL2_SSH_AGENT"
      echo "installed wsl2-ssh-agent $WSL2_SSH_AGENT_VERSION to ~/.local/bin"
    else
      rm -f "$tmp"
      echo "warning: downloading or verifying $url failed, skipping wsl2-ssh-agent" >&2
    fi
  fi
fi

# Have ssh add keys to the agent on first use. ~/.ssh/config is not managed by
# this repo, so only add the option if it isn't configured anywhere yet. It goes
# at the top of the file: appended at the end it would only apply to the last
# Host block.
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -qiE '^[[:space:]]*AddKeysToAgent([[:space:]]|=)' "$SSH_CONFIG" 2>/dev/null; then
  mkdir -p -m 700 "$HOME/.ssh"
  touch "$SSH_CONFIG"
  chmod 600 "$SSH_CONFIG"
  { printf '%s\n\n' 'AddKeysToAgent yes'; cat "$SSH_CONFIG"; } > "$SSH_CONFIG.tmp"
  chmod 600 "$SSH_CONFIG.tmp"
  mv "$SSH_CONFIG.tmp" "$SSH_CONFIG"
  echo "added AddKeysToAgent yes to ~/.ssh/config"
fi
