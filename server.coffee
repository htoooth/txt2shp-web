http = require 'http'
url = require 'url'

start = (route,handle)->
	onRequest = (request,response) ->

		pathname = url.parse(request.url).pathname
		console.log "Requset for #{pathname} received."
		route handle,pathname,response,request

	server =http.createServer onRequest 
	server.listen 8888
	console.log 'Server has started.'

exports.start = start