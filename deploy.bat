JAR_NAME=awsLambda-1.0-SNAPSHOT.jar

mvn clean package

aws lambda create-function --function-name MyLambda --runtime java17 --handler lambda.MyLambda::handleRequest --role arn:aws:iam::904904702836:role/MyLambda --zip-file fileb://target/awsLambda-1.0-SNAPSHOT.jar


aws apigateway create-rest-api --name MyAPI API_ID=(aws apigateway get-rest-apis --query "items[?name=='MyAPI'].id" --output text)
aws apigateway create-resource --rest-api-id $API_ID --parent-id $API_ID --path-part myresource RESOURCE_ID=$(aws apigateway get-resources --rest-api-id $API_ID --query "items[?path=='/myresource'].id" --output text)


aws apigateway put-method --rest-api-id $API_ID --resource-id $RESOURCE_ID --http-method GET --authorization-type NONE
FUNCTION_NAME=$(aws lambda list-functions --query "Functions[?FunctionName=='MyLambda'].FunctionName" --output text)

aws apigateway put-integration --rest-api-id $API_ID --resource-id $RESOURCE_ID --http-method GET \
  --type AWS_PROXY --integration-http-method POST
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:<ACCOUNT_ID>:function:$FUNCTION_NAME/invocations

aws apigateway create-deployment --rest-api-id $API_ID --stage-name prod
API_URL=$(aws apigateway get-stage --rest-api-id $API_ID --stage-name prod --query "invokeUrl" --output text)

echo "API URL: $API_URL/myresource?input=10" #Substitua 10 pelo número que você deseja calcular o dobro