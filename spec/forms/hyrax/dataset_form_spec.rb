# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Hyrax::DatasetForm do
  let(:dataset) { Dataset.new }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(dataset, ability, request) }

  describe '::terms' do
    subject(:terms) { form.terms }

    it 'contains fields that users should are allowed to edit' do
      expect(terms).to include(:title, :creator, :keyword, :rights_statement)
    end

    it 'does not contain fields that users should not be allowed to edit' do
      # doi is created automatically after save.
      expect(terms).not_to include(:doi)
    end
  end
end
