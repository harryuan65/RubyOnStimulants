class Article < ApplicationRecord
  belongs_to :user
  has_many :comments

  def trimmed_content
    self.content.truncate(28, omission: "...(#{I18n.t('controller.articles.omission')})")
  end
end
