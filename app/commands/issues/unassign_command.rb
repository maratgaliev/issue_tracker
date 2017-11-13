class Issues::UnassignCommand < BaseCommand
  step :authorize
  step :unassign

  def authorize(id:, assignee:)
    issue = Issue.find(id)

    if assignee.moderator? && issue.assigned_by?(assignee.id) && issue.pending?
      Right(issue)
    else
      Left(error(I18n.t('errors.issues.not_unassignable')))
    end
  end

  def unassign(issue)
    issue.assignee_id = nil

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
