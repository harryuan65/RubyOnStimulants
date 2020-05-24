# == Schema Information
#
# Table name: articles
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  title         :string           not null
#  content       :text             not null
#  like_count    :integer          default(0)
#  view_count    :integer          default(0)
#  comment_count :integer          default(0)
#  privacy       :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Article < ApplicationRecord
  belongs_to :user
  has_many :comments

  def trimmed_content
    self.content.truncate(28, omission: "...(#{I18n.t('controller.articles.omission')})")
  end
end
