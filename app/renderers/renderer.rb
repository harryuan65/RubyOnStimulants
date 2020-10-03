# class Render < Redcarpet::Render::HTML
#   def block_quote(quote)
#     lang = quote.match /#\s([^\s]+)/
#     if lang && lang[1]
#       %(<blockquote class="#{lang[1]}">#{quote}</blockquote>)
#     else
#       %(<blockquote class="nohighlight">#{quote}</blockquote>)
#     end
#   end
# end