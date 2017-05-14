zsh-vcs-extended
================

This plugin extends vcs_info so it processes more wisely. The current filesystem
is automatically considered in order not to slow down the prompt to be appeared.

`vcs_info` will be called by this plugin provided `PWD` is not under the remote
mount point. Do *NOT* call it by yourself.

# Untracked file/folder(s)

An option that indicates the untracked file/folder(s) is available with:

```zsh
zstyle ':vcs_info:git:*' untrackedstr "!"
```
