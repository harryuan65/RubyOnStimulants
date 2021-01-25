module ArticlesHelper
  def should_expand_for_new
    ["articles#new", "articles#edit"].include? "#{params[:controller]}##{params[:action]}"
  end

  def readable_time created_at
    created_at = created_at.in_time_zone("Taipei") if I18n.locale!=:en
    now = I18n.locale==:en ? Time.now.in_time_zone('UTC') : Time.now.in_time_zone("Taipei")
    if created_at.day==now.day # today
      if now.hour - created_at.hour==0 # created within 1 hour
        I18n.t('time.formats.today.minutes_ago', minutes: (now.min - created_at.min).abs)
      else
        I18n.t('time.formats.today.hours_ago', hours: (now.hour - created_at.hour).abs)
      end
    elsif created_at.year==now.year #same year
      I18n.t('time.formats.same_year',
        month: I18n.locale==:en ? I18n.t('date.abbr_month_names')[created_at.month] : created_at.month,
        day: created_at.day)
    else #long ago
      I18n.t('time.formats.long_ago',
        year: created_at.year,
        month: I18n.locale==:en ? I18n.t('date.abbr_month_names')[created_at.month] : created_at.month,
        day: created_at.day)
    end
  end
end
