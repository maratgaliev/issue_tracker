describe Issues::UpdateCommand do
  let(:issue) { FactoryBot.create(:issue) }
  let(:author) { issue.author }
  let(:command) { described_class.new }
  let(:valid_params) { {name: 'new name', description: 'new description'} }

  context 'with another user' do
    let(:user) { FactoryBot.create(:user) }

    it 'should fail' do
      result = command.call(id: issue.id, user: user, params: valid_params)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you are not an author'])
      expect(issue.reload.name).to eq 'name'
      expect(issue.reload.description).to eq 'description'
    end
  end

  context 'with invalid name' do
    it 'should fail' do
      result = command.call(id: issue.id, user: author, params: {name: ''})

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(name: ['must be filled'])
      expect(issue.reload.name).to eq 'name'
      expect(issue.reload.description).to eq 'description'
    end
  end

  context 'with invalid description' do
    it 'should fail' do
      result = command.call(id: issue.id, user: author, params: {name: 'name', description: 1})

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(description: ['must be a string'])
      expect(issue.reload.name).to eq 'name'
      expect(issue.reload.description).to eq 'description'
    end
  end

  context 'with valid parameters' do
    let(:result) { command.call(id: issue.id, user: author, params: valid_params) }

    subject { result }

    its(:success?) { is_expected.to be_truthy }

    describe 'issue' do
      subject { result.value }

      its(:persisted?) { is_expected.to be_truthy }
      its(:name) { is_expected.to eq 'new name' }
      its(:description) { is_expected.to eq 'new description' }
      its(:author_id) { is_expected.to eq author.id }
      its(:assignee_id) { is_expected.to be_nil }
      its(:status) { is_expected.to eq 'pending' }
    end
  end
end
