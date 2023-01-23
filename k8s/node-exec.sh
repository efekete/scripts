k8s_exec_node(){
  wget https://raw.githubusercontent.com/efekete/scripts/master/k8s-yamls/exec-pod.yaml -q -O /tmp/exec-pod.yaml
  NODE_EXEC=$1
  yq e -i '.spec.nodeName= env(NODE_EXEC)' /tmp/exec-pod.yaml
  POD_NAME=$(kubectl create -f /tmp/exec-pod.yaml | awk '{print $1}')
  echo "Waiting for pod to be ready"
  kubectl wait --for=condition=Ready -n kube-system $POD_NAME
  echo "Pod ready, executing"
  kubectl exec -n kube-system -it $POD_NAME -- bash
}
