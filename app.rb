#Starting with getting everything that is required
require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'

#Now setting the databse and creating a session
set :database, "sqlite3:mirco_blog_db.sqlite3"
set :sessions, true


#starting routes, keeping in order what someone would do
get '/' do
	@posts = Post.all
	erb :index
end

get '/create_new_user' do
	@usernames = User.all #This is so we can check for existing usernames
	erb :create_new_user
end

post '/new_user' do
#This if will check for existing username by checking for a return
	if User.where("username = ?", params[:username]) != []#will not be an empty array if it didn't find anybody
			@error = 'This Username Already exist'#making a instance variable that will have a string with the specific error to be used on the error page
			erb :error
	else#creates user if where did get an empty array from not finding a prexisting username
		flash[:alert] = 'Sucessfully created your Account'
		User.create(username: params[:username], password: params[:password], country: params[:country], passion: params[:passion])
		redirect '/'
	end
end

#will start checking if the login info is valid
get '/verify' do
	@all_users = User.all #grabbing all users
	@username = params[:username] #grabbing the username the user entered
	@password = params[:password] #also grabbing the password
=begin
This if will check if there is a match in the database using username
and password, since where returns an array even if it finds only one
user we will have to stipulate at some point to select that one user
in the array, I chose to just assign the entire array to a variable
and then set that variable to the @user variable while targetting the
first location. Then the usual session id stuff
=end
	if User.where(["username = ? and password = ?", @username, @password]) != []
			temp = User.where(["username = ? and password = ?", @username, @password])
			@user = temp[0]
			@post = Post.where(user_id: @user.id)
			session[:user_id] = @user.id
			erb :user
	else
			@error = "Username or Password Doesn't match"
			erb :error
	end 
end

get '/users/:id/edit' do #targeting user id in the url and then taking the user to the edit page
	erb :edit_user_info
end

get '/users/:id/logout' do
	flash[:alert] = 'Sucessfully Logged out, till next time ;)'
	session[:user_id] = nil
	redirect '/'
end

=begin
Since these next post are repeats, I'll sum it up here, we find the
specific user via the session Id, assing it to the variable user,
then update the pertaining information to the variable, which then
changes the information in the databse since the variable is linked
via telepathy =) 
=end

post '/update_username' do
	user = User.find(session[:user_id])
	user.update(username: params[:username])
	redirect '/' 
end

post '/update_password' do
	user = User.find(session[:user_id])
	user.update(password: params[:password])
	redirect '/' 
end

post '/update_country' do
	user = User.find(session[:user_id])
	user.update(country: params[:country])
	redirect '/' 
end

post '/update_passion' do
	user = User.find(session[:user_id])
	user.update(passion: params[:passion])
	redirect '/' 
end

post '/destroy_user' do 
	user = User.find(session[:user_id])
	user.destroy
	redirect '/'
end

=begin
The post codes work exactly the same as the user codes, one thing I
thought was kinda cool that we did was we established a post id
using sessions which is awesome, tested it out and it works so session
I guess can store multiple different things, good to know. So the
following code will be the same as User for the most part
=end

post '/new_post' do
	Post.create(title: params[:title], catagory: params[:category], content: params[:content], user_id: session[:user_id] )
	redirect '/'
end

get '/post/:id' do
	@post = Post.find(params[:id])
	erb :post
end

get '/post/edit/:id' do
	@post = Post.find(params[:id])
	session[:post_id] = params[:id]
	erb :edit_post
end


post '/update_title' do
	a = Post.find(session[:post_id])
	a.update(title: params[:title])
	redirect '/' 
end

post '/update_content' do
	a = Post.find(session[:post_id])
	a.update(content: params[:content])
	redirect '/' 
end

post '/update_category' do
	a = Post.find(session[:post_id])
	a.update(catagory: params[:category])
	redirect '/' 
end


post '/destroy_post' do 
	post = Post.find(params[:id])
	post.destroy
	redirect '/'
end

get '/about' do

erb :about

end

get '/profile' do
	if session[:user_id] == nil
		erb: index
else
	@user_id = session[:user_id]
	@user = User.find(session[:user_id])
	@post = Post.where(user_id: @user.id)
	erb :user
	
	end
end




__END__

This is the end of the document, hope all the code is to
your liking.