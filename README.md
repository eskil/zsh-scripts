# zsh scripts

Collection of various zsh scripts/commands I use. These can be dumped into `$ZSH_CUSTOM`.

## `set_tab`

Function to change iterm2 tab name/color. Picks a consistent color from the given name if no color name is passed.

```
set_tab ERC
set_tab ERC green
```

## `kcluster`

* fuzzy picker to pick a kubeconfig file from `~/.kube`.
* changes iterm2 badge to the cluster name
* omz/p10k prompt segment function

Add `kubefile` to `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` in `~/.p10k.zsh` to get the current cluster in your prompt.

See also
* https://github.com/eskil/zsh-iterm2-gitrepo-tabtitlecolor
