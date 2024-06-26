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
  task fix_user_fields: :environment do
    Arch::UserService.rekey_users
  end
end
