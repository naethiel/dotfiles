abbr -a "kdiff" "kustomize build k8s/staging/services | kubectl diff -f -"
abbr -a "kapply" "kustomize build k8s/(kubectl config current-context)/services | kubectl apply -f -"
