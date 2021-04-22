require 'rails_helper'

RSpec.describe "Tests", type: :request do
  describe '#index' do
    get '/'
    expect(response).to have_http_status(200)
  end
end
