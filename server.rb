require 'sinatra'
require 'yaml'
require 'uri'
require 'httparty'

use Rack::Logger

set :config_path, File.expand_path('../config.yml', __FILE__)
set :config, ->{ YAML.load_file(config_path) }

helpers do
  def logger
    request.logger
  end
  def config
    settings.config[params['app']] || {}
  end
end

get '/' do
  status 200
  "ok"
end

post '/' do
  logger.info "RECIEVED POST: #{params.inspect}"
  forwardable_params = params.dup
  forwardable_params.delete('splat')
  forwardable_params.delete('captures')

  config.values.each do |url|
    uri = URI.parse(url)
    query = Rack::Utils.parse_query(uri.query)
    query = forwardable_params.merge(query)
    uri.query = Rack::Utils.build_query(query)
    logger.info "POSTING TO: #{uri}"
    # HTTParty.post uri.to_s
  end

  status 201
  "ok"
end
