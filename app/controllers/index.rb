APP_ID = '536207676431466'
APP_SECRET = '32d23d51ecb9a84ac2686f7062b8a78e'
SITE_URL = 'http://localhost:9292/'
include Koala

get '/' do
  # Look in app/views/index.erb

  erb :index
end

get '/login' do 
	session['oauth'] = Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + 'callback')
	redirect session['oauth'].url_for_oauth_code()
end

get '/logout' do 
	session['oauth'] = nil 
	session['access_token'] = nil 
	redirect '/'
end

get '/callback' do 
	session['access_token'] = session['oauth'].get_access_token(params[:code])
	redirect '/'
end


# get '/auth/:provider/callback' do 
# 	erb "<h1>#{params[:provider]}</h1>"
# end