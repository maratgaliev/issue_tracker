class Issues::FeedableQuery
  include Dry::Transaction
  PER_PAGE = 25

  step :issues_scope
  step :status_scope
  step :paginate

  def self.for_user(user, filter = {}, &block)
    new.call(user: user, filter: filter, &block)
  end

  def issues_scope(user:, filter:)
    if user.moderator?
      Right(issues: Issue, filter: filter)
    else
      Right(issues: Issue.of_author(user.id), filter: filter)
    end
  end

  def status_scope(issues:, filter:)
    if filter[:status].blank?
      Right(issues: issues, filter: filter)
    elsif filter[:status].in?(Issue::STATUSES)
      issues = issues.with_status(filter[:status])
      Right(issues: issues, filter: filter)
    else
      Left(:invalid_status)
    end
  end

  def paginate(issues:, filter:)
    issues = issues.ordered.paginate(page: filter[:page], per_page: PER_PAGE)
    Right(issues)
  end
end
