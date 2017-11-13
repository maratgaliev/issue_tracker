describe User do
  describe '#moderator?' do
    context 'when has role user' do
      subject { FactoryBot.create(:user) }

      its(:moderator?) { is_expected.to be_falsey }
    end

    context 'when has role moderator' do
      subject { FactoryBot.create(:user, :moderator) }

      its(:moderator?) { is_expected.to be_truthy }
    end
  end
end
