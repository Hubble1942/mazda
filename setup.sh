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
