describe Authorize::RegistrationsController, type: :request do
  describe 'POST /users/sign_up' do
    before do
      headers = {'Content-Type' => 'application/json'}

      post '/users/sign_up', headers: headers, params: {user: params}.to_json
    end

    subject { response }

    context 'with invalid params' do
      let(:params) { {email: 'email', login: 'login', password: 'password'} }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"email":["is not email"]}}' }

      it 'should not create user' do
        expect(User.count).to eq 0
      end
    end

    context 'with valid params' do
      let(:params) { {email: 'email@example.com', login: 'login', password: 'password'} }

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /user/ }

      it 'should contain authorization header' do
        expect(response.headers['Authorization']).to match /^Bearer/
      end

      describe 'user' do
        subject { User.last }

        its(:email) { is_expected.to eq 'email@example.com' }
        its(:login) { is_expected.to eq 'login'}
      end
    end
  end
end
