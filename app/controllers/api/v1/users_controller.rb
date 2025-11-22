class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: [:register, :login]

  # POST /api/v1/users/register
  def register
    # Parametreleri direkt root'tan al
    user_attributes = {
      name: params[:name],
      email: params[:email],
      password: params[:password]
    }

    user = User.new(user_attributes)

    if user.save
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: {
        success: true,
        message: 'User created successfully',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at
        },
        token: token
      }, status: :created
    else
      render json: {
        success: false,
        error: 'Registration failed',
        details: user.errors
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/users/login
  def login
    email = params[:user].present? ? params[:user][:email] : params[:email]
    password = params[:user].present? ? params[:user][:password] : params[:password]

    user = User.find_by(email: email)

    if user&.authenticate(password)
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: {
        success: true,
        message: 'Login successful',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at
        },
        token: token
      }
    else
      render json: {
        success: false,
        error: 'Invalid credentials'
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JWT.decode(header, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError
      render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, error: 'User not found' }, status: :unauthorized
    end
  end
end
