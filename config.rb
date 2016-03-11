require 'json'
require 'net/http'
require 'nokogiri'
require 'dotenv'
Dotenv.load

###
# Compass
###
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

activate :directory_indexes

TEAL_URL = "api.teal.cool"

# retrieve program information
programs_req_url = URI.parse("http://#{ENV["TEAL_URL"] ||=TEAL_URL}/programs")
req = Net::HTTP::Get.new(programs_req_url.path)
req.body = @show.to_json
req.add_field("teal-api-key", ENV["TEAL_KEY"])
response = Net::HTTP.new(programs_req_url.host, programs_req_url.port).start {|http| http.request(req) }
@programs = JSON.parse(response.body)
@programs.each do |programPreview|
	p programPreview['shortname']
  program_req_url = URI.parse("http://#{ENV["TEAL_URL"] ||=TEAL_URL}/programs/#{programPreview['shortname']}")
  program_req = Net::HTTP.get_response(program_req_url)
  program = JSON.parse(program_req.body)
  proxy "/#{programPreview['shortname']}.html", "/templates/program.html", :locals => { :program => program, :title => program["name"] },:ignore => true
  proxy "/#{programPreview['shortname']}/feed.xml", "/templates/feed.html", :locals => { :program => program },:ignore => true, :directory_index => false, :layout => false
end



page "*.md", :layout => "markdown"
# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
 helpers do
    def getimguralbumimages(album_id)
     	uri = URI.parse("https://api.imgur.com/3/album/#{album_id}/images")
      http = Net::HTTP.new(uri.host, uri.port)
    	req = Net::HTTP::Get.new(uri.path)
   	  req.add_field("Authorization", "Client-ID #{ENV["IMGUR_CLIENT_ID"] ||=IMGUR_CLIENT_ID}")
   	  http.use_ssl = true
     	res = http.start do |h|
      	 h.request(req)
     	end
     	images = JSON.parse(res.body)
			return images["data"]
    end


   def generatefeed(program)
    programs_req_url = URI.parse("http://#{ENV["TEAL_URL"] ||=TEAL_URL}/programs/#{program['shortname']}/feed.xml")
    programs_req = Net::HTTP.get_response(programs_req_url)
    return programs_req.body
   end
 end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

end
