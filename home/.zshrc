# Oh My Zsh -- see https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template
# for all available settings.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"

# Custom theme from $ZSH_CUSTOM/themes
ZSH_THEME="mazda"

# ssh-agent plugin: load identities lazily, support agent forwarding
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent agent-forwarding yes

plugins=(git ssh-agent virtualenv)

source "$ZSH/oh-my-zsh.sh"

# Settings shared with bash
[ -f ~/.shellrc ] && . ~/.shellrc
