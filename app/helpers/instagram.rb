helpers do 
  def instagram_client
    @instagram_client = Instagram.client(access_token: session[:access_token_instagram])
  end
end
