path = require 'path'
exec = require('child_process').exec
config = require('./config').config

zip = (input,output) ->
	cmd = "#{config.zip} #{input} #{output}"
	exec cmd ,(error,stdout,stderr) ->
		console.log stdout
	return output

txt2any = (filePath) ->
	fileName = ((path.basename filePath).split '.')[0]

	txtDir = path.dirname "#{filePath}"
	shpDir = path.normalize "#{config.downloadDir}"

	zipInpputDir = path.normalize "#{config.downloadDir}/#{fileName}"
	zipOutputFile = path.normalize "#{zipInpputDir}.zip"

	cmd = "#{config.txt2shp} -i #{txtDir} -o #{shpDir}"
	exec cmd,(error,stdout,stderr) ->
		zip zipInpputDir,zipOutputFile
		console.log stdout
	return zipOutputFile

inc = (n)->	
	i = 0	
	-> i+=n	

convert = (name) ->
	txt2any(name)

exports.fileNum = inc(1)
exports.convert = convert
