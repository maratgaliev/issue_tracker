class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  MODERATOR_ROLE = 'moderator'.freeze
  DEFAULT_ROLE = 'user'.freeze

  def moderator?
    self.role == MODERATOR_ROLE
  end
end
