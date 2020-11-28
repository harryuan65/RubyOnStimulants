class ActiveMineRenderer < Redcarpet::Render::HTML
  def initialize(**options)
    super(options)
  end

  def block_code(code, language)
    if language
      <<-HTML
        <pre>
          <code class="#{language}">#{code}</code>
        </pre>
      HTML
    else
      <<-HTML
        <pre>
          <code class="plaintext">#{code}
          </code>
        </pre>
      HTML
    end
  end

  def link(link, title, content)
    %(<a href="#{link}" target="_blank">#{content}</a>)
  end
end