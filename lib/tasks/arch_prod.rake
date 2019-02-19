namespace :arch do
  desc 'Load a seed file'
  task load: :environment do
    yaml = YAML.safe_load(open(ENV['SEED_FILE']).read, [Symbol])
    Arch::SeedDataService.load(yaml) do |klass, status|
      puts "Loading #{klass} #{status}"
    end
  end

  desc 'Dump admin sets and users to a file'
  task dump: :environment do
    puts YAML.dump Arch::SeedDataService.dump
  end

  desc 'Rekey all user fields'
  task :fix_user_fields do
    ActiveFedora::Base.find_each do |obj|
      begin
        obj.depositor = User.whois(obj.depositor) if obj.respond_to?(:depositor)
        [:read_users, :edit_users, :discover_users].each do |access_method|
          next unless obj.respond_to?(access_method)
          old_value = obj.send(:access_method)
          new_value = old_value.map { |user| User.whois(user) }.compact
          obj.send(:"#{access_method}=", new_value) unless new_value == old_value
        end
        obj.save
      rescue StandardError => err
        Rails.logger.warn("Failed to update user keys for #{obj.id}: #{err.class}: `#{err.message}'")
      end
    end
  end
end
