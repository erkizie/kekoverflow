import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("ws_listener:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
channel.on("rate", msg => {
    var rate = Object.values(msg)
    showRate(rate[0])
})

function showRate(rate) {
    if(document.getElementById("bc-rate"))
        document.getElementById("bc-rate").innerHTML = "Current BTC rate is: " + rate
    else
        console.log("Sorry, go to the root page")
}

export default socket
