class Issues::ResolvedCommand < BaseCommand
  step :authorize
  step :resolved

  def authorize(id:, assignee:)
    issue = Issue.find(id)

    if assignee.moderator? && issue.assigned_by?(assignee.id) && issue.in_progress?
      Right(issue)
    else
      Left(error(I18n.t('errors.issues.not_changeable')))
    end
  end

  def resolved(issue)
    issue.status = Issue::RESOLVED

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
