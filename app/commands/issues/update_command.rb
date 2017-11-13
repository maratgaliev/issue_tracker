class Issues::UpdateCommand < BaseCommand
  step :authorize
  step :check_status
  step :validate
  step :update

  def authorize(id:, user:, params:)
    issue = Issue.find(id)

    if issue.of_user?(user.id)
      Right(issue: issue, params: params)
    else
      Left(error(I18n.t('errors.issues.not_author')))
    end
  end

  def check_status(issue:, params:)
    if issue.pending?
      Right(issue: issue, params: params)
    else
      Left(error(I18n.t('errors.issues.not_editable')))
    end
  end

  def validate(issue:, params:)
    form = Issues::Form.call(params)

    if form.success?
      Right(issue: issue, params: form.to_h)
    else
      Left(form.errors)
    end
  end

  def update(issue:, params:)
    issue.assign_attributes(params)

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
