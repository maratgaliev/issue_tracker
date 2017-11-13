describe IssuesController, type: :request do
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user) }
  let(:auth_headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end

  subject { response }

  describe 'GET /issues' do
    context 'without JWT token' do
      before { get '/issues', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }
      let!(:user_issue) { FactoryBot.create(:issue, author: user) }
      let!(:other_issue) { FactoryBot.create(:issue) }

      before { get '/issues', headers: auth_headers }

      its(:status) { is_expected.to eq 200 }

      describe 'response JSON' do
        let(:json_response) { JSON.parse(response.body) }

        it 'should contain issue' do
          expect(json_response['issues'].count).to eq 1
          expect(json_response['issues'].first['id']).to eq user_issue.id
        end
      end
    end
  end

  describe 'POST /issues' do
    context 'without JWT token' do
      before { post '/issues', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }

      before { post '/issues', headers: auth_headers, params: params.to_json }

      context 'wrong params' do
        let(:params) { {name: ''} }

        its(:status) { is_expected.to eq 422 }
        its(:body) { is_expected.to eq '{"errors":{"name":["must be filled"]}}'}
      end

      context 'valid params' do
        let(:params) { {name: 'name'} }

        its(:status) { is_expected.to eq 200 }
        its(:body) { is_expected.to match /issue/ }
      end
    end
  end

  describe 'PATCH /issue/:id' do
    context 'without JWT token' do
      before { patch '/issues/1', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with author' do
      let(:user) { FactoryBot.create(:user) }
      let(:issue) { FactoryBot.create(:issue, author: user) }

      before { patch "/issues/#{issue.id}", headers: auth_headers, params: params.to_json }

      context 'wrong params' do
        let(:params) { {name: ''} }

        its(:status) { is_expected.to eq 422 }
        its(:body) { is_expected.to eq '{"errors":{"name":["must be filled"]}}'}
      end

      context 'valid params' do
        let(:params) { {name: 'newname'} }

        its(:status) { is_expected.to eq 200 }
        its(:body) { is_expected.to match /newname/ }
      end
    end

    context 'with other issue' do
      let(:user) { FactoryBot.create(:user) }
      let(:issue) { FactoryBot.create(:issue) }

      before { patch "/issues/#{issue.id}", headers: auth_headers, params: {name: 'name'}.to_json }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you are not an author"]}}' }
    end
  end

  describe 'DELETE /issue/:id' do
    context 'without JWT token' do
      before { delete '/issues/1', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with author' do
      let(:user) { FactoryBot.create(:user) }
      let(:issue) { FactoryBot.create(:issue, author: user) }

      before { delete "/issues/#{issue.id}", headers: auth_headers }

      its(:status) { is_expected.to eq 200 }

      it 'should delete issue' do
        expect(Issue.exists?(issue.id)).to be_falsey
      end
    end

    context 'with other issue' do
      let(:user) { FactoryBot.create(:user) }
      let(:issue) { FactoryBot.create(:issue) }

      before { delete "/issues/#{issue.id}", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you are not an author"]}}' }

      it 'should not delete issue' do
        expect(Issue.exists?(issue.id)).to be_truthy
      end
    end
  end

  describe 'PATCH /issue/:id/assign' do
    context 'without JWT token' do
      before { patch '/issues/1/assign', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }
      let(:issue) { FactoryBot.create(:issue, author: user) }

      before { patch "/issues/#{issue.id}/assign", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot assign this issue"]}}' }
    end

    context 'with moderator and assigned issue' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, assignee: user) }

      before { patch "/issues/#{issue.id}/assign", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot assign this issue"]}}' }
    end

    context 'with moderator and unassigned issue' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue) }

      before { patch "/issues/#{issue.id}/assign", headers: auth_headers }

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /issue/ }
    end
  end

  describe 'PATCH /issue/:id/unassign' do
    context 'without JWT token' do
      before { patch '/issues/1/unassign', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }
      let(:assignee) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, author: user, assignee: assignee) }

      before { patch "/issues/#{issue.id}/unassign", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot unassign this issue"]}}' }
    end

    context 'with not editable issue' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, :in_progress, assignee: user) }

      before { patch "/issues/#{issue.id}/unassign", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot unassign this issue"]}}' }
    end

    context 'with moderator and pending issue' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, assignee: user) }

      before { patch "/issues/#{issue.id}/unassign", headers: auth_headers }

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /issue/ }
    end
  end

  describe 'PATCH /issue/:id/in_progress' do
    context 'without JWT token' do
      before { patch '/issues/1/in_progress', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }
      let(:assignee) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, author: user, assignee: assignee) }

      before { patch "/issues/#{issue.id}/in_progress", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot change this issue"]}}' }
    end

    context 'with another moderator' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:assignee) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, assignee: assignee) }

      before { patch "/issues/#{issue.id}/in_progress", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot change this issue"]}}' }
    end

    context 'with assignee' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, assignee: user) }

      before { patch "/issues/#{issue.id}/in_progress", headers: auth_headers }

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /in_progress/ }
    end
  end

  describe 'PATCH /issue/:id/resolved' do
    context 'without JWT token' do
      before { patch '/issues/1/resolved', headers: {'Content-Type' => 'application/json'} }

      its(:status) { is_expected.to eq 401 }
    end

    context 'with user' do
      let(:user) { FactoryBot.create(:user) }
      let(:assignee) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, :in_progress, author: user, assignee: assignee) }

      before { patch "/issues/#{issue.id}/resolved", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot change this issue"]}}' }
    end

    context 'with another moderator' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:assignee) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, :in_progress, assignee: assignee) }

      before { patch "/issues/#{issue.id}/resolved", headers: auth_headers }

      its(:status) { is_expected.to eq 422 }
      its(:body) { is_expected.to eq '{"errors":{"base":["you cannot change this issue"]}}' }
    end

    context 'with assignee' do
      let(:user) { FactoryBot.create(:user, :moderator) }
      let(:issue) { FactoryBot.create(:issue, :in_progress, assignee: user) }

      before { patch "/issues/#{issue.id}/resolved", headers: auth_headers }

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to match /resolved/ }
    end
  end
end
