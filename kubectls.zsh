getpod() {
  local name=$1
  local namespace=$2

  if [[ -z "$namespace" || -z "$name" ]]; then
    echo "Usage: getpod <name-match> <namespace>"
    return 1
  fi

  kubectl get pods -n "$namespace" --no-headers -o name \
    | grep "$name" \
    | head -n 1 \
    | cut -d/ -f2
}

tailpod() {
  local name=$1
  local namespace=$2
  local pod=`getpod $name $namespace`
  kubectl logs --follow $pod -n $namespace | jq --raw-input 'fromjson? | .time |= strftime("%Y-%m-%d %H:%M:%S")'
}
