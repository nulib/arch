module Arch
  class LicenseService < Hyrax::QaSelectService
    def initialize(authority_name = 'licenses')
      super(authority_name)
    end
  end
end
