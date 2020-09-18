class ArticleRender < Redcarpet::Render::HTML
  def block_quote(quote)
    %(<blockquote class="my-custom-class">#{quote}</blockquote>)
  end
  def content(quote)
    %(<p class="article-page-content show notosans-light text-5b">#{quote}</p>)
  end
end