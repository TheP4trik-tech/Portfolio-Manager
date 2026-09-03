require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:own_credential) { create(:api_credential, user: user) }
  let(:foreign_credential) { create(:api_credential, user: other_user) }

  let(:own_snapshot) { create(:cash_snapshot, user: user) }
  let(:foreign_snapshot) { create(:cash_snapshot, user: other_user) }

  describe "Api credential permision" do
    it "allows to manage own api credentials" do
      expect(ability).to be_able_to(:destroy, own_credential)
      expect(ability).to be_able_to(:read, own_credential)
    end

    it "forbids to manage foreign api_credentials" do
      expect(ability).not_to be_able_to(:destroy, foreign_credential)
      expect(ability).not_to be_able_to(:read, foreign_credential)
    end
  end
  describe "Cash snapshot permission" do
    it 'can read own snapshot' do
      expect(ability).to be_able_to(:read, own_snapshot)
    end
    it 'cannot manage foreign snapshots' do
      expect(ability).not_to be_able_to(:read, foreign_snapshot)
      expect(ability).not_to be_able_to(:manage, foreign_snapshot)
    end

    it "cannot delete own snapshot" do
      expect(ability).not_to be_able_to(:destroy, own_snapshot)
    end
    end
    describe "User to user permision" do
      it "can manage itself" do
      expect(ability).to be_able_to(:manage, user)
      end
      it "cannot manage others users" do
        expect(ability).not_to be_able_to(:manage, other_user)
      end
    end
  end
