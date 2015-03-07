@Payrollsio.module "MarketApp", (MarketApp, App, Backbone, Marionette, $, _) ->
	
	@startWithParent = false

	API = 
		show: ->
			new MarketApp.Show.Controller

		newOrder: (region) -> 
			console.log "DEBUG: callujemy z regionem", region
			new MarketApp.New.Controller
				region: region

	MarketApp.on "start", ->
		API.show()

	App.mainBus.on "new:order:form", (region) ->
		API.newOrder region


