function get_notebook_instance_status() {
    eval status=$(aws sagemaker describe-notebook-instance --notebook-instance-name ${notebook_name} --query NotebookInstanceStatus)
    echo $status
}

function poll_sagemaker() {
    time=0
    expected_status=$1
    status=$($2)
    while [ $expected_status != $(get_notebook_instance_status) ]
    do
        time=$(( $time + 20 ))
        sleep 10
        echo "${expected_status} --notebook-instance-name ${notebook_name}: Still $(get_notebook_instance_status)... ${time}s elapsed)"
    done 
}

function action_notebook() {
    action=$1
    expected_status=$2
    aws sagemaker $action-notebook-instance \
        --notebook-instance-name $notebook_name
    poll_sagemaker $expected_status get_notebook_instance_status
}

function attach_lifecycle_config() {
    aws sagemaker update-notebook-instance \
       --notebook-instance-name $notebook_name 
       --lifecycle-config-name cf-cicd-dev-sagemaker-lifecycle
}

function main() {
    notebook_name=$1
    action_notebook "stop" "Stopped" 
    attach_lifecycle_config
    action_notebook "start" "InService" 
}

# # Execute Script.
notebook_name=$1
main $notebook_name