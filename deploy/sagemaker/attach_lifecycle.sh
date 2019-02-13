function get_notebook_instance_status() {
    eval status=$(aws sagemaker describe-notebook-instance --notebook-instance-name ${notebook_name} --query NotebookInstanceStatus)
    echo $status
}

function poll_sagemaker() {
    time=0
    action=$1
    expected_status=$2
    while [ $expected_status != $(get_notebook_instance_status) ]
    do
        time=$(( $time + 20 ))
        sleep 10
        echo "For notebook-instance-name: ${notebook_name} - Expecting: ${expected_status}: Still $(get_notebook_instance_status)... ${time}s elapsed"
    done 
}

function action_notebook() {
    action=$1
    expected_status=$2
    aws sagemaker $action-notebook-instance \
        --notebook-instance-name $notebook_name
    poll_sagemaker $action $expected_status
}

function attach_lifecycle_config() {
    aws sagemaker update-notebook-instance \
       --notebook-instance-name $notebook_name \
       --lifecycle-config-name cf-cicd-dev-sagemaker-lifecycle
    poll_sagemaker "stop" "Stopped"
}

function main() {
    action_notebook "stop" "Stopped" 
    attach_lifecycle_config
    action_notebook "start" "InService" 
}

# # Execute Script.
notebook_name=$1
main
