module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Serializing
    include Elasticsearch::Model::Callbacks
    settings index: { number_of_shards: 1 }

    mappings dynamic: 'false' do
      indexes :user_id, type: 'integer'
      indexes :title, type: 'text'
      indexes :content, type: 'text'
      indexes :likes_count, type: 'integer'
      indexes :view_count, type: 'integer'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
      indexes :state, type: 'keyword'
      indexes :comments_count, type: 'integer'
    end
    # Article.__elasticsearch__.create_index!

    def self.search_with(keyword)
      query = {
        # sort: [{created_at: "desc"}],
        # size: 20,
        # query: {
        #   bool: {
        #     must: [
        #       multi_match: {
        #         query: keyword,
        #         fields: ["title", "content"]
        #       }
        #     ]
        #   }
        # }
        query: {
          function_score: {
            query: {
              multi_match: {
                query: keyword,
                fields: ["title^2", "content"]
              }
            }
          }
        }
      }
      res = Article.__elasticsearch__.search query
      res.results.results.map{|h| h['_id'].to_i}
    end
  end

  def as_indexed_json(_options = {})
    as_json.merge(tag_names: self.tag_names)
  end
end