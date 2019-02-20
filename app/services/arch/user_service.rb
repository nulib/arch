module Arch
  class UserService
    class << self
      def rekey_users
        ActiveFedora::Base.find_each do |obj|
          begin
            Rails.logger.info("Updating #{obj.id}")
            obj.depositor = User.whois(obj.depositor) if obj.respond_to?(:depositor)
            [:read_users, :edit_users, :discover_users].each do |access_method|
              next unless obj.respond_to?(access_method)
              old_value = obj.send(access_method)
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
  end
end
