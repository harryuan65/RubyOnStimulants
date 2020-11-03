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
      status = :not_found
      respond_to do |format|
        format.html {
          @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          @message = I18n.t('controller.general.record_not_found')
          render json: "shared/result", flash: @message
        }
        format.json {render json: {flash: I18n.t('controller.general.record_not_found'), error: exception.to_s}, status: status}
      end
    end
    def record_invalid_json(exception)
      status = :bad_request
      respond_to do |format|
        format.html {
          @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          @message = I18n.t('controller.general.record_invalid')
          render "shared/result", flash: @message
        }
        format.js {render json: {flash: I18n.t('controller.general.record_invalid'), error: exception.to_s}, status: status}
      end
    end
    def server_error_json(exception)
      status = :internal_server_error
      logger.fatal exception.to_s
      logger.fatal exception.backtrace[0]
      respond_to do |format|
        format.html {
          @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          @message = I18n.t('controller.general.internal_server_error') + ": " + exception.to_s
          render "shared/result", flash: @message
        }
        format.js {render json: {flash: I18n.t('controller.general.internal_server_error'), error: exception.to_s}, status: status}
      end
    end
    def route_not_found_json(exception)
      status = :not_found
      respond_to do |format|
        format.html {
          @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          @message = I18n.t('controller.general.route_not_found')
          render "shared/result", flash: @message
        }
        format.js {render json: {flash: I18n.t('controller.general.route_not_found'), error: exception.to_s}, status: status}
      end
    end
  end
end