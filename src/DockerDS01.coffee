root = global ? window

if root.Meteor.isClient
	root.Template.hello.greeting = ->
		return "Welcome to Docker Test App"

root.Meteor.startup ->
	console.log "Server started up..."

	console.log "Testing path Npm package..."
	
	path = Npm.require("path")
	projCodeRoot = path.resolve(".").split(".meteor")[0]
	project_root = path.join(projCodeRoot,'..')
	console.log("Project root >> " + project_root)

	console.log "Testing python script..."

	execSync = Npm.require("exec-sync")
	pythonCommand = "python " + project_root + "/src/PyScript.py"
	pythonConsoleLog = execSync(pythonCommand)
	console.log pythonConsoleLog

	console.log "Testing libxmljs..."

	libxmljs = Npm.require("libxmljs")
	xml =  '<?xml version="1.0" encoding="UTF-8"?>' +
	           '<root>' +
	               '<child foo="bar">' +
	                   '<grandchild baz="fizbuzz">grandchild content</grandchild>' +
	               '</child>' +
	               '<sibling>with content!</sibling>' +
	           '</root>'

	xmlDoc = libxmljs.parseXml(xml)

	# xpath queries
	gchild = xmlDoc.get('//grandchild')

	# prints "grandchild content"
	printTxt = gchild.text()
	console.log printTxt