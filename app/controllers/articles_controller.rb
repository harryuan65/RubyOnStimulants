class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:backup, :mine, :get_link_title]

  def index
    @limit = 10
    @offset = params[:offset] || 0
    if current_user
      @articles = Article.includes(:user, :tags).where(state: :published).or(
                    Article.includes(:user, :tags).where(state: [:draft, :hidden], user_id: current_user.id)
                  ).order(id: :desc).limit(@limit).offset(@offset)
    else
      @articles = Article.includes(:user, :tags).where(state: :published).order(id: :desc).limit(@limit).offset(@offset)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @article = Article.create!(title: "New Article", user_id: current_user.id, content: "# New Article", state: :draft)
    redirect_to edit_article_path(@article)
  end

  def create
    permitted_params = article_params
    tag_str = permitted_params.delete(:user, :tags)

    @article = Article.create!(permitted_params)
    @article.state = :draft if @article.state.nil?

    if tag_str!=""
      tags = tag_str.split(',').map(&:strip)
    end

    begin
      @article.update!(tag_names: tags)
      @article.save!
      return redirect_to article_path(@article), notice: I18n.t('controller.articles.update_success')
    rescue => exception
      redirect_to article_path(@article), alert: exception.to_s
    end
  end

  def mine
    @scope = "mine"
    @limit = 10
    @offset = params[:offset] || 0
    @articles = Article.includes(:user, :tags).where(state: :published).or(
      Article.includes(:user, :tags).where(state: [:draft, :hidden], user_id: current_user.id)
    ).order(id: :desc).limit(@limit).offset(@offset)
    respond_to do |format|
      format.html {render 'index'}
      format.js {render 'index'}
    end
  end

  def show
    @article = Article.find(params[:id])
    @is_author = current_user && current_user.email == @article.user.email
    if !@is_author && @article.hidden?
      @article = nil
      return render "shared/route_not_found"
    end
    @article.increment!(:view_count)
    # render plain: render_to_string("show")
    # @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
  end

  def edit
    @article = Article.find(params[:id])
    render 'edit'
  end

  def preview_markdown
    if current_user
      output = Article.to_markdown(params[:content])
      return render json: {success: true, content: output}
    else
      return render text: "Yee"
    end
  end

  def get_link_title
    param! :url, String
    begin
      res = RestClient.get(params[:url], {accept: :html, user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36"})
      doc = Nokogiri::HTML(res)
      return render plain: doc.at('title').children.text
    rescue RestClient::NotFound
      return render plain: I18n.t('controller.general.route_not_found')
    rescue SocketError
      return render plain: I18n.t('controller.general.invalid_url')
    end
  end

  def update_state
    param! :state, String, required: true

    @article = Article.find(params[:id])
    @article.update(state: params[:state])
    render json: {success: true, state: @article.state}
  end

  def update
    param! :content, String, required: true
    @article = Article.includes(:user, :tags).find(params[:id])
    current_tags = @article.tags.map(&:name)
    parsed_tags = Article.get_tags(params[:content])
    should_update_tags = Set.new(current_tags) != Set.new(parsed_tags)
    if should_update_tags
      @article.update!(
        title: Article.get_title(params[:content]),
        content: params[:content],
        tag_names: parsed_tags
      )
    else
      @article.update!(
        title: Article.get_title(params[:content]),
        content: params[:content]
      )
    end
    render json: {success: true, content: Article.to_markdown(@article.content)}
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      return redirect_to articles_path, notice: I18n.t('controller.articles.delete_success')
    rescue => exception
      return redirect_to article_path(@article), alert: I18n.t('controller.articles.delete_failed') + "error: " + exception.to_s
    end
  end

  def search
    @keyword = params[:keyword]
    article_ids = Article.search_with(@keyword)
    @limit = 10
    @offset = params[:offset] || 0
    if current_user
      @articles = Article.includes(:user, :tags).where(state: :published).or(
                    Article.includes(:user, :tags).where(state: [:draft, :hidden], user_id: current_user.id)
                  ).order(id: :desc).limit(@limit).offset(@offset)
    else
      @articles = Article.includes(:user, :tags).where(state: :published).order(id: :desc).limit(@limit).offset(@offset)
    end
    @articles = @articles.where(id: article_ids).index_by(&:id).slice(*article_ids).values

    render "search_result"
  end

  def backup_settings
  end

  def backup
    if current_user.premium?
      user_name = (current_user.email.split('@')[0]).gsub(/[^0-9a-zA-Z]/, '')
      output_dir = 'tmp/articles_output'
      file_name = ["articles", user_name, Date.current.to_s(:db)].join("_")
      file_path = "#{output_dir}/#{file_name}.zip"
      FileUtils.mkdir(output_dir) unless File.directory?(output_dir)
      File.open(file_path, "w") do |file|
        file.chmod(0644)
        file_path = file.path
        Article.backup( user_id: current_user.id,
                        file_path: file_path,
                        use_range: params[:use_range],
                        id_range: params[:id_range])
      end
      file = File.open(file_path, "r")
      # send_file will act async
      send_data file.read, type: 'application/zip', filename: "#{file_name}.zip"
      File.delete(file_path)
    else
      raise Error::UnauthorizedError
    end
  end

  def hot
    data = {
      update_time: Time.now,
      articles: Article.hot.to_a
    }
    @time = data[:update_time]
    @articles = data[:articles]
    render 'hot'
  end

  def cached_hot
    data = Rails.cache.fetch('hot_articles', expires_in: 2.minutes) do
      {
        update_time: Time.now,
        articles: Article.hot.to_a
      }
    end
    @time = data[:update_time]
    @articles = data[:articles]
    render 'hot'
  end

  private
  def article_params
    # params.permit(:title, :subtitle, :content, :privacy)
    params.require(:article).permit(:user_id, :title, :subtitle, :content, :state, :category, :user, :tags)
  end
end
