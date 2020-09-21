import { Controller } from "stimulus"
let controller
let stream
let publisher
export default class extends Controller {
  connect() {
    controller = this
    console.log('pub connect');
    // 定義api key sessionId token
    this.apiKey = this.data.get("key")
    this.sessionId = this.data.get("sessionId")
    this.token = this.data.get("token")
    this.initializeSession()
    

  }
  disconnect() {
    if (this.session) {
      console.log('pub disconnect');
      this.session.disconnect()
    }
  }

  initializeSession() {
    // 建立房間的session
    this.session = OT.initSession(this.apiKey, this.sessionId)
    // console.log(this)
    OT.getDevices((e)=>{
      console.log(e)
    }) 
    // console.log(OT.getDevices() )
    // 建立 publisher
    this.publisher = OT.initPublisher('video', {
      insertMode: 'append',
      width: '100%',
      height: '100%',
      facingMode :"user",
      mirror:false,
      name: this.data.get("name"),
    }, this.handleError.bind(this))
    // 連線
    this.session.connect(this.token, this.streamConnect.bind(this))
    // publisher = this.publisher
    // publisher.cycleVideo().catch(console.error)
  }

  async streamConnect(error) {
    if (error) {
      this.handleError(error)
    } else {
      // 將 publish 發佈出去 ，return 一個 stream obj
      stream = this.session.publish(this.publisher, this.handleError.bind(this))
      // await subCounts(stream)
    }
  }

  handleError(error) {
    if (error) {
      console.error(error.message);
    }
  }
}
// 之後要實作 觀看人數
// let subCounts = (stream) => new Promise((resolve, reject) => {
//   // counts 是一個array
//   // setInterval(() => {
//     console.log(stream);
//     let subscribers= controller.session.getSubscribersForStream(stream)
//     console.log(subscribers)
//   // }, 500);
// })

// window.getCounts = function() {
//   let subscribers = controller.session.getSubscribersForStream(stream)
//   console.log(subscribers)
// }