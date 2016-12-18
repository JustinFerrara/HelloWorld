console.log('Loaded "HelloWorld" app.');
var fs = require('fs');
var {isDirectory, stats} = require('./utils/file')
var rootFolder = 'C://Users/ferra_000/Pictures';

function recurseFolder(folder) {
	console.log('Listing files/directories');
	fs.readdir(folder, (err, files) => {
		if (err) {
			console.log(err);
			return false;
		}
		files.forEach(file => {
			var path = folder + '/' + file,
					directory = isDirectory(path),
					fileData = stats(path);
			console.log(directory, fileData, path);
			if (fileData.isDirectory()){
				recurseFolder(path);
			}
		});
	});
}

recurseFolder(rootFolder);