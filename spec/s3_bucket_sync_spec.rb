require 's3'
require 's3_bucket_sync'

describe S3BucketSync do

  before(:each) do
    @test_source_name = "test-source-bucket"
    @test_destination_name = "test-destination-bucket"
    @test_file_name = File.join(File.dirname(__FILE__), 'fixtures', 'images', 'dog-fanny-pack.jpg')

    @service = S3::Service.new(:access_key_id => "<redacted>",
                               :secret_access_key => "<redacted>")

    @test_destination = @service.buckets.build(@test_destination_name)
    @test_destination.save
    @test_source = @service.buckets.build(@test_source_name)
    @test_source.save
  end

  after(:each) do
    @service = S3::Service.new(:access_key_id => "<redacted>",
                               :secret_access_key => "<redacted>")
    @test_source.destroy(true)
    @test_destination.destroy(true)
  end
  describe ".synch_buckets" do
    describe "options" do
      it "should raise an error if you don't provide full s3 credentials" do
        options = {:source => 'test_source',
                   :destination => "test_destination",
                   :secret_access_key => '<redacted>'}
        lambda {
          S3BucketSync::Base.sync_buckets(options)
        }.should raise_error("Incomplete S3 credentials supplied")
      end


      it "should raise an error if you can't connect to S3" do
        options = {:source => 'test_source',
                   :destination => "test_destination",
                   :access_key_id => 'hello',
                   :secret_access_key => 'world'}
        lambda {
          S3BucketSync::Base.sync_buckets(options)
        }.should raise_error
      end

      it "should raise an error if the source bucket doesn't exist" do
        options = {:source => 'not_here_source',
                   :destination => "test_destination",
                   :access_key_id => '<redacted>',
                   :secret_access_key => '<redacted>'}
        lambda {
          S3BucketSync::Base.sync_buckets(options)
        }.should raise_error
      end

      it "should raise an error if the destination bucket doesn't exist" do
        options = {:source => 'test_source',
                   :destination => "not_here_destination",
                   :access_key_id => '<redacted>',
                   :secret_access_key => '<redacted>'}
        lambda {
          S3BucketSync::Base.sync_buckets(options)
        }.should raise_error
      end
    end
    describe "with a source bucket that has objects in it but an empty destination bucket" do
      it "should should copy all objects from the source bucket to the destination bucket with the proper structure" do

        @object_1 = @test_source.objects.build('me.jpg')
        @object_1.content = open(@test_file_name)
        @object_1.save
        @object_2 =  @test_source.objects.build('further_down/me.jpg')
        @object_2.content = open(@test_file_name)
        @object_2.save

        options = {:source => @test_source_name,
                   :destination => @test_destination_name,
                   :access_key_id => '<redacted>',
                   :secret_access_key => '<redacted>'}
        S3BucketSync::Base.sync_buckets(options)

        @test_destination.objects.size.should == 2
        @test_destination.objects.map(&:key).should include(@object_1.key)
        @test_destination.objects.map(&:key).should include(@object_2.key)
      end
    end

    describe "with a source bucket that has objects in it and destination bucket that contains a duplicate key" do
      it "should overwrite the existing duplicate key" do
        @object_1 = @test_source.objects.build('me.jpg')
        @object_1.content = open(@test_file_name)
        @object_1.save
        @object_2 =  @test_source.objects.build('further_down/me.jpg')
        @object_2.content = open(@test_file_name)
        @object_2.save

        @existing_object = @test_destination.objects.build('me.jpg')
        @existing_object.content = open(@test_file_name)
        @existing_object.save

        options = {:source => @test_source_name,
                   :destination => @test_destination_name,
                   :access_key_id => '<redacted>',
                   :secret_access_key => '<redacted>'}
        S3BucketSync::Base.sync_buckets(options)

        @test_destination.objects.size.should == 2
        @test_destination.objects.map(&:key).should include(@object_1.key)
        @test_destination.objects.map(&:key).should include(@object_2.key)
      end
    end

  end

end