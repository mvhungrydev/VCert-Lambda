import subprocess
import requests

def lambda_handler(event, context):
    # TOdos: fetch secretfrom AWS Secrets Manager
    # call venafi api to get all certs
    # loop each cert and call vcert to download each key
    # there should be some logic to determine where the certs will go
    # consider checking application name or tag 
    # store certs in 
    try:
        # Run the vcert binary with --version
        result = subprocess.run(
            ["./vcert", "--version"],
            capture_output=True,
            text=True,
            check=True
        )

        # Sample GET request to a public API
        api_response = requests.get("https://api.github.com/")
        api_body = api_response.text

        return {
            "statusCode": 200,
            "body": {
                "vcert_output": result.stdout.strip(),
                "api_response": api_body
            }
        }
    except subprocess.CalledProcessError as e:
        return {
            "statusCode": 500,
            "error": e.stderr.strip()
        }
