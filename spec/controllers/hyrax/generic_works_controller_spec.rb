# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe Hyrax::GenericWorksController do
  it { is_expected.to be_kind_of(Hyrax::WorksControllerBehavior) }

  it 'includes DoiBehavior' do
    expect(described_class.ancestors.include?(DoiBehavior)).to be(true)
  end

  describe '#curation_concern_type' do
    subject { described_class.curation_concern_type }

    it { is_expected.to eq(::GenericWork) }
  end

  describe 'show presenter' do
    subject { described_class.show_presenter }

    it { is_expected.to eq(Hyrax::GenericWorkPresenter) }
  end
end
