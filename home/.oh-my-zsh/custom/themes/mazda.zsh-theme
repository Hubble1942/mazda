# Based on tjkirch, but with shortened path on the prompt
# See https://unix.stackexchange.com/a/273567

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_VIRTUALENV_PREFIX=" %{$fg[cyan]%}("
ZSH_THEME_VIRTUALENV_SUFFIX=")%{$reset_color%}"

PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%}
)
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%}$(git_prompt_info)$(virtualenv_prompt_info)
%(!.%{$fg[red]%}#%{$reset_color%}.$) '

RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
