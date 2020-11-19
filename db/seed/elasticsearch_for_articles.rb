# for function score test
Article.where("length(content)<=2").find_each do |a|
  data = ["database", "rails", "nodejs", "react", "next.js", "redis", "mysql", "elasticsearch"].sample
  if [true, false].sample
    a.title+="-#{data}"
  else
    a.content = data
  end
  a.save
end