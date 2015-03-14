@Payrollsio.module "MarketApp", (MarketApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API = 
		show: ->
			new MarketApp.Show.Controller

		newOrder: (region, collection) -> 
			new MarketApp.New.Controller
				region: region
				collection: collection

	MarketApp.on "start", ->
		API.show()

	App.mainBus.on "new:order:form", (region, orders_collection) ->
		API.newOrder region, orders_collection




