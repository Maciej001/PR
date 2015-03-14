@Payrollsio.module "MarketApp.New", (New, App, Backbone, Marionette, $, _) ->
	
	class New.Controller extends App.Controllers.Application

		initialize: (args) ->
			{ region, collection } = args
			
			new_order = App.entitiesBus.request "new:order:entity"
			new_order.set "user_id", String(App.currentUser.id)

			newView = @getNewView new_order

			@listenTo newView, "form:cancel", =>
				@region.reset() 

			@listenTo new_order, "created", ->
				collection.add new_order

			formView = App.mainBus.request "form:wrapper", newView
			@show formView  

		getNewView: (new_order) ->
			new New.OrderView
				model: new_order


			
