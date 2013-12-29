exec = require('child_process').exec
querystring = require 'querystring'
fs = require 'fs'

formidable = require './formidable'
txt2shp = require('./application').convert
fileNum = require('./application').fileNum
config = require('./config').config
path = require 'path'

file = 
	upload:config.uploadDir
	download:config.download

sleep = (sec) ->
	startTime = new Date().getTime()
	1 while new Date().getTime() < startTime + sec

dir = (reponse)->
	console.log 'Request handler "start" was called'
	exec 'ls',(error,stdout,stderr) ->
		reponse.writeHead 200,{'Content-Type':'text/plain'}
		reponse.write stdout
		do reponse.end

start = (reponse)->
	console.log 'Request handler "start" was called'
	body = '''
		<html>
		<head>
		<meta http-equiv="Content-Type" content="text/html" charset="UTF-8" />
		</head>
		<body>
		welcome to my world!</br>
		<form action="/upload" method="post" enctype="multipart/form-data">
		<input type ="file" name="upload" value="on" />
		<input type="submit" value="Upload file" />
		</form>
		</body>
		</html>
	'''
	reponse.writeHead 200,{'Content-Type':'text/html'}
	reponse.write body
	do reponse.end

upload = (reponse,request) ->
	console.log 'Request handler "upload" was called'
	form = new formidable.IncomingForm()
	console.log 'about to parse'
	form.uploadDir = config.uploadDir 
	form.parse request,(error,fields,files)->
		console.log 'parsing done'
		filenum = fileNum()
		newDir =  path.normalize "#{config.uploadDir}/#{filenum}"
		fs.mkdirSync newDir
		file.upload = path.normalize "#{newDir}/#{filenum}.txt"
		fs.renameSync files.upload.path, file.upload 
		file.download = txt2shp file.upload
		reponse.writeHead 200,{'Content-Type':'text/html'}
		reponse.write '''Please <a href="/download">click here</a> to download data.'''
		do reponse.end

download = (reponse) ->
	console.log 'Request handler "download" was called'
	fs.readFile "#{file.download}",'binary',(error,file)->
		if error
			reponse.writeHead 500,{'Content-Type':'text/plain'}
			reponse.write error+'\n'
			reponse.end()
		else
			reponse.writeHead 200,{'Content-Type':'application/zip'}
			reponse.write file,'binary'
			reponse.end()

exports.start = start 
exports.upload = upload
exports.download = download
exports.dir = dir