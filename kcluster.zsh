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
	  color="%F{red}"       # red for prod
	  ;;
      *stag*|*Stag*|*STAG*)
	  color="%F{yellow}"    # yellow for staging
	  ;;
      *dev*|*Dev*|*DEV*)
	  color="%F{green}"     # green for dev
	  ;;
      *)
	  color="%F{cyan}"      # cyan for anything else
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
      *prod*|*Prod*|*PROD*) color=red ;;
      *stag*|*Stag*|*STAG*) color=yellow ;;
      *dev*|*Dev*|*DEV*)    color=green ;;
      *)                    color=cyan ;;
    esac
    p10k segment -f "$color" -t "$name"
  fi
}
