require 'sinatra'
require 'yaml'
require 'uri'
require 'httparty'
require 'erb'

use Rack::Logger

set :config_path, File.expand_path('../config.yml', __FILE__)
set :config, ->{ YAML.load(ERB.new(File.read(config_path)).result) }

helpers do
  def logger
    request.logger
  end
  def config
    settings.config[params['app']] || {}
  end
end

get '/' do
  if ENV["SECRET"] && params.delete("secret") == ENV["SECRET"]
    content_type :json
    status 200
    return JSON.pretty_generate(settings.config)
  end
  status 200
  "ok"
end

post '/' do
  if ENV["SECRET"] && params.delete("secret") != ENV["SECRET"]
    status 401
    return
  end
  logger.info "RECIEVED POST: #{params.inspect}"
  forwardable_params = params.dup
  forwardable_params.delete('splat')
  forwardable_params.delete('captures')

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
