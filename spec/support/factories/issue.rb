FactoryBot.define do
  factory :issue do
    name 'name'
    description 'description'
    status 'pending'
    author { create(:user) }

    trait :in_progress do
      status 'in_progress'
      assignee { create(:user, :moderator) }
    end

    trait :resolved do
      status 'resolved'
      assignee { create(:user, :moderator) }
    end
  end
end
