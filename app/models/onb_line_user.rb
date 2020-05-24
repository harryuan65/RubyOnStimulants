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

class OnbLineUser < ApplicationRecord
  validates_presence_of :line_uid
  validates_presence_of :display_name
  validates_uniqueness_of :user_id
end
