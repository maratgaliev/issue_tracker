class Issues::DestroyCommand < BaseCommand
  step :authorize
  step :destroy

  def authorize(id:, user:)
    issue = Issue.find(id)

    if issue.of_user?(user.id)
      Right(issue)
    else
      Left(error(I18n.t('errors.issues.not_author')))
    end
  end

  def destroy(issue)
    issue.delete
    Right(:deleted)
  end
end
