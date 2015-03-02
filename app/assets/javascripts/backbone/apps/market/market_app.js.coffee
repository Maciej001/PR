@Payrollsio.module "MarketApp", (MarketApp, App, Backbone, Marionette, $, _) ->
	
	@startWithParent = false

	API = 
		show: ->
			new MarketApp.Show.Controller

	MarketApp.on "start", ->
		API.show()

