class CreateUsersTableAndPosts < ActiveRecord::Migration[5.1]
  def change
  	create_table :users do |t|
  		t.string :username
  		t.string :password
  		t.string :country
  		t.string :passion
  	end
  end
end
