@Payrollsio.module "Controllers", (Controllers, App, Backbone, Marionette, $, _) ->

	class Controllers.Application extends Marionette.Controller

		# constructor is called even before initialize method
		constructor: (options = {}) ->
			# request handled in app.js.coffee. Returns mainRegion
			# we need it to extend show method below.
			# Region is extracted form options if it was passed when
			# controller was constructed. Otherwise it uses defaul region

			@region = options.region or App.mainBus.request "default:region"
			super options

			# create unique id for each controller
			@_instance_id = _.uniqueId("controller_")
			App.mainBus.command "register:instance", @, @_instance_id

		# arguments passed to destroy will be automatically passed 
		# to super so we don't need to explicitly pass them
		destroy: ->
			super
			App.mainBus.command "unregister:instance", @, @_instance_id

		show: (view, options = {}) ->
			_.defaults options,
				loading: 	false
				region:		@region

			@_setMainView view

			@_manageView view, options

		_setMainView: (view) ->
			# the first view we show is always going to become the mainView 
			# of our controller (whether its a layout or another view type). 
			# So if this 'is' a layout, when we show other regions inside of 
			# that layout, we check for the existance of a mainView first, 
			# so our controler is only closed down when the original
			# mainView is closed.

			# _mainView is a property on our Controller, so if in the meantime
			# you opened and closed LoadingView, still you will not close
			# _mainView controller automatically 
			return if @_mainView
			
			@_mainView = view

			# destroy controller when view gets destroyed
			@listenTo view, "destroy", @destroy 

		_manageView: (view, options) ->
			if options.loading
				App.mainBus.command "show:loading", view, options 
			else
				# we could use @region.show view instead
				options.region.show view
			 
