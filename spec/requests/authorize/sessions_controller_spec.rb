describe Authorize::SessionsController, type: :request do
  describe 'POST /users/sign_in' do
    let(:email) { 'user@example.com' }
    let(:request_password) { 'password' }
    let!(:user) { FactoryBot.create(:user, email: email, password: 'password') }

    before do
      headers = {'Content-Type' => 'application/json'}
      params = {user: {email: email, password: request_password}}

      post '/users/sign_in', headers: headers, params: params.to_json
    end

    subject { response }

    context 'with invalid credentials' do
      let(:request_password) { 'wrongpassword'}

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"error":{"base":["invalid email or password"]}}' }
    end

    context 'with valid credentials' do
      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /user/ }

      it 'should contain authorization header' do
        expect(response.headers['Authorization']).to match /^Bearer/
      end
    end
  end
end
