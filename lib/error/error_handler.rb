module Error
  module ErrorHandler
    def self.included(origin_class)
      origin_class.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_json
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_json
        rescue_from StandardError, with: :server_error_json
        rescue_from ActionController::RoutingError, with: :route_not_found_json
      end
    end

    private
    def record_not_found_json(exception)
      render json: {flash: I18n.t('controller.general.record_not_found'), error: exception.to_s}, status: :not_found
    end
    def record_invalid_json(exception)
      render json: {flash: I18n.t('controller.general.record_invalid'), error: exception.to_s}, status: :bad_request
    end
    def server_error_json(exception)
      render json: {flash: I18n.t('controller.general.internal_server_error'), error: exception.to_s}, status: :internal_server_error
    end
    def route_not_found_json(exception)
      render json: {flash: I18n.t('controller.general.route_not_found'), error: exception.to_s}, status: :not_found
    end
  end
end