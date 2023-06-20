# !/bin/bash
PROFILE_NAME=lmfunc
REGION=ap-northeast-1
ACCOUNT_ID=`aws sts get-caller-identity --profile $PROFILE_NAME --query 'Account' --output text`;

FUNCTION_NAME=lmfunc
ALIAS_NAME=sample
ECR_IMAGE_NAME=cicdhandson

aws lambda invoke --profile $PROFILE_NAME --function-name $FUNCTION_NAME --invocation-type RequestResponse --region $REGION response.json && cat response.json
aws lambda create-alias --profile $PROFILE_NAME --function-name $FUNCTION_NAME --function-version "1" --name $ALIAS_NAME
aws lambda update-function-code --profile $PROFILE_NAME --function-name $FUNCTION_NAME --image-uri "$ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com/$ECR_IMAGE_NAME:latest" --publish
aws lambda update-alias --profile $PROFILE_NAME --function-name $FUNCTION_NAME --function-version "2" --name $ALIAS_NAME
aws lambda invoke --profile $PROFILE_NAME --function-name "$FUNCTION_NAME:$ALIAS_NAME" --invocation-type RequestResponse --region $REGION response.json && cat response.json
