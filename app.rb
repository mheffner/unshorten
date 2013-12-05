require "sinatra"

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

get "/unshorten" do
end
