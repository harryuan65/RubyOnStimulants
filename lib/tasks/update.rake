namespace :news do
    a = [
      ["13", "Implement mockup into Rails: Home page"],
      ["14", "Add side nav + its transition"],
      ["15", "add article show page"],
      ["16", "refactor style a little bit"],
      ["17", "article edit page mock up"],
      ["18", "article edit page in rails"],
      ["19", "researching markdown"],
      ["20", "add markdown support in articles#edit/show"],
    ]
    b = a.reverse.map do |arr|
      <<-HTML
        <div class="article-container">
          <a href="" class="article-link">
           <h3 class="article-title notosans-bold">Update: __,#{arr[0]} Sep 2020</h3>
           <span class="article-description notosans-light text-5b">#{arr[1].capitalize}</span>
          </a>
          <span class="article-author notosans-light text-5b">harry</span>
          <span class="article-created-at notosans-light text-5b">Sep #{arr[0]}</span>
        </div>
      HTML
    end
end

