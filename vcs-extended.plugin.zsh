#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ':vcs_info:git*+set-message:*' hooks _zsh_vcs_extended_hook_untracked

_zsh_vcs_extended_precmd() {
    local untracked=0

    case $(_zsh_vcs_extended_filesystem) in
        osxfuse|sshfs|smbfs|fuseblk)
            unset ${(kM)parameters:#vcs_info_msg_*_}
            ;;

        *)
            LANG=en_US.UTF-8 vcs_info
            ;;
    esac
}

_zsh_vcs_extended_filesystem() {
    case $OSTYPE in
        darwin*)
            mount | grep $(df -P . | cut -d' ' -f1 | tail -n1) | sed -E 's/.*\(|,.*//g'
            ;;

        *)
            stat -f -L -c %T .
            ;;
    esac
}

_zsh_vcs_extended_has_untracked() {
    git rev-parse --is-inside-work-tree &> /dev/null && git status --porcelain | grep -q '^??'
}

+vi-_zsh_vcs_extended_hook_untracked() {
    local untrackedstr
    zstyle -g untrackedstr ':vcs_info:git:*' untrackedstr

    if (( $untracked )) || ! _zsh_vcs_extended_has_untracked; then
        return 0
    fi

    untracked=1
    hook_com[unstaged]+=$untrackedstr
}

add-zsh-hook precmd _zsh_vcs_extended_precmd
