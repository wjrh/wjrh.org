require 'json'
require 'net/http'
require 'nokogiri'
require 'dotenv'
require 'open-uri'
Dotenv.load

###
# Compass
###
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

activate :directory_indexes

TEAL_URL = "api.teal.cool"


  def convtime(episode)
    if (!episode['length'].eql?("") and !episode['length'].nil? and !episode['length'].include?(":"))
    episode['length'] = Time.at(episode['length'].to_i).utc.strftime("%H:%M:%S")
    end
  end


@programs = []
# retrieve program information
response = URI.parse("https://#{ENV["TEAL_URL"] ||=TEAL_URL}/organizations/wjrh").read
programs = JSON.parse(response)
programs.each do |programPreview|
  programPreview['image'] = "https://placeholdit.imgix.net/~text?txtsize=400&txt=#{programPreview["name"]}&w=1400&h=1400" if (programPreview['image'].nil? or programPreview['image'].eql?(""))
  program_req = URI.parse("https://#{ENV["TEAL_URL"] ||=TEAL_URL}/programs/#{programPreview['shortname']}").read
  program = JSON.parse(program_req)
  program['image'] = "https://placeholdit.imgix.net/~text?txtsize=400&txt=#{program["name"]}&w=1400&h=1400" if (program['image'].nil? or program['image'].eql?(""))
  program['cover_image'] = "https://placeholdit.imgix.net/~text?txtsize=50&txt=#{program["name"]}&w=960&h=480" if (program['cover_image'].nil? or program['cover_image'].eql?(""))
  program['episodes'].each {|episode| convtime(episode)}
  if program['episodes'].length != 0
    @programs.push(program)
    proxy "/#{programPreview['shortname']}.html", "/templates/program.html", :locals => { :program => program, :title => program["name"] },:ignore => true
    proxy "/#{programPreview['shortname']}/feed.xml", "/templates/feed.html", :locals => { :program => program, :title => program["name"]},:ignore => true, :directory_index => false, :layout => false
    program['episodes'].each do |episode|
      ep_req = URI.parse("https://#{ENV["TEAL_URL"] ||=TEAL_URL}/episodes/#{episode['id']}").read
      ep = JSON.parse(ep_req)
      p ep['name']
      convtime(ep)
      ep['image'] = program['image'] if (ep['image'].nil? or ep['image'].eql?(""))
      proxy "/#{program['shortname']}/#{ep['id']}.html", "/templates/episode.html", :locals => { :ep => ep, :title => ep["name"], :program => program },:ignore => true
    end
  end
end
p @programs



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
    programs_req = URI.parse("https://#{ENV["TEAL_URL"] ||=TEAL_URL}/programs/#{program['shortname']}/feed.xml").read
    return programs_req
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
