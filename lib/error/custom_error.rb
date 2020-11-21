module Error
  class CustomError < StandardError
    attr_reader :status, :i18n_message, :error_message
    def initialize(status:, i18n_key:, error_message: "" )
      @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] || status # can use symbol or status code directly
      @i18n_message = I18n.t("controller.general.#{i18n_key}")
      @error_message = error_message.empty?? error_message : @i18n_message
    end
  end
end