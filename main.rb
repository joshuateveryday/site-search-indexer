require "json"
require "colorize"
require "wombat"
require "awesome_print"
require "sitemap-parser"


puts "Everyday Search Indexer".white.underline
puts ""
puts "Loading Sitemap for " + "https://www.lonestarnationalbank.com/".colorize(:yellow).underline


sitemap = SitemapParser.new "https://www.lonestarnationalbank.com/sitemap.xml"
pages = sitemap.to_a

search_index_data = []

pages.each do |page|
  page_path = page.gsub("https://www.lonestarnationalbank.com", "")
  puts "\t#{page_path}".colorize(:light_green)

  page_data = Wombat.crawl do 
    base_url "https://www.lonestarnationalbank.com"
    path page_path 

    title css: "h1"
    subTitle css: "h2"
    headings({css: "h3, h4"}, :list)
    pageContent({css: "p"}, :list)  
  end

  page_data["url"] = page 
  page_data["baseUrl"] = "https://www.lonestarnationalbank.com"
  page_data["path"] = page_path
  page_data["language"] = page_path.start_with?("/es") ? "es" : "en"
  search_index_data.push(page_data)
end


File.write("./search_index_data.json", JSON.pretty_generate(search_index_data))