module ApplicationHelper
  def svg_asset(name, **options)
    if options.any?
      option_str = options.reduce(""){|res, (k,v)| res = res + "#{k}=\"#{v}\" " }
    end
    (
      <<-HTML
        <svg #{option_str}>
          <use href="#{asset_path(name)}##{name}"></use>
        </svg>
      HTML
    ).html_safe
  end

  def svg(name, **options)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    if File.exists?(file_path)
      svg_element = File.read(file_path)
      if options.any?
        option_str = options.reduce(""){|res, (k,v)| res = res + "#{k}=\"#{v}\""+ " " }
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

  def current_position
    "#{params[:controller]}##{params[:action]}"
  end

  def should_show_sidebar
    ["articles#index"].include?(current_position)
  end
end
