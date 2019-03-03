# Make Directory Sagemaker
mkdir -p /home/ec2-user/SageMaker/sagemaker-code/

# Copy data from S3.
aws s3 cp s3://dev-sagemaker-bucket/notebook/notebook.zip /home/ec2-user/SageMaker/notebook.zip
unzip /home/ec2-user/SageMaker/notebook.zip -d /home/ec2-user/SageMaker/sagemaker-code
sudo chown -R ec2-user:ec2-user /home/ec2-user/SageMaker/sagemaker-code

# Install runipy
pip3 install runipy

# Lifecycle configuration
tmux new -d -s tmuxbg
tmux send-keys -t tmuxbg.0 "jupyter notebook nbconvert --execute /home/ec2-user/SageMaker/sagemaker-code/notebook.ipynb"
tmux a -t tmuxbg