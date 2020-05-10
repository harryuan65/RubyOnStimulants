require 'line/bot'
class LineController < ApplicationController
    def webhook
      body = request.body.read
      puts body

      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless $client.validate_signature(body, signature)
       render plain: 'Bad request', status: :bad_request
      end

      events = $client.parse_events_from(body)
      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: event.message['text']
            }
            $client.reply_message(event['replyToken'], message)
          when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
            response = $client.get_message_content(event.message['id'])
            tf = Tempfile.open("content")
            tf.write(response.body)
          end
        end
      end

      # Don't forget to return a successful response
      return render json:{success: true}
    end
end
