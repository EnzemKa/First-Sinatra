require 'rubygems'
require 'sinatra'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

get '/' do 					
  erb :index
end

post '/' do
	erb :message
end

### ADMIN ###

get '/admin' do 					
  erb :admin
end

post '/admin' do
	@username = params['username']
	@adminpassword = params[:adminpassword]

	if @adminpassword == 'qwertyui'
		session[:identity] = @username
		@logfile = File.readlines('users.txt')
		erb :admin
	elsif @adminpassword == 'admin'
		@error = 'Haha, you are cheater! Wrong login or password'
		erb :admin
	else
		@error = 'Wrong password'
		erb :admin
	end
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

### CHECK IN ###

get '/checkin' do 					
  erb :checkin
end

post '/checkin' do
	@username = params[:username]
	@userphone = params[:userphone]
	@date_time = params[:date_time]

	@title = 'Thank you!'
	@message = "Dear #{@username}, we'll be waiting at #{@date_time}"
	
	f = File.open 'users.txt', 'a'
	f.write "User: #{@username},\tPhone: #{@userphone},\tDate and time: #{@date_time}\n"
	f.close

	f = File.open '/public/users.txt', 'a'
	f.write "User: #{@username},\tPhone: #{@userphone},\tDate and time: #{@date_time}\n"
	f.close

	erb :message
end