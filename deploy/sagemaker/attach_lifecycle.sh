function get_notebook_instance_status() {
    eval status=$(aws sagemaker describe-notebook-instance --notebook-instance-name notebook-spike-instance --query NotebookInstanceStatus)
    echo $status
}

function poll_sagemaker() {
    time=0
    expected_status=$1
    status=$($2)
    while [ $expected_status != $status ]
    do
        time=$(( $time + 20 ))
        sleep 10
        eval status=get_notebook_instance_status
        echo "Start Notebook notebook-spike instance: Still ${status}... (${time}s elapsed)"
    done 
}

function action_notebook() {
    action=$1
    expected_status=$2
    aws sagemaker $action-notebook-instance --notebook-instance-name notebook-spike-instance
    poll_sagemaker $expected_status get_notebook_instance_status
}

function attach_lifecycle_config() {
    aws sagemaker update-notebook-instance --notebook-instance-name notebook-spike-instance --lifecycle-config-name cf-cicd-dev-sagemaker-lifecycle
}

function main() {
    action_notebook "stop" "Stopped"
    attach_lifecycle_config
    action_notebook "start" "InService"
}

main
