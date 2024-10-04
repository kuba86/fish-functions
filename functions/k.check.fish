function k.check

    function header -d "Create a header with name as only argument"
        set_color blue
        string repeat --count 20 --no-newline \# && \
        set_color red
        echo -n " $argv[1] " && \
        set_color blue
        string repeat --count 20 \#
        set_color normal
    end

    function switch_context -d "argument can be one of: 'dev' or 'stg' or 'prd'"
        switch $argv[1]
            case dev
                k config use-context AAA
            case stg
                k config use-context BBB
            case prd
                k config use-context CCC
            case '*'
                echo "argument can be one of: 'dev' or 'stg' or 'prd'"
        end
    end

    if [ $argv[1] ]
        set_color green
        switch_context $argv[1]
        set_color normal
    end

    header "Context"
    k config get-contexts

    function get -d "First argument is quoted name that should appear in header and the second argument is kubectl resource name"
        header $argv[1]
        k get $argv[2] 2> /dev/null
    end

    get "Config Maps" "configmaps"
    get "Secrets" "secrets"
    get "Pods" "pods"
    get "Jobs" "jobs"
    get "Cron Jobs" "cronjobs"
    get "Deployments" "deployments"
#     get "Events" "events"
#     get "Daemon Sets" "daemonsets"
#     get "Limit Ranges" "limitranges"
#     get "Resource Quotas" "resourcequotas"
#     get "Endpoints" "endpoints"
#     get "Namespaces" "namespaces"
    get "Nodes" "nodes"
#     get "Replica Sets" "replicasets"

end
