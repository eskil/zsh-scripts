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
