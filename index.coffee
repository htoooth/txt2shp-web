server = require './server'
router = require './router'
requestHandlers = require './requestHandlers'

handle = {}
{
	start:handle['/']
	start:handle['/start']
	upload:handle['/upload'] 
	download:handle['/download']
	dir:handle['/dir'] 
} = requestHandlers

server.start router.route,handle