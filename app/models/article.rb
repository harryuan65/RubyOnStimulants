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
  Gutentag::ActiveRecord.call self

  validates :title, presence: true

  belongs_to :user
  has_many :comments
  has_one :last_comment, ->{order("id desc")}, class_name: "Comment", foreign_key: :article_id
  enum state: [:draft, :published, :not_public]

  def trimmed_content
    self.content.truncate(50, omission: "...(#{I18n.t('controller.articles.omission')})")
  end

  def self.to_markdown(text)
    options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote, :tables, :lax_spacing, :footnotes]
    options = options.inject({}){|res, d| res.merge({d=>true})}
    render = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(render, options)
    output = markdown.render(text)
    # output = output.gsub(/\<\/p\>/, "</p><br>")
    output.html_safe
  end
end
