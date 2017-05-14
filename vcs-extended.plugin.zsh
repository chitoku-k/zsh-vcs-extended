#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ':vcs_info:git*+set-message:*' hooks _zsh_vcs_extended_hook_untracked

_zsh_vcs_extended_precmd() {
    if [[ $(_zsh_vcs_extended_filesystem) =~ 'osxfuse|sshfs|smbfs|fuseblk' ]]; then
        unset vcs_info_msg_0_
        unset vcs_info_msg_1_
        unset vcs_info_msg_2_
    else
        LANG=en_US.UTF-8 vcs_info
    fi
}

_zsh_vcs_extended_filesystem() {
    case "$OSTYPE" in
        darwin*)
            mount | grep $(df -P . | cut -d' ' -f1 | tail -n1) | sed -E 's/.*\(|,.*//g'
            ;;
        *)
            stat -f -L -c %T .
            ;;
    esac
}

_zsh_vcs_extended_has_untracked() {
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && git status --porcelain | grep '??' &> /dev/null
}

+vi-_zsh_vcs_extended_hook_untracked() {
    local str
    zstyle -g str ':vcs_info:git:*' untrackedstr

    if [[ "$1" != "1" ]] || [[ -z "$str" ]] || ! _zsh_vcs_extended_has_untracked; then
        return 0
    fi

    hook_com[unstaged]+=$str
}

add-zsh-hook precmd _zsh_vcs_extended_precmd
