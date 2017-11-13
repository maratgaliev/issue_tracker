describe Issues::AssignCommand do
  let(:command) { described_class.new }

  context 'when user is not moderator' do
    let(:issue) { FactoryBot.create(:issue) }
    let(:assignee) { FactoryBot.create(:user) }

    it 'should fail' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you cannot assign this issue'])
      expect(issue.reload.assignee).not_to eq assignee
    end
  end

  context 'when has assignee' do
    let(:issue) { FactoryBot.create(:issue, :in_progress) }
    let(:assignee) { FactoryBot.create(:user, :moderator) }

    it 'should fail' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you cannot assign this issue'])
      expect(issue.reload.assignee).not_to eq assignee
    end
  end

  context 'when has not assignee and user is moderator' do
    let(:issue) { FactoryBot.create(:issue) }
    let(:assignee) { FactoryBot.create(:user, :moderator) }

    it 'should add assignee' do
      result = command.call(id: issue.id, assignee: assignee)

      expect(result.success?).to be_truthy
      expect(result.value).to be_a Issue
      expect(issue.reload.assignee).to eq assignee
    end
  end
end
