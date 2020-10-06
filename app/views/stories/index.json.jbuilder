# json.array! @stories do |user_stories|
#   user = User.find(user_stories[0])
#   json.user do
#     json.extract! user, :id, :nick_name, :avatar
#     json.stories user_stories[1] do |story|
#       json.id story.id
#       json.picture story.picture
#       json.time story.created_at
#     end
#   end
# end

# json.user do
#   json.extract! @result[:user], :id, :nick_name, :avatar
# end

# json.stories do
#   json.array! @result[:stories] do |story|
#     json.id story.id
#     json.picture story.picture
#     json.time story.created_at
#     json.user do
#       json.extract! story.user, :nick_name, :avatar
#     end
#   end
# end

json.user do
  json.index @result[:user_index]
  json.name @result[:user_name]
end

json.stories do
  json.array! @result[:stories] do |story|
    json.id story.id
    json.picture story.picture
    json.time story.created_at
    json.user do
      json.extract! story.user, :nick_name, :avatar
    end
  end
end
