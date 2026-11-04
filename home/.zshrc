# Oh My Zsh -- see https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template
# for all available settings.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"

# Custom theme from $ZSH_CUSTOM/themes
ZSH_THEME="mazda"

# ssh-agent is set up in ~/.shellrc
plugins=(git virtualenv)

source "$ZSH/oh-my-zsh.sh"

# Settings shared with bash
[ -f ~/.shellrc ] && . ~/.shellrc
