const { app, BrowserWindow } = require("electron")

function createWindow() {
  let win = new BrowserWindow({
    width: 800,
    height: 600,
    autoHideMenuBar: true,
    webPreferences: {nodeIntegration: true}
  })
  win.loadFile("app/index.html")
}

app.on("ready", createWindow)
