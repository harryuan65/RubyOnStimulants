require 'line/bot'
class LineController < ApplicationController
  def webhook
    body = request.body.read
    puts body

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless $line_client.validate_signature(body, signature)
      return render plain: 'Bad request', status: :bad_request
    end

    events = $line_client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::Follow
          line_uid = event['source']['userId']
          res = $line_client.get_profile(line_uid)
          profile = JSON.parse(res.body)
          line_user = OnbLineUser.where(line_uid: line_uid).first
          unless line_user
            params_camel_keys_to_underscore = Hash[*p.map{|k,v| [k.underscore.to_sym,v]}.flatten]
            line_user = OnbLineUser.create!(params_camel_keys_to_underscore)
          end
          # This will consume usage
          # I18n.use_locale(line_user.language.to_sym)
          # $line_client.push_message(line_uid, I18n.t('controller.line.welcome'))
        when Line::Bot::Evnet::Unfollow
          line_uid = event['source']['userId']
          OnbLineUser.find_by(line_uid: line_uid)&.update({
              archived: true,
              blocked_channel_at: Time.now
          })
        when Line::Bot::Event::MessageType::Text
          # TODO:
          # text = event.message['text']
          # match_data = text.match(/^([a-zA-Z]+).s$/)
          # if match_data && match_data[1]
          #   query = match_data[1]
          # end
          # doc = Nokogiri::HTML(RestClient.get("https://dictionary.cambridge.org/zht/%E8%A9%9E%E5%85%B8/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/autonomy"))
          message = {
            type: 'text',
            text: I18n.t('controller.line.currently_no_services') #   text: event.message['text']
          }
          # https://developers.line.biz/media/messaging-api/sticker_list.pdf
          sticker = {
            :type=>"sticker",
            :packageId=>"11537",
            :stickerId=>"52002750",
            :stickerResourceType=>'ANIMATION'
          }
          $line_client.reply_message(event['replyToken'], [message, sticker])
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = $line_client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    end

    # Don't forget to return a successful response
    return render json:{success: true}
  end
end
