class StoriesController < ApplicationController
  before_action :find_story, only: [:show, :destroy]

  def index
    @user = User.find(params[:user_id])
    @stories = @user.stories.includes(:user).order("created_at DESC").where('created_at >= ?', Time.zone.now - 1.day)
    # 去撈24hr內po的storiesa，測試時可以用5.second。

    # 讓原先的 N + 1 Query 變成 1 (Post) + 1 (User)，scope寫在models
    stories_users = [User.last].concat(User.last.followings.includes(:stories).order("created_at DESC")).select{|user| user.exist_story?}.map{|user| user.nick_name}
    if stories_users.index(@user.nick_name) + 1 != stories_users.length
      @next_user_name = stories_users[stories_users.index(@user.nick_name) + 1]
    end

    if stories_users.index(@user.nick_name) != 0
      @prev_user_name = stories_users[stories_users.index(@user.nick_name) - 1]
    end
  end

  def new
    check_owner
    @story = current_user.stories.new
    authorize @story
  end

  def create
    # byebug
    @story = current_user.stories.new(story_params)
    # byebug
    authorize @story
    # byebug
    if @story.save
      redirect_to user_stories_path, notice: "限時動態新增成功"
    else
      # byebugc

      render :new
    end
  end

  def destroy
    authorize @story
    @story.destroy
    stories_count = current_user.stories.stories_oneday.count

    if(stories_count == 0)
      redirect_to root_path, notice: "已經沒有限時動態"
    else
      redirect_to user_stories_path, notice: "限時動態刪除成功"
    end
  end

  private

  def find_story
    @story = Story.find(params[:id])
  end

  def story_params
    # params.permit(:picture)
    # 問助教為什麼不給過？
    params.require(:story).permit(:picture)
  end
end
