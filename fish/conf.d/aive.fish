abbr -a "kdiff" "kubectl diff -k k8s/(kubectl config current-context)/services"
abbr -a "kapply" "kubectl apply -k k8s/(kubectl config current-context)/services"

function kconfig -d "fetch configMap for a given service in current context via kubectl"
    kubectl get configMap/$argv -o json | jq '.data | to_entries[] | "export "+.key+"=\""+.value+"\""' -r
end
