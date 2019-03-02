#!/bin/sh

image=$1

mkdir -p test_dir/model
mkdir -p test_dir/output

rm test_dir/model/*
rm test_dir/output/*

AWS_ACCESS_KEY_ID=$(aws --profile personal_account configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws --profile personal_account configure get aws_secret_access_key)

docker run -v $(pwd)/test_dir:/opt/ml \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    ${image} train