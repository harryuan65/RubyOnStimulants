module Error
  class UnauthorizedError < CustomError
    def initialize
      super(status: :unauthorized, i18n_key: :unauthorized)
    end
  end
end