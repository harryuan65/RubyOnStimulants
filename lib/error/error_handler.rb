module Error
  module ErrorHandler
    def self.included(origin_class)
      origin_class.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      end
    end

    private
    def record_not_found(exception)
      render json: {message: I18n.t('controller.general.record_not_found'), error: exception.to_s}, status: :not_found
    end
  end
end