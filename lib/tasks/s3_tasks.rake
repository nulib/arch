
namespace :s3 do
  desc 'Create all configured S3 buckets'
  task create_buckets: :environment do
    Settings.aws.buckets.to_h.values.each do |bucket|
      bucket = Aws::S3::Bucket.new(bucket)
      bucket.create unless bucket.exists?
    end
  end

  desc 'Populate S3 batch bucket with fixture data'
  task populate_batch_buckets: :environment do
    s3 = Aws::S3::Resource.new
    Settings.aws.buckets.to_h.each_pair do |key, bucket|
      fixture_dir = Rails.root.join('spec', 'fixtures', 's3', key)
      next unless File.directory?(fixture_dir)
      Dir.chdir(fixture_dir) do
        Dir.glob('**/*').each do |file|
          next if File.directory?(file)
          obj = s3.bucket(bucket).object(file)
          obj.upload_file(file)
        end
      end
    end
  end

  desc 'Create buckets and populate with test data'
  task :setup do
    Rake::Task['s3:create_buckets'].invoke
    Rake::Task['s3:populate_batch_buckets'].invoke
  end

  desc 'Empty S3 buckets'
  task empty_buckets: :environment do
    client = Aws::S3::Client.new
    Settings.aws.buckets.to_h.values.each do |bucket|
      objs = client.list_objects_v2(bucket: bucket)
      objs.contents.each do |obj|
        client.delete_object(bucket: bucket, key: obj.key)
      end
    end
  end

  desc 'Delete S3 buckets'
  task delete_buckets: :environment do
    Settings.aws.buckets.to_h.values.each do |bucket|
      Aws::S3::Client.new.delete_bucket(bucket: bucket)
    end
  end

  desc 'Empty and delete S3 buckets'
  task :teardown do
    Rake::Task['s3:empty_buckets'].invoke
    Rake::Task['s3:delete_buckets'].invoke
  end
end
