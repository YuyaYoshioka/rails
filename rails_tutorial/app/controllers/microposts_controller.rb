class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  def new
    
    @micropost = Micropost.new
  end

  def show_ranking
  end

  def index
    @q = Micropost.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end


  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      flash[:success] = '記事が更新されました'
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  def create
    @micropost = Micropost.new(micropost_params)
    if @micropost.save
      flash[:success] = '記事が作成されました'
      redirect_to @micropost
    else
      @feed_items = []
      render 'new'
    end
  end

  def destroy
    REDIS.zincrby "users", -REDIS.zscore("microposts", @micropost.id).to_i, @micropost.user_id
    REDIS.zrem 'microposts', params[:id]
    @micropost.destroy
    flash[:success] = '記事が削除されました'
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:title,:content).merge(user_id: current_user.id)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
