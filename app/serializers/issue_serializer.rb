class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status,
             :created_at, :updated_at

  has_one :author
  has_one :assignee
end
