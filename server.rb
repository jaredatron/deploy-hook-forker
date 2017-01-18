ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require

require 'sinatra'
require 'yaml'
require 'uri'
require 'httparty'
require 'erb'

use Rack::Logger

configure :development do
  require 'dotenv'
  Dotenv.load
end

configure do
  set :config_path, File.expand_path('../config.yml', __FILE__)
  set :config, ->{ YAML.load(ERB.new(File.read(config_path)).result) }
  set :secret, ENV["SECRET"]
  puts "SECRET=#{ENV["SECRET"]}"
  puts settings.config.inspect
end


helpers do
  def logger
    request.logger
  end

  def config
    settings.config[params['app']] || {}
  end
end

before do
  if settings.secret && params["secret"] != settings.secret
    halt 401, "Unauthorized"
  end
end

get '/' do
  content_type :json
  status 200
  JSON.pretty_generate(settings.config)
end

post '/' do
  logger.info "RECIEVED POST: #{params.inspect}"
  forwardable_params = params.dup
  forwardable_params.delete('splat')
  forwardable_params.delete('captures')
  forwardable_params.delete('secret')

  config.values.each do |url|
    uri = URI.parse(url)
    query = Rack::Utils.parse_query(uri.query)
    query = forwardable_params.merge(query)
    logger.info "POSTING TO: #{uri}, BODY: #{Rack::Utils.build_query(query)}"
    HTTParty.post( uri.to_s, body: query )
  end

  status 201
  "ok"
end
