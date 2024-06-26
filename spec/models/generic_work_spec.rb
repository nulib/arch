# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe GenericWork do
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:depositor) }
  it { is_expected.to respond_to(:creator) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:doi) }

  it_behaves_like 'doi mintable'
end
