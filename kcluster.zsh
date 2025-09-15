#
# Requires fzf is installed
# brew install fzf
#

kubefile_cc_segment() {
  if [[ -z "$KUBECONFIG" ]]; then
    return
  fi

  local name="${KUBECONFIG:t:r}"
  local color_reset="\033[0m"
  local color

  case "$name" in
      *prod*|*Prod*|*PROD*)
          color="\033[31m" 
          ;;
      *stag*|*Stag*|*STAG*)
          color="\033[33m" 
          ;;
      *dev*|*Dev*|*DEV*)
          color="\033[32m"
          ;;
      *)
          color="\033[36m"
          ;;
  esac

  printf "%b%s%b" "$color" "$name" "$color_reset"
}

kcluster() {
  local kube_dir="$HOME/.kube"
  local selected

  selected=$(
    find "$kube_dir" -maxdepth 1 -type f -name '*.yaml' \
      | while read -r f; do
          KUBECONFIG="$f"
          # Print the color coded filename segment tab separated from the full filename
          printf "%s\t%s\n" "$(kubefile_cc_segment)" "$f"
	  # Right pad doesn't make fzf market bigger, since it strips
	  # printf "%-40s\t%s\n" "$(kubefile_segment)" "$f"
    done \
      | fzf --ansi \
            --with-nth=1 \
            --delimiter='\t' \
            --prompt="Select KUBECONFIG: " \
            --height=40% \
            --reverse \
            --color='pointer:161,marker:168' \
      | cut -f2
  )

  if [[ -z "$selected" ]]; then
    echo "No file selected."
    return 1
  fi

  export KUBECONFIG="$selected"
  echo "KUBECONFIG set to: $KUBECONFIG"

  # Set iTerm2 badge + tab title
  set_badge "${KUBECONFIG:t:r}"
  set_tab "${KUBECONFIG:t:r}"
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
