describe Issues::CreateCommand do
  let(:user) { FactoryBot.create(:user) }
  let(:command) { described_class.new }

  context 'with invalid name' do
    it 'should fail' do
      result = command.call(user: user, params: {name: ''})

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(name: ['must be filled'])
      expect(Issue.count).to eq 0
    end
  end

  context 'with invalid description' do
    it 'should fail' do
      result = command.call(user: user, params: {name: 'name', description: 1})

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(description: ['must be a string'])
      expect(Issue.count).to eq 0
    end
  end

  context 'with valid parameters' do
    let(:result) { command.call(user: user, params: {name: 'name', description: 'description'}) }

    subject { result }

    its(:success?) { is_expected.to be_truthy }

    describe 'issue' do
      subject { result.value }

      its(:persisted?) { is_expected.to be_truthy }
      its(:name) { is_expected.to eq 'name' }
      its(:description) { is_expected.to eq 'description' }
      its(:author_id) { is_expected.to eq user.id }
      its(:assignee_id) { is_expected.to be_nil }
      its(:status) { is_expected.to eq 'pending' }
    end
  end
end
