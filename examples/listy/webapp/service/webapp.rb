#!/usr/bin/env ruby
require 'sinatra'
require 'rest-client'

# We need this to work in boot2docker
set :bind, '0.0.0.0'
# http://stackoverflow.com/questions/17334734/how-do-i-get-sinatra-to-work-with-httpclient
set :server, 'webrick'

helpers do
  def items
    # Docker link will have added an appropriate entry to
    # our /etc/hosts, so we just request 'http://backend'.
    # The forwarder will add our host identity to the request.
    #
    # Response is like {"list": ["item1", "item2", ...]}
    JSON.parse(RestClient.get('http://backend'))['list']
  end

  def add_item item
    RestClient.post 'http://backend', name: item
  end
end

get '/' do
  erb :index
end

post '/' do
  add_item params[:name]
  # This is a stupid hack to make redirects work behind our rather complex proxy set
  redirect env['HTTP_REFERER']
end
