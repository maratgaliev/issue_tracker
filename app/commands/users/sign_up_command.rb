class Users::SignUpCommand < BaseCommand
  step :validate
  step :persist

  def validate(params)
    form = Users::SignUpForm.call(params)

    if form.success?
      Right(form.to_h)
    else
      Left(form.errors)
    end
  end

  def persist(attributes)
    user = User.new(attributes)
    user.role = User::DEFAULT_ROLE

    if user.save
      Right(user)
    else
      Left(user.errors.messages)
    end
  end
end
