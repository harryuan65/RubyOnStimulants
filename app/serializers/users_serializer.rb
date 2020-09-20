# class UsersSerializer < ActiveModel::Serializer
#   attributes :id, :name
#   attributes :articles_view_counts

#   def articles_view_counts
#     object.articles.sum(:view_count)
#   end
# end