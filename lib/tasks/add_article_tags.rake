desc "Initialize article tags base on title"
task :articles_tags_setup => :environment do
  Article.all.each do |article|
    title = article.title.downcase
    article.tag_names << "ruby" if title.include?("ruby")
    article.tag_names << "rails" if title.include?("rails")
    article.tag_names << "javascript" if title.include?("javascript")
    article.tag_names << "tech" if title.include?("linux") || title.include?("docker") || title.include?("dokku")
    article.tag_names << "general" if article.tag_names.empty?
    article.save
  end
end