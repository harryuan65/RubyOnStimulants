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
  include Searchable
  include SequenceMaintainable
  Gutentag::ActiveRecord.call self

  validates :title, presence: true
  default_scope {includes(:user, :tags)}
  belongs_to :user
  has_many :comments
  has_one :last_comment, ->{select("distinct on (article_id) *").order("article_id desc, created_at desc")}, class_name: "Comment", foreign_key: :article_id
  enum state: [:draft, :published, :hidden]

  def self.hot
    includes(:user, :tags).order(Arel.sql("likes_count*comments_count desc"))
  end

  def self.get_title content
    if content!=""
      match_data = content.match(/#\s(.+)[\n|$]*/)
      return match_data[1]
    else
      nil
    end
  end

  def trimmed_content
    self.content.truncate(50, omission: "...(#{I18n.t('controller.articles.omission')})")
  end

  def self.to_markdown(text)
    options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote, :tables, :lax_spacing, :footnotes]
    options = options.inject({}){|res, d| res.merge({d=>true})}
    render = ActiveMineRenderer.new({hard_wrap: true, safe_links_only: true, with_toc_data: true})
    markdown = Redcarpet::Markdown.new(render, options)
    output = markdown.render(text)
    output = output.gsub(/\<\/p\>/, "</p><br>")
    output.html_safe
  end

  def self.backup(user_id:, file_path:,  **options)
    require 'zip'
    user = User.find user_id
    articles = Article.joins(:user).includes(:tags).where(users: {email: user.email})

    if options[:use_range] && options[:id_range]
      from_id = options[:id_range][:from_id].to_i
      to_id = options[:id_range][:to_id].to_i

      if to_id < from_id || from_id==0 || to_id==0
        raise StandardError, "InvalidRange: #{from_id}:#{from_id.class} ~ #{to_id}:#{to_id.class}"
      end

      articles = articles.where("articles.id between #{from_id} and #{to_id}")
    end

    ::Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
      articles.find_in_batches do |group|
        group.each do |article|
          zipfile.get_output_stream("art_#{article.id}_#{article.title.tr("\\\'\"\/ []:@*&,.?",'')[0..10]}.md") do |file|
            file.puts "title: #{article.title}"
            file.puts "tags: #{article.tags.map(&:name)}"
            file.puts article.content
          end
        end
      end
    end
    file_path
  end
end
