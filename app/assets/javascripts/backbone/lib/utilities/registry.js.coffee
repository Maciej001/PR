@Payrollsio.module "Utilities", (Utilities, App, Backbone, Marionette, $, _) ->

	API = 
		register: (instance, id) ->
			@_registry ?= {}
			@_registry[id] = instance

			Window.r = @_registry

		unregister: (instance, id) ->
			delete @_registry[id]

		resetRegistry: ->
			oldCount = @getRegistrySize()
			for key, controller of @_registry
				controller.region.reset()

			msg = "There were #{oldCount} controllers in the registry, there are now #{@getRegistrySize()}"
			if @getRegistrySize() > 0 then console.log(msg, @_registry) else console.log msg		

		getRegistrySize: ->
			_.size @_registry	

	App.mainBus.comply "register:instance", (instance, id) =>
		API.register instance, id 

	App.mainBus.comply "unregister:instance", (instance, id) ->
		API.unregister instance, id 

	App.mainBus.reply "reset:registry", ->
		API.resetRegistry()
