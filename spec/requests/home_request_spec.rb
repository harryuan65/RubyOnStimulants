require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe '#index' do
    it 'should return 200' do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
