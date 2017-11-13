describe Issues::InProgressCommand do
  let(:assignee) { FactoryBot.create(:user, :moderator) }
  let(:issue) { FactoryBot.create(:issue, assignee: assignee) }
  let(:command) { described_class.new }

  context 'with another user' do
    let(:user) { FactoryBot.create(:user, :moderator) }

    it 'should fail' do
      result = command.call(id: issue.id, assignee: user)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you cannot change this issue'])
      expect(issue.reload.status).to eq 'pending'
    end
  end

  context 'with assignee' do
    it 'should change status' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.success?).to be_truthy
      expect(result.value).to be_a Issue
      expect(issue.reload.status).to eq 'in_progress'
    end
  end
end
