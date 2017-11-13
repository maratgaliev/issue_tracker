class Issues::AssignCommand < BaseCommand
  step :authorize
  step :assign

  def authorize(id:, assignee:)
    issue = Issue.find(id)

    if assignee.moderator? && issue.unassigned?
      Right(issue: issue, assignee: assignee)
    else
      Left(error(I18n.t('errors.issues.not_assignable')))
    end
  end

  def assign(issue:, assignee:)
    issue.assignee_id = assignee.id

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
