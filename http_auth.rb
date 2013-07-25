require 'sinatra'

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ["CUSTOM_USERNAME","SECRET_PASSWORD"]
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Oops... we need your login name & password\n"])
    end
  end

  get "/protected_content" do
    protected!
    "in secure"
  end

  get "/" do
    "anyone can access"
  end
# end