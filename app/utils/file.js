var fsp = require('fs-promise');
var fs = require('fs')

var imageExtenstions = ['jpg', 'jpeg', 'png', 'gif'];

function fileExtenstion(filename) {
	var i = filename.lastIndexOf('.')
	return (i < 0) ? '' : filename.substr(i + 1).toLowerCase()
}

function getFiles(folder) {
	var files =	fs.readdirSync(folder)
	if (!files || files.length === 0)
		return []
	return files.map(function(file){
		var path = folder + file
		var stat = fs.statSync(path)
		var ext = fileExtenstion(file)

		console.log(global.site.staticPath, folder, path)
		return {
			fullPath: path,
			parentPath: folder,
			path: path.replace(global.site.staticPath, ''),
			name: file,
			extenstion: ext,
			isImage: (imageExtenstions.indexOf(ext) > -1),
			isDirectory: stat.isDirectory(),
			isFile: stat.isFile()
		}
	})

}

module.exports = {
	getFiles: getFiles
}
