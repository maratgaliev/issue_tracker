class Authorize::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    Users::SignUpCommand.run(sign_up_params) do |m|
      m.success do |user|
        sign_up(resource_name, user)
        render json: {user: user}
      end

      m.failure do |errors|
        render json: {errors: errors}, status: :unprocessable_entity
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit([:email, :login, :password])
  end
end
