#config     = require '../config/config'
express    = require 'express'
ejs        = require 'ejs'

#routes     = require '../routes'

count   = 0

app     = express.createServer()

app.configure ->
     app.use express.logger()
     app.use express.static "#{__dirname}/../public"
     app.use express.bodyParser()
     app.use express.methodOverride()
     app.use app.router
     app.set 'view engine', 'ejs'
     app.set 'views', "#{__dirname}/../views"
     app.set 'view options', { layout: false}

app.get '/', (req, res) ->
     res.render 'index.ejs'

console.log "Server has started."

server = app.listen 62000
io     = require('socket.io').listen server

sockets = []

io.sockets.on 'connection', (socket) ->
     sockets[socket.id] = socket
     io.sockets.emit 'user connected', count

     socket.on 'count up', () ->
         console.log "count : " + count
         count += 1
         io.sockets.emit 'user connected', count

     #socket.on 'disconnect', () ->
        #    console.log "connect user : " + count
        #    count -= 1
        #    io.sockets.emit 'user disconnected', count
   
module.exports = app

setInterval ->
    io.sockets.emit 'uesr connected', count
, 500
