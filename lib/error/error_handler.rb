module Error
  module ErrorHandler
    def self.included(origin_class)
      origin_class.class_eval do
        rescue_from StandardError, with: :server_error_handler
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_handler
        rescue_from ActionController::RoutingError, with: :route_not_found_handler
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler
        rescue_from CustomError do |error| # handle starts
          handle status: error.status,
                 i18n_message: error.i18n_message,
                 error_message: error.error_message
        end
      end
    end

    private
    def record_not_found_handler(exception)
      handle i18n_message: I18n.t("controller.general.record_not_found"), error_message: exception.to_s, status: :not_found
    end

    def record_invalid_handler(exception)
      handle i18n_message: I18n.t("controller.general.record_invalid"), error_message: exception.to_s, status: :bad_request
    end

    def server_error_handler(exception)
      Rollbar.error(exception)
      error_details = exception.to_s + "\n" + exception.backtrace[0]
      logger.fatal error_details
      handle i18n_message: I18n.t("controller.general.internal_server_error"), error_message: error_details, status: :internal_server_error
    end

    def route_not_found_handler(exception)
      handle i18n_message: I18n.t("controller.general.route_not_found"), error_message: exception.to_s, status: :not_found
    end

    def handle(i18n_message:, error_message:, status:)
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