renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
$markdown = Redcarpet::Markdown.new(renderer, no_infra_emphasis: true, fenced_code_blocks: true, disable_indented_code_blocks: true)