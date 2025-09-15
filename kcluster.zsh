#
# Requires fzf is installed
# brew install fzf
#
kcluster() {
  local kube_dir="$HOME/.kube"
  local selected

  # Find *.yaml files in ~/.kube and fuzzy select one
  selected=$(find "$kube_dir" -maxdepth 1 -type f -name '*.yaml' | fzf --prompt="Select KUBECONFIG: " --height=40% --reverse)

  if [[ -z "$selected" ]]; then
    echo "No file selected."
    return 1
  fi

  export KUBECONFIG="$selected"
  echo "KUBECONFIG set to: $KUBECONFIG"
  printf "\033]1337;SetBadgeFormat=%s\007"  "$(echo "${KUBECONFIG:t:r}" | base64)"
  set_tab ${KUBECONFIG:t:r}
}

# Show kubeconfig file name without path/extension, color-coded
kubefile_segment() {
  if [[ -z "$KUBECONFIG" ]]; then
    return
  fi

  local name="${KUBECONFIG:t:r}"
  local color

  case "$name" in
      *prod*|*Prod*|*PROD*)
	  color="%F{brightred}%K{red}"
	  ;;
      *stag*|*Stag*|*STAG*)
	  color="%F{yellow}"
	  ;;
      *dev*|*Dev*|*DEV*)
	  color="%F{green}" 
	  ;;
      *)
	  color="%F{cyan}"  
	  ;;
  esac
  
  # Print with color and reset
  print -n "${color}${name}%f"
}

# Custom kubeconfig segment for oh-my-zsh/p10k
function prompt_kubefile() {
  if [[ -n "$KUBECONFIG" ]]; then
    local name="${KUBECONFIG:t:r}"
    local color
    case "$name" in
	*prod*|*Prod*|*PROD*)
	    fg=brightred
	    bg=red
	    text="$name"$' %{\e[5m%}☠️%{\e[25m%}%f%k'
	    ;;
	*stag*|*Stag*|*STAG*)
	    fg=yellow
	    bg=black
            text="$name"
	    ;;
	*dev*|*Dev*|*DEV*)
	    fg=green
	    bg=black
            text="$name"
	    ;;
	*)
	    fg=cyan
	    bg=black
            text="$name"
	    ;;
    esac
    p10k segment -f "$fg" -b "$bg" -t "$text"
  fi
}
