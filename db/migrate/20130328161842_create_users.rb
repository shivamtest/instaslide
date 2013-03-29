class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name 
      t.string :access_token_facebook
      t.string :access_token_instagram
      t.string :access_token_flickr
    end
  end
end
