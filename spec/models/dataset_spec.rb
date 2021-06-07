# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Dataset do
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:creator) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:alternate_identifier) }
  it { is_expected.to respond_to(:contact_information) }
  it { is_expected.to respond_to(:doi) }
  it { is_expected.to respond_to(:related_citation) }

  it_behaves_like 'doi mintable'
end
