# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe Hyrax::GenericWorkForm do
  let(:work) { GenericWork.new }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(work, ability, request) }

  describe '::terms' do
    subject { form.terms }
    it do
      is_expected.to include(:title, :creator, :keyword, :rights)
    end
  end
end
