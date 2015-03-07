@Payrollsio.module "MarketApp.New", (New, App, Backbone, Marionette, $, _) ->
	
	class New.Controller extends App.Controllers.Application

		initialize: (args) ->
			{ region } = args
			console.log "DEBUG: new controller args", region
			
			new_order = App.entitiesBus.request "new:order:entity"

			newView = @getNewView new_order
			formView = App.mainBus.request "form:wrapper", newView
			@show formView, region: region

		getNewView: (new_order) ->
			new New.OrderView
				model: new_order


			
