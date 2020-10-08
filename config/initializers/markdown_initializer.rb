options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote]
# options = options.map(&->(e){{e=>true}})
options = options.inject({}){|res, d| res.merge({d=>true})}
renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
$markdown = Redcarpet::Markdown.new(renderer, options)