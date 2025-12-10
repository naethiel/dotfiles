abbr -a kdiff "kubectl diff -k k8s/(kubectl config current-context)"
abbr -a kapply "kubectl apply -k k8s/(kubectl config current-context)"

function kconfig -d "fetch configMap for a given service in current context via kubectl"
    kubectl get configMap/$argv -o json | jq '.data | to_entries[] | "export "+.key+"=\""+.value+"\""' -r
end

function kbastion -d "login to bastion or print it's exact hash for use in subcommand composition"
    set -l pod_name (kubectl get pod -o name | grep bastion | sed 's/^pod\///')

    if test "$argv[1]" = -c
        echo $pod_name
        return
    end

    kubectl exec -it $pod_name -- bash
end

function autotag -d "applies an autotag on platform-app, either major, minor or patch"
    if test -z "$argv[2]"
        set argv[2] platform-app
    end

    tools/auto-tag $argv | xargs git push origin
end
