class ActiveMineRenderer < Redcarpet::Render::HTML
  def initialize(render_options)
    super(render_options)
  end

  # def block_code(code, language)
  #   lang = code.match(/#\s([^\s]+)/)
  #   if lang && lang[1]
  #     %(<div class="#{lang[1]}">#{code}</div>)
  #   else
  #     %(<div class="nohighlight">#{code}</div>)
  #   end
  # end

  # def link(link, title, content)
  #   "TEST"
  # end
end