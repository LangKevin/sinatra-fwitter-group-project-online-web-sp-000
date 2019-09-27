class TweetsController < ApplicationController
    get '/tweets' do
      if is_logged_in?
        @tweets = Tweet.all
        erb :'tweets/tweets'
      else
        redirect to '/login'
      end
    end

    get '/tweets/new' do
      if is_logged_in?
        erb :'tweets/new'
      else
        redirect to '/login'
      end
    end

    post '/tweets' do
      if !is_logged_in?
        redirect to '/login'
      else
        if params[:content] == ""
          redirect to "/tweets/new"
        else
# binding.pry
          @tweet = Tweet.find_by(content: params[:content])
          if @tweet
            redirect to "/tweets/#{@tweet.id}"
          else
            @tweet = Tweet.new(content: params[:content])
            @tweet.user = current_user
            @tweet.save
          end
        end
      end
    end
    get '/tweets/:id' do
        if !is_logged_in?
          redirect to '/login'
        else
# binding.pry
          @tweet = Tweet.find_by_id(params[:id])
          erb :'tweets/show_tweet'
        end
      end

      get '/tweets/:id/edit' do
        if !is_logged_in?
          redirect to '/login'
        else
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            erb :'tweets/edit_tweet'
          else
            redirect to '/tweets'
          end
        end
      end
    patch '/tweets/:id' do
      if !is_logged_in?
        redirect to '/login'
      else
        if params[:content] == ""
          redirect to "/tweets/#{params[:id]}/edit"
        else
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            retVal = @tweet.update(content: params[:content])
            if retVal
              redirect to "/tweets/#{@tweet.id}"
            else
             redirect to "/tweets/#{@tweet.id}/edit"
            end
          else
            redirect to '/tweets'
          end
        end
      end
    end

    delete '/tweets/:id/delete' do
      if !is_logged_in?
        redirect to '/login'
      else
        #binding.pry
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          @tweet.delete
        end
        redirect to '/tweets'
      end
    end
end
