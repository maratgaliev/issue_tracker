class Issues::InProgressCommand < BaseCommand
  step :authorize
  step :in_progress

  def authorize(id:, assignee:)
    issue = Issue.find(id)

    if assignee.moderator? && issue.assigned_by?(assignee.id)
      Right(issue)
    else
      Left(error(I18n.t('errors.issues.not_changeable')))
    end
  end

  def in_progress(issue)
    issue.status = Issue::IN_PROGRESS

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
