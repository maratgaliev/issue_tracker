class Issue < ApplicationRecord
  PENDING = 'pending'.freeze
  IN_PROGRESS = 'in_progress'.freeze
  RESOLVED = 'resolved'.freeze
  DEFAULT_STATUS = PENDING
  STATUSES = [PENDING, IN_PROGRESS, RESOLVED]

  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  scope :of_author, -> (author_id) { where(author_id: author_id) }
  scope :with_status, -> (status) { where(status: status) }
  scope :ordered, -> { order(updated_at: :desc) }

  def of_user?(user_id)
    user_id && self.author_id == user_id
  end

  def pending?
    status == PENDING
  end

  def in_progress?
    status == IN_PROGRESS
  end

  def unassigned?
    self.assignee_id.nil?
  end

  def assigned_by?(assignee_id)
    assignee_id && self.assignee_id == assignee_id
  end
end
