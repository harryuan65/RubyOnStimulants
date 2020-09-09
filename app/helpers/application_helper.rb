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
  def taipei_time time
      time.in_time_zone("Taipei")
  end
end
