Users::SignUpForm = Dry::Validation.Form do
  configure do
    config.messages = :i18n

    def email?(value)
      !Devise.email_regexp.match(value).nil?
    end

    def login?(value)
      !User.exists?(login: value)
    end

    def password?(value)
      value.length.in?(Devise.password_length)
    end
  end

  required(:email).filled(:str?, :email?)
  required(:login).filled(:str?, {min_size?: 3}, :login?)
  required(:password).filled(:str?, :password?)
end
