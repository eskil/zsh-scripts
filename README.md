# zsh scripts

Collection of various zsh scripts/commands I use. These can be dumped into `$ZSH_CUSTOM`.

## `set_tab.zsh`

Function to change iterm2 tab name/color. Picks a consistent color from the given name if no color name is passed.

```zsh
set_tab ERC
set_tab ERC green
```

## `set_badge.zsh`

Function to change iterm2 badge.

```zsh
set_badge PROD
```

## `kcluster.zsh`

* fuzzy picker to pick a kubeconfig file from `~/.kube`.
* changes iterm2 badge to the cluster name
* omz/p10k prompt segment function

Add `kubefile` to `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` in `~/.p10k.zsh` to get the current cluster in your prompt.

```diff
--- ~/.p10k.zsh	2025-08-13 12:01:31
+++ ~/.p10k.zsh	2025-08-13 12:01:31
@@ -33,6 +33,7 @@
   typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
     # =========================[ Line #1 ]=========================
     os_icon                 # os identifier
+    kubefile                # github/eskil/zsh-scripts: custom/kcluster controlled kubeconfig
     dir                     # current directory
     vcs                     # git status
     # =========================[ Line #2 ]=========================
```

Here's a shot of the `kcluster` command, prompt and badge;


![CleanShot 2025-09-29 at 10 46 58](https://github.com/user-attachments/assets/76e77199-e867-4c87-92a6-635781c9a706)


For the blinking ☠️ in the prompt, you have to enable blinking text in iterm2
<img width="800" height="600" alt="CleanShot 2025-09-29 at 10 28 56@2x" src="https://github.com/user-attachments/assets/f9da89da-496d-44d5-a2f2-1fa735379214" />


## `kubectls`

Mediocre utilities for k8s. I wouldn't touch these.

* `getpod namespace podname` gets the first pod named `podname.*` in `namespace`
* `tailpod namespace podname` tails through jq logs from `getpod ...`

## See also

* https://github.com/eskil/zsh-iterm2-gitrepo-tabtitlecolor, autoset iterm2 tab & color by git repo name
