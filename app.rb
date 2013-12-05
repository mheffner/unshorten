require "sinatra"

require 'net/http'

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
  def unshort_apikey
    ENV['UNSHORT_API_KEY']
  end
end

get "/unshorten" do
  shorturl = params[:url]

  uri = URI("http://api.unshort.me/unshorten/v2/?format=json&api_key=#{unshort_api_key}&r=" + shorturl)

  res = Net::HTTP.get_response(uri)

  if res.is_a?(Net::HTTPSuccess)
    halt 200, res.body
  else
    halt 500, "{\"error\" : \"#{res.body}\"}"
  end
end
