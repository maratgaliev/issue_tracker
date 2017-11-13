describe Issues::DestroyCommand do
  let(:issue) { FactoryBot.create(:issue) }
  let(:author) { issue.author }
  let(:command) { described_class.new }

  context 'with another user' do
    let(:user) { FactoryBot.create(:user) }

    it 'should not delete issue' do
      result = command.call(id: issue.id, user: user)

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(base: ['you are not an author'])
      expect(Issue.exists?(issue.id)).to be_truthy
    end
  end

  context 'with author' do
    it 'should delete issue' do
      result = command.call(id: issue.id, user: author)

      expect(result.success?).to be_truthy
      expect(result.value).to eq(:deleted)
      expect(Issue.count).to eq 0
    end
  end
end
