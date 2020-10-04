class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_ranking_data
  before_action :search_ransack



  def show
    @micropost = Micropost.find(params[:id])
    REDIS.zincrby "microposts", 1, @micropost.id
    REDIS.zincrby "users", 1, @micropost.user_id
    ids = REDIS.zrevrangebyscore "microposts", "+inf",0
    user_ids = REDIS.zrevrangebyscore "users", "+inf",0
    @ranking_microposts = ids.map{ |id| Micropost.find(id) } 
    @ranking_users = user_ids.map{ |id| User.find(id) } 
  end

  def set_ranking_data
    ids = REDIS.zrevrangebyscore "microposts", "+inf" ,0
    user_ids = REDIS.zrevrangebyscore "users", "+inf",0
    @ranking_microposts = ids.map{ |id| Micropost.find(id) } 
    @ranking_users = user_ids.map{ |id| User.find(id) } 
  end

  def search_ransack
    @q = Micropost.ransack(params[:q])
    @qposts = @q.result(distinct: true)
  end
  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end
end
