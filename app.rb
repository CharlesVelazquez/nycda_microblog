require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:mirco_blog_db.sqlite3"
set :sessions, true

require './models'

get '/' do
	erb :index
end

get '/create_new_user' do
	erb :create_new_user
	end

get '/verify' do
	@all_users = User.all
	@username = params[:username]
	@password = params[:password]

	if User.where(["username = ? and password = ?", @username, @password])
			@temp = User.where(["username = ? and password = ?", @username, @password])
			@user = @temp[0]
			session[:user_id] = user_id
			erb :user
		else
			erb :error
	end 
end

post '/new_user' do
User.create(username: params[:username], password: params[:password], country: params[:country], passion: params[:passion])
redirect '/'
end