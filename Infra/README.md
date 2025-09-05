Create a bucket first to host my Terraform state

## Terraform S3 bucket creation

AWS_REGION=us-east-1
BUCKET=terraform-state-mv

# create bucket (for us-east-1 the CLI syntax differs; update region accordingly)

aws s3api create-bucket \
 --bucket $BUCKET \
 --region $AWS_REGION

# enable versioning (recommended)

aws s3api put-bucket-versioning --bucket $BUCKET \
 --versioning-configuration Status=Enabled

# enable server-side encryption by default

aws s3api put-bucket-encryption --bucket $BUCKET --server-side-encryption-configuration '{
"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]
}'

# block public access

aws s3api put-public-access-block --bucket $BUCKET --public-access-block-configuration '{
"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":true,"RestrictPublicBuckets":true
}'

##
