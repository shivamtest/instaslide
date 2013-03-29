before do 
  graph
end

APP_ID = '536207676431466'
APP_SECRET = '32d23d51ecb9a84ac2686f7062b8a78e'
FlickRaw.api_key= "07672b550a22fed0da5dabbd5bbe3fc3"
FlickRaw.shared_secret= "d9b76c1facb4d0ec"


SITE_URL = 'http://localhost:9292/'
include Koala

get '/' do
  # Look in app/views/index.erb

  erb :index
end

get '/login/facebook' do 
	session['oauth_facebook'] = Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + 'callback/facebook')
	redirect session['oauth_facebook'].url_for_oauth_code(permissions: "user_photos")
end
get '/callback/facebook' do 
	session['access_token_facebook'] = session['oauth_facebook'].get_access_token(params[:code])
  session[:user] = user = User.find_by_access_token_facebook(session['access_token_facebook'])
  unless user 
    session[:user] = user = User.create(name: graph.get_object('me')["name"], access_token_facebook: session['access_token_facebook'])
  end     
  redirect '/slides/new'
end

get '/logout/facebook' do 
  session['oauth_facebook'] = nil 
  session['access_token_facebook'] = nil 
  @graph = nil
  redirect '/'
end



get '/login/instagram' do 
  redirect Instagram.authorize_url(redirect_uri: SITE_URL + 'callback/instagram')
end

get '/callback/instagram' do 
  response = Instagram.get_access_token(params[:code], redirect_uri: SITE_URL + 'callback/instagram')
  session[:access_token_instagram] = response.access_token
  if session[:user]
    user = User.find(session[:user].id)
    user.access_token_instagram = session[:access_token_instagram]
    user.save 
  else
    user = User.create(access_token_instagram: session[:access_token_instagram])
  end
  redirect '/'
end

get '/logout/instagram' do 
  session[:access_token_instagram] = nil 
  redirect '/'
end


get '/login/flickr' do 
  session[:oauth_flickr] = flickr.get_request_token
  redirect flickr.get_authorize_url(session['oauth_flickr']['oauth_token'], perms: 'delete')
end

get '/callback/flickr' do 
  session[:access_token_flickr] = flickr.get_access_token(session['oauth_flickr']['oauth_token'], session['oauth_flickr']['oauth_token_secret'], params[:flickr])
  redirect '/'
end

get '/logout/flickr' do 
  session[:oauth_flickr] = nil 
  session[:access_token_flickr] = nil
  redirect '/'
end


get '/slides/new' do 
  @img_srcs = get_image_sources
  @instagram = instagram_client
  @flickr = flickr_client
  erb :slide
end

post '/slide' do 
  slide = Slide.create(name: params[:name], description: params[:description])
  params[:photos].each do |photo|
    photo.gsub!("?size=t", "")
    photo.gsub!("_s", "_b")
    slide.photos.create(photo_url: photo)
  end
  redirect "/slide/#{slide.id}"
end

get '/slide/:id' do 
  @slide = Slide.find(params[:id])
  erb :"slides/show"
end

# get '/auth/:provider/callback' do 
# 	erb "<h1>#{params[:provider]}</h1>"
# end
