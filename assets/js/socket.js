import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("ws_listener:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

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
