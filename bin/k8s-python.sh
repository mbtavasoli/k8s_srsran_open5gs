#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: k8s-logs <keyword> [namespace]"
  exit 1
fi

keyword=$1
namespace=$2
SCRIPT_FILE=$3

if [[ -z $namespace ]]; then
  echo "Select namespace:"
  namespaces=($(kubectl get namespaces -o name | cut -d/ -f2))
  PS3="Namespace: "
  select namespace in "${namespaces[@]}"; do
    if [[ -n $namespace ]]; then
      break
    fi
  done
fi

pod=$(kubectl get pods -n "$namespace" | grep "$keyword" | head -1 | awk '{print $1}')
if [[ -z $pod ]]; then
  echo "No pods found for keyword: $keyword"
  exit 1
fi

containers=($(kubectl get pods "$pod" -n "$namespace" -o jsonpath='{.spec.containers[*].name}'))
if [[ ${#containers[@]} -eq 1 ]]; then
  container=${containers[0]}
else
  echo "Select container:"
  PS3="Container: "
  select container in "${containers[@]}"; do
    if [[ -n $container ]]; then
      break
    fi
  done
fi

# Copy SCRIPT_FILE to /tmp/SCRIPT_FILE and execute it
kubectl cp $SCRIPT_FILE $pod:/tmp/$SCRIPT_FILE -n $namespace

# if $4 is not set then execute the script else use $4 as namespace
if [[ -z $4 ]]; then
  kubectl exec -it $pod -n $namespace -- bash -c "python3 /tmp/$SCRIPT_FILE"
else
  # kubectl exec -it $pod -n $namespace -- bash -c "ip netns exec $4 python3 /tmp/$SCRIPT_FILE"
  kubectl exec -it $pod -n $namespace -- bash -c "python3 /tmp/$SCRIPT_FILE"
fi



