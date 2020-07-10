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
    document.getElementById("bc-rate").innerHTML = "Current BTC rate is: " + rate
}

document.getElementById("ws-button").addEventListener("click",
    function() {
    document.getElementById("ws-field").innerHTML = "<p>Welcome to my project!</p>"
        channel.push("ping").
            receive("ok", function(msg) {
           console.log("done", msg)
           document.getElementById("ws-field").innerHTML = "<p>I hope you will appreciate it!</p>"
        })
    })

export default socket
