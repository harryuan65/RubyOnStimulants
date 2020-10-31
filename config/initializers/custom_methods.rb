Hash.class_eval do
  def camelize_for_js
    self.stringify_keys.deep_transform_keys{|key| key.camelize(:lower)}
  end
  def underscorize_for_rb
    self.stringify_keys.deep_transform_keys{|key| key.underscore}
  end
end