import consumer from "./consumer"

document.addEventListener("turbolinks:load",()=>{
  // console.log(consumer.subscriptions)

  let unreadChannels = consumer.subscriptions.subscriptions.filter(sub=> JSON.parse(sub.identifier).channel === "UnreadMessageNotificationChannel") //找有沒有在unreadchannel
  // console.log(unreadChannels)
  if(unreadChannels.length >= 1){
    unreadChannels.forEach((unreadChannel)=>{
      consumer.subscriptions.remove(unreadChannel)
    })
  }
  //如果有直接全部刪除避免多訂閱


  let unreadMessagesDiv= document.createElement("div")
  unreadMessagesDiv.classList.add("unread-messages")


  consumer.subscriptions.create("UnreadMessageNotificationChannel", {
    connected() {
      console.log("unread_message........")
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      console.log("disconnected")
      // Called when the subscription has been terminated by the server
    },

    newMessage(data){
      console.log(data)
      this.perform("new_message",data) //將訊息傳送到unread＿message_channel.rb
    },

    received(data) {
      let chatChannle = this.consumer.subscriptions.subscriptions.filter(sub=> JSON.parse(sub.identifier).channel === "ChatChannel") //找有沒有在chatchannel

      // // console.log(chatChannle.length)

      if(chatChannle.length === 1)return //有的話代表正在聊天室中，不發通知

      this.newMessage(data.message) //執行newMessage方法

      let chatUsers = Array.from(document.querySelectorAll(".chat-user")) //選取訊息盒的所有聊天的人
      // console.log(data)
      let chatUser = chatUsers.filter((user)=>{
        return Number(user.dataset.chatUser) == data.message.user_id
      }) // 比對這則訊息是誰傳的


      if (!!chatUser[0]){ // 如果有人傳新訊息把目前上線的div換成新訊息的div
         let onlineText = chatUser[0].querySelector(".chat-user-info .online-text")
         if(onlineText){ //有無目前上線樣式
           chatUser[0].querySelector(".chat-user-info").append(unreadMessagesDiv)
           onlineText.remove()
          }
        }

        if(!data.read_message){// 判斷有無讀取訊息
          if(!!chatUser[0]){
            let newMessages = chatUser[0].querySelector(".chat-user-info .unread-messages")
            // 找有沒有新訊息的字
            chatUser[0].querySelector(".notice-dot").classList.add("message-notice-dot")
            newMessages.textContent = `您有${data.new_message_counts += 1}則新訊息`
          }
        }else{
          if(chatUser.length === 0)return //避免其他頁面出現錯誤訊息

          chatUser[0].querySelector(".notice-dot").classList.remove("message-notice-dot")
          chatUser[0].querySelector(".chat-user-info .unread-messages").remove()
        }
      // console.log(data.message)
      // Called when there's incoming data on the websocket for this channel
    }
  });
})
