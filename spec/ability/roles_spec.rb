require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  subject(:admin) { described_class.new(current_user) }

  describe 'as an admin' do
    let(:admin_user) { FactoryBot.create(:admin) }
    let(:current_user) { admin_user }
    let(:image) { FactoryBot.create(:work, user: current_user) }

    # rubocop:disable RSpec/ExampleLength
    it {
      is_expected.to be_able_to(:create, GenericWork.new)
      is_expected.to be_able_to(:create, FileSet.new)
      is_expected.to be_able_to(:read, image)
      is_expected.to be_able_to(:edit, image)
      is_expected.to be_able_to(:update, image)
      is_expected.to be_able_to(:destroy, image)
      is_expected.to be_able_to(:edit, String)
    }
    # rubocop:enable RSpec/ExampleLength

    it 'can create works' do
      expect(admin.can_create_any_work?).to be true
    end
  end
end
