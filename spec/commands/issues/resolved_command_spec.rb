describe Issues::ResolvedCommand do
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

  context 'with pending issue' do
    it 'should change status' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you cannot change this issue'])
      expect(issue.reload.status).to eq 'pending'
    end
  end

  context 'with in_progress issue' do
    let(:issue) { FactoryBot.create(:issue, :in_progress, assignee: assignee) }

    it 'should change status' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.success?).to be_truthy
      expect(result.value).to be_a Issue
      expect(issue.reload.status).to eq 'resolved'
    end
  end
end
