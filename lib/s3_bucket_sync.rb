require 's3'
require 's3_bucket_sync/version'

module S3BucketSync
  class Base
    def self.sync_buckets(options)
      raise "Incomplete S3 credentials supplied" unless options[:access_key_id] && options[:secret_access_key]
      @the_service = S3::Service.new(:access_key_id => options[:access_key_id],
                               :secret_access_key => options[:secret_access_key])

      source_bucket = @the_service.buckets.find_first(options[:source])
      destination_bucket = @the_service.buckets.find_first(options[:destination])

      puts "Copying from source bucket 'e[32m#{source_bucket.name}e[0m' to destination bucket 'e[32m#{destination_bucket.name}e[0m'"

      source_bucket.objects.each do |object|
        puts "Copying e[32m#{object.key}e[0m ..."
        object.copy({:key => object.key, :bucket => destination_bucket})
      end
      return "e[32mS3 Buckets Successfully Sync'd.e[0m"
    end
  end
end
