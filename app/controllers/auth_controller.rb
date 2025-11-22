class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:register, :login]

  def register
    user = User.new(user_params)

    if user.save
      token = generate_token(user)
      render_success({ user: user_data(user), token: token })
    else
      render_error(user.errors.full_messages.join(', '))
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = generate_token(user)
      render_success({ user: user_data(user), token: token })
    else
      render_error('Invalid email or password', :unauthorized)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end

  def generate_token(user)
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end

  def user_data(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      created_at: user.created_at
    }
  end
end
