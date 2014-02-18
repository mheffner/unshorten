require "sinatra"

require 'net/http'

require 'json'

enable :sessions
set :raise_errors, false
set :show_exceptions, false

dev_null = File.open("/dev/null", "a")
use Rack::Cors, :logger => Logger.new(dev_null) do
  allow do
    origins '*'
    resource '/*', :headers => :any,
    :methods => [:get, :post, :put, :delete],
    :expose => ['Location']
  end
end

before do
  content_type 'application/json'
end

helpers do
  def unshort_api_key
    ENV['UNSHORT_API_KEY']
  end
end

get "/unshorten" do
  shorturl = params[:url]

  long = Unshorten[shorturl] rescue nil
  if long
    halt 200, {:requestedURL => shorturl, :resolvedURL => long}.to_json
  else
    halt 500, "{\"error\" : \"failed\"}"
  end
end
