module Error
  module ErrorHandler
    def self.included(origin_class)
      origin_class.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
        rescue_from StandardError, with: :server_error
      end
    end

    private
    def record_not_found(exception)
      render json: {message: I18n.t('controller.general.record_not_found'), error: exception.to_s}, status: :not_found
    end
    def record_invalid(exception)
      render json: {message: I18n.t('controller.general.record_invalid'), error: exception.to_s}, status: :bad_request
    end
    def server_error(exception)
      render json: {message: I18n.t('controller.general.internal_server_error'), error: exception.to_s}, status: :internal_server_error
    end
  end
end