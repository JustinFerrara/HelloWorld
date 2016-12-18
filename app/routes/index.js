var express = require('express')
var {getFiles} = require('../utils/file')

router = express.Router()

function render(req, res) {
	var folder = (req.params[0]) ? req.params[0] : ''

	var fullPath = global.site.staticPath + '/' + folder

	console.log(folder, fullPath, files)

	var files = getFiles(fullPath)

	res.locals = {
		title: 'Homepage'
	}

	res.render('home', {
		files: files
	})

}

router.get('/', render)
router.get('/*', render)

module.exports = router