# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'
require 'omniauth'
require 'omniauth-facebook'
require 'koala'
require 'fb_graph'
require 'instagram'
require 'flickraw'
# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

# use OmniAuth::Builder do 
# 	provider :facebook, '536207676431466', '32d23d51ecb9a84ac2686f7062b8a78e' 
# end

Koala.http_service.http_options = {
  :ssl => { :ca_path => "/etc/ssl/certs" }
}
Instagram.configure do |config| 
  config.client_id = "5337a0186c57406782838f1d8792fcf8"
  config.client_secret = "87a100ec76a548069c59ac5505f8dafd"
end
