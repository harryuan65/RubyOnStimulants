class Vocab < ApplicationRecord
  def parsed_examples
    if self.examples.any?
        self.examples.map do |str|
          Hash[*str.scan(/:(.*)=>"(.*)", :(.*)=>"(.*)"/).flatten].symbolize_keys
        end
    end
  end
end
