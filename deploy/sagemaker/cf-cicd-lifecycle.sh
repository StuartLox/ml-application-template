# Make Directory Sagemaker
mkdir -p /home/ec2-user/SageMaker/sagemaker-code/

# Copy data from 
aws s3 cp s3://dev-sagemaker-bucket/notebook/notebook.zip /home/ec2-user/SageMaker/notebook.zip
unzip /home/ec2-user/SageMaker/notebook.zip -d /home/ec2-user/SageMaker/sagemaker-code
sudo chown -R ec2-user:ec2-user /home/ec2-user/SageMaker/sagemaker-code

#
tmux new -d -s tmuxbg
tmux send-keys -t tumuxbg.0 "jupyter notebook nbconvert --execute /home/ec2-user/SageMaker/sagemaker-code/notebook.ipynb"