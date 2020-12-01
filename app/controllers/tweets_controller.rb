class TweetsController < ApplicationController

    get '/tweets' do
        if Helpers.is_logged_in?(session)
            @tweets = Tweet.all
            erb :'tweets/index'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if Helpers.is_logged_in?(session)
            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        
            if params[:content].empty?
                redirect '/tweets/new'
            end
        @tweet = Tweet.create(params)
        @user = User.find(session[:user_id])
        @user.tweets << @tweet
        redirect "tweets/#{@tweet.id}"
    end

    get '/tweets/:id' do
        if Helpers.is_logged_in?(session)
            @tweet = Tweet.find(params[:id])
            erb :'tweets/show'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if Helpers.is_logged_in?(session)
            @tweet = Tweet.find(params[:id])
            erb :'tweets/edit'
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
      
        @tweet = Tweet.find(params[:id])
        if params[:content].empty?
            redirect "/tweets/#{@tweet.id}/edit"
        end
        if Helpers.is_logged_in?(session) && @tweet.user.id == session[:user_id]
            @tweet.update(:content => params[:content])
            redirect "/tweets/#{@tweet.id}"
        else
            redirect "/login"
        end
    end

    delete '/tweets/:id/delete' do
        @tweet = Tweet.find(params[:id])
        if Helpers.is_logged_in?(session) && @tweet.user.id == session[:user_id]
            @tweet.destroy
            redirect "/tweets"
        else
            redirect "/tweets/#{@tweet.id}"
        end
    end
end
