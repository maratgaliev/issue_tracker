class Issues::CreateCommand < BaseCommand
  step :validate
  step :persist

  def validate(user:, params:)
    form = Issues::Form.call(params)

    if form.success?
      Right(user: user, params: form.to_h)
    else
      Left(form.errors)
    end
  end

  def persist(user:, params:)
    issue = Issue.new(params)

    issue.status = Issue::DEFAULT_STATUS
    issue.author_id = user.id

    if issue.save
      Right(issue)
    else
      Left(error(I18n.t('errors.base')))
    end
  end
end
