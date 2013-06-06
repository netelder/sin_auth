get '/' do
  # render home page
  @users = User.pluck(:name) if current_user
  erb :index
end

#----------- SESSIONS -----------

get '/sessions/new' do
  # render sign-in page 
  erb :sign_in
end

post '/sessions' do
  user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      @users = User.pluck(:name)
      erb :index
    else # login incorrect
      @badlogin = true
      erb :sign_in
    end
end

delete '/sessions/:id' do
  session.clear
end

#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  erb :sign_up
end

post '/users' do
  p params[:user]
  @user = User.find_or_create_by_email(:email => params[:email], :name => params[:name], :password => params[:password])
  @user = User.find_or_create_by_email(params[:user])
  if @user
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
    end
  end
  redirect '/'
end
