@Payrollsio.module "Utilities", (Utilities, App, Backbone, Marionette, $, _) ->
	
	App.mainBus.comply "when:fetched", (entities, callback) ->
		# calls the callback function when entities are fetched from server

		xhrs = []

		# chain - enables chaining of functions. It returns wrapped object
		# 				until value() method is called
		# flatten - flattens object and returns flat array
		# pluck - maps array of object extracting only '_fetch' object 
		xhrs = _.chain([entities]).flatten().pluck("_fetch").value()

		$.when(xhrs...).done ->
			callback()

	_.extend App,
		addBlackOverlay: ->
			docHeight = $(document).height()

			$("body")
				.append("<div id='overlay'></div>")

			$("#overlay")
				.height(docHeight)
				.hide()
				.fadeTo(300, 0.5)
				.css
					'position': 'absolute'
					'top': 0
					'left': 0
					'background-color': 'black'
					'width': '100%'
					'z-index': 5000

		removeBlackOverlay: ->
			$("#overlay").remove()

		nameFromEmail: (email) ->
			email.substring 0, email.indexOf("@") 

	App.mainBus.reply "save:token", ->
		App.csrfToken = $("meta[name='csrf-token']").attr('content')