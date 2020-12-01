class UsersController < ApplicationController

    get '/signup' do
        if Helpers.is_logged_in?(session)
            redirect "/tweets"
        else
            erb :"users/new"
        end
    end

    post "/signup" do 
        user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
     
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            redirect "/signup"
        else  
            user.save
            session[:user_id] = user.id
            redirect "/tweets"
        end
    end

    get '/login' do
        if Helpers.is_logged_in?(session)
            redirect "/tweets"
        else
            erb :"users/login"
        end
    end

    post "/login" do
        user = User.find_by(:username => params[:username])
            if user && user.authenticate(params[:password])
                session[:user_id] = user.id
                redirect "/tweets"
            else
                redirect "/"
            end
    end

    get "/logout" do
        session.clear
        redirect "/login"
    end

    get "/users/:slug" do
        @user = User.find_by_slug(params[:slug])
        @tweets = @user.tweets
        erb :'users/show'
    end
end
