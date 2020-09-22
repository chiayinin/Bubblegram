class PagesController < ApplicationController
  def index
    per_count = 20
    @following_users = current_user.followings.order("created_at DESC")
    viewable_users = User.viewable_users(current_user)
    @results = build_results
    @posts = Post.includes(:user, :thumbs_up_users).viewable_posts(viewable_users).order("created_at DESC").limit(per_count)
    @has_more_posts = (@posts.count >= per_count)
  end

  private

    # 將所需要的結果組成陣列，塞給render的collection
    def build_results
      [ # 若current_user 有限時動態，轉到show，若沒有，則到new
        { user: current_user, path: current_user.exist_story? ? user_story_path(user_id: current_user.id, id: current_user.stories.last.id) : new_user_story_path(user_id: current_user.id) }
      ].concat(
        # 若following_users 有直播，轉到直播的show，若沒有，則到限時動態
        @following_users.map do |user|
          { user: user, path: user.exist_room? ? room_path(id: user.room.id) : user_stories_path(user) }
        end
      )
    end
end
