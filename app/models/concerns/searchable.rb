module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Serializing
    include Elasticsearch::Model::Callbacks
  end

  def self.search(keyword)

  end

  def as_indexed_json(_options = {})
    as_json.merge(tag_names: self.tag_names)
  end
end