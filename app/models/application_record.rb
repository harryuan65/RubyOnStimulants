class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.connect
    models = ActiveRecord::Base.descendants.select{|model| model if model.to_s!="ApplicationRecord"}
    models.each do |model|
      model.connection
    end
  end
end
