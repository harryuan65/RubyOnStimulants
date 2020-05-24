# == Schema Information
#
# Table name: onb_line_users
#
#  id                 :bigint           not null, primary key
#  line_uid           :string
#  display_name       :string
#  picture_url        :string
#  status_message     :string
#  language           :string
#  archived           :boolean          default(FALSE)
#  blocked_channel_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class OnbLineUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
