@Payrollsio.module "MarketApp", (MarketApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API = 
		show: ->
			new MarketApp.Show.Controller

		newOrder: (region, model) -> 
			new MarketApp.New.Controller
				region: region
				model: model

	MarketApp.on "start", ->
		API.show()

		# Id is used in eco templates to indicate eg. my own bid
		Window.currentUser = App.currentUser.id

	App.mainBus.on "new:order:form", (region, model) ->
		API.newOrder region, model




