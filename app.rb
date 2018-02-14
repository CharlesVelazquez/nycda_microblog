require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:mirco_blog_db.sqlite3"
set :sessions, true

require './models'

get '/' do
	erb :index
end

get '/create_new_user' do
	@usernames = User.all
	erb :create_new_user
	end

post '/new_user' do
	if User.where("username = ?", params[:username]) != []
		@error = 'This Username Already exist'
		erb :error
	else
	User.create(username: params[:username], password: params[:password], country: params[:country], passion: params[:passion])
	redirect '/'
	end
end
end

get '/verify' do
	@all_users = User.all
	@username = params[:username]
	@password = params[:password]

	if User.where(["username = ? and password = ?", @username, @password])
			@temp = User.where(["username = ? and password = ?", @username, @password])
			@user = @temp[0]
			@post = Post.where(user_id: @user.id)
			session[:user_id] = @user.id
			erb :user
		else
			@error = "Username or Password Doesn't match"
			erb :error
	end 
end

get '/users/:id/edit' do
	# @user = User.find(params[:id]) **I'm pretty sure I don't need this
	erb :edit_user_info
end


post '/update_username' do
	@user = User.find(session[:user_id])
	User.update(username: params[:username])
	redirect '/' 
	end

post '/update_password' do
	@user = User.find(session[:user_id])
	User.update(password: params[:password])
	redirect '/' 
	end

post '/update_country' do
	@user = User.find(session[:user_id])
	User.update(country: params[:country])
	redirect '/' 
	end

post '/update_passion' do
	@user = User.find(session[:user_id])
	User.update(passion: params[:passion])
	redirect '/' 
	end

post '/destroy_user' do 
	@user = User.find(params[:id])
	@user.destroy
	redirect '/'
end
