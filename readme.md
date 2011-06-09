# S3 Bucket Sync
Simple utility to copy the contents of *test-source-bucket* to *test-destination-bucket*

## Usage

    bundle exec ruby bin/s3_bucket_sync.rb sync --access_key_id <access key id> --secret_access_key <secret access key> --source test-source-bucket --destination test-destination-bucket