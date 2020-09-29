module ArticlesHelper
  def readable_time created_at
    created_at = created_at.in_time_zone("Taipei") if I18n.locale!=:en
    now = I18n.locale==:en ? Time.now.in_time_zone('UTC') : Time.now.in_time_zone("Taipei")
    if created_at.day==now.day # today
      if now.hour - created_at.hour==0 # created within 1 hour
        I18n.t('date.today.minutes_ago', minutes: now.min - created_at.min)
      else
        I18n.t('date.today.hours_ago', hours: now.hour - created_at.hour)
      end
    elsif created_at.year==now.year #same year
      I18n.t('date.same_year',
        month: I18n.locale==:en ? I18n.t('date.month_names')[created_at.month] : created_at.month,
        day: created_at.day,
        hour: created_at.strftime('%H'),
        minute: created_at.strftime('%M'))
    else #long ago
      I18n.t('date.long_ago',
        year: created_at.year,
        month: I18n.locale==:en ? I18n.t('date.month_names')[created_at.month] : created_at.month,
        day: created_at.day,
        hour: created_at.strftime('%H'),
        minute: created_at.strftime('%M'))
    end
  end
end
