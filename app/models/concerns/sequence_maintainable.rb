module SequenceMaintainable
  extend ActiveSupport::Concern
  included do
    def self.find_with_sequence(ids)
      self.find(ids).index_by(&:id).slice(*ids).values
    end
  end
end