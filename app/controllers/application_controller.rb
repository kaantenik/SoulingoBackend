class ApplicationController < ActionController::API
  before_action :authenticate_user, except: [:register, :login]

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(decoded[0]['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def render_success(data = {})
    render json: { success: true, data: data }
  end

  def render_error(message, status = :bad_request)
    render json: { success: false, error: message }, status: status
  end
end
