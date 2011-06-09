require 'thor'
require 's3_bucket_sync'

module S3BucketSync
  class CLI < Thor
    desc "sync", "Syncs two S3 buckets"
    method_option :access_key_id, :aliases => "-aki"
    method_option :secret_access_key, :aliases => "-sak"
    method_option :source, :aliases => "-s"
    method_option :destination, :aliases => "-d"

    def sync
      puts S3BucketSync::Base.sync_buckets(options)
    end

  end
end