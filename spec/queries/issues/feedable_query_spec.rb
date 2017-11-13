describe Issues::FeedableQuery do
  let!(:user) { FactoryBot.create(:user) }
  let!(:moderator) { FactoryBot.create(:user, :moderator) }
  let!(:user_issue) { FactoryBot.create(:issue, author: user) }
  let!(:other_issue) { FactoryBot.create(:issue) }
  let!(:in_progress_issue) { FactoryBot.create(:issue, :in_progress, author: user, updated_at: 2.days.ago) }

  context 'with user' do
    it 'should see only his issues' do
      expect(described_class.for_user(user).value).to eq [user_issue, in_progress_issue]
    end

    it 'should be able to filter by status' do
      expect(described_class.for_user(user, status: 'in_progress').value).to eq [in_progress_issue]
    end

    it 'should be able to paginate' do
      stub_const('Issues::FeedableQuery::PER_PAGE', 1)

      expect(described_class.for_user(user).value).to eq [user_issue]
      expect(described_class.for_user(user, page: 2).value).to eq [in_progress_issue]
    end

    it 'should be able to paginate and filter by status' do
      stub_const('Issues::FeedableQuery::PER_PAGE', 1)
      other_in_progress_issue = FactoryBot.create(:issue, :in_progress, author: user)

      expect(described_class.for_user(user, page: 1, status: 'in_progress').value).to eq [other_in_progress_issue]
      expect(described_class.for_user(user, page: 2, status: 'in_progress').value).to eq [in_progress_issue]
    end
  end

  context 'with moderator' do
    it 'should see all issues' do
      expect(described_class.for_user(moderator).value).to match_array [other_issue, user_issue, in_progress_issue]
    end

    it 'should be able to filter by status' do
      expect(described_class.for_user(moderator, status: 'in_progress').value).to eq [in_progress_issue]
    end

    it 'should be able to paginate and filter by status' do
      stub_const('Issues::FeedableQuery::PER_PAGE', 1)
      other_in_progress_issue = FactoryBot.create(:issue, :in_progress)

      expect(described_class.for_user(moderator, page: 1, status: 'in_progress').value).to eq [other_in_progress_issue]
      expect(described_class.for_user(moderator, page: 2, status: 'in_progress').value).to eq [in_progress_issue]
    end
  end
end
