module ApplicationHelper
  def svg(name, **options)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    if File.exists?(file_path)
      svg_element = File.read(file_path)
      if options.any?
        option_str = options.reduce(""){|res, (k,v)| res = res + "#{k.to_s}=\"#{v.to_s}\""+ " " }
        svg_element = svg_element.gsub(/^\<svg/, "<svg " + option_str)
      end
      return svg_element.html_safe
    else
      '(not found)'
    end
  end
  def username(user)
    user.email.split('@')[0]
  end
  def taipei_time time
    time.in_time_zone("Taipei")
  end
  def markdown(text)
    options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote]
    # options = options.map(&->(e){{e=>true}})
    options = options.inject({}){|res, d| res.merge({d=>true})}
    render = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(render, options)
    # Markdown.new(text, *options).to_html.html_safe
    markdown.render(text).gsub(/\<\/p\>/, "</p><br>").html_safe
  end
end
