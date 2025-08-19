getpod() {
  local namespace=$1
  local name=$2

  if [[ -z "$namespace" || -z "$name" ]]; then
    echo "Usage: getpod <namespace> <name-fragment>"
    return 1
  fi

  kubectl get pods -n "$namespace" --no-headers -o name \
    | grep "$name" \
    | head -n 1 \
    | cut -d/ -f2
}

tailpod() {
  local namespace=$1
  local name=$2
  local pod=`getpod $namespace $name`
  kubectl logs --follow $pod -n $namespace | jq --raw-input 'fromjson? | .time |= strftime("%Y-%m-%d %H:%M:%S")'
}
