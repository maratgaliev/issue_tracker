describe Users::SignUpCommand do
  let(:command) { described_class.new }

  context 'wrong email' do
    it 'should fail if has invalid format' do
      result = command.call(email: 'email', login: 'login', password: 'password')

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(email: ['is not email'])
    end

    it 'should fail if such email already exists' do
      user = FactoryBot.create(:user)

      result = command.call(email: user.email, login: 'login', password: 'password')

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(email: ['has already been taken'])
    end
  end

  context 'wrong login' do
    it 'should fail if has invalid format' do
      result = command.call(email: 'email@example.com', login: 'lo', password: 'password')

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(login: ['size cannot be less than 3'])
    end

    it 'should fail if such login already exists' do
      user = FactoryBot.create(:user)

      result = command.call(email: 'email@example.com', login: user.login, password: 'password')

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(login: ['has already been taken'])
    end
  end

  context 'wrong password' do
    it 'should fail if has invalid format' do
      result = command.call(email: 'email@example.com', login: 'login', password: 'pass')

      expect(result.failure?).to be_truthy
      expect(result.value).to eq(password: ['must be at least 6 characters'])
    end
  end

  context 'valid params' do
    let(:result) { command.call(email: 'email@example.com', login: 'login', password: 'password') }

    subject { result }

    its(:success?) { is_expected.to be_truthy }

    describe 'user' do
      subject { result.value }

      its(:persisted?) { is_expected.to be_truthy }
      its(:email) { is_expected.to eq 'email@example.com' }
      its(:login) { is_expected.to eq 'login' }
      its(:role) { is_expected.to eq 'user' }
    end
  end
end
