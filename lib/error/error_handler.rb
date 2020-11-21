module Error
  module ErrorHandler
    def self.included(origin_class)
      origin_class.class_eval do
        rescue_from StandardError, with: :server_error_json
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_json
        rescue_from ActionController::RoutingError, with: :route_not_found_json
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_json # handle starts
      end
    end

    private
    def record_not_found_json(exception)
      handle message_key: :record_not_found, exception: exception, status: :not_found
    end

    def record_invalid_json(exception)
      handle message: :record_invalid, exception: exception, status: :bad_request
    end

    def server_error_json(exception)
      Rollbar.error(exception)
      logger.fatal exception.to_s, exception.backtrace[0]
      handle message_key: :internal_server_error, exception: exception, status: :internal_server_error
    end

    def route_not_found_json(exception)
      handle message_key: :route_not_found, exception: exception, status: :not_found
    end

    def handle(message_key:, exception:, status:)
      i18n_message =  I18n.t("controller.general.#{message_key}")
      error_message = exception.to_s
      respond_to do |format|
        format.html {
          @status = status
          @i18n_message = i18n_message
          @error_message = error_message
          render "shared/error", status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        }
        format.js {render json: {flash: error_message, error: error_message}, status: status}
      end
    end
  end
end