
# Lambda Execution Role
resource "aws_iam_role" "lambda_exec" {
  name = "vcert-lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Basic logging permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# lambda function
resource "aws_lambda_function" "vcert-lambda" {
  function_name = "vcert-lambda"
  package_type  = "Image"
  image_uri     = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/vcert-lambda:${var.image_tag}"  # Replace with your ECR image
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 30
}


# EventBridge Rule (every hour)
resource "aws_cloudwatch_event_rule" "hourly" {
  name                = "vcert-hourly-rule"
  description         = "Run vcert lambda every hour"
  schedule_expression = "rate(1 hour)"
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.vcert.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.hourly.arn
}

# Attach Lambda to the EventBridge rule
resource "aws_cloudwatch_event_target" "vcert_lambda_target" {
  rule      = aws_cloudwatch_event_rule.hourly.name
  target_id = "vcert-lambda"
  arn       = aws_lambda_function.vcert.arn
}
