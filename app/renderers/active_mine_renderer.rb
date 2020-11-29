class ActiveMineRenderer < Redcarpet::Render::HTML
  def initialize(**options)
    super
  end

  def link(link, title, content)
    %(<a href="#{link}" target="_blank">#{content}</a>)
  end
end