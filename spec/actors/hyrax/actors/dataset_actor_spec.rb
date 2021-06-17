# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Hyrax::Actors::DatasetActor do
  it 'is a BaseActor' do
    expect(described_class < ::Hyrax::Actors::BaseActor).to be true
  end
end
