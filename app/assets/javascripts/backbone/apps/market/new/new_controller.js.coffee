@Payrollsio.module "MarketApp.New", (New, App, Backbone, Marionette, $, _) ->
	
	class New.Controller extends App.Controllers.Application

		initialize: (args) ->
			{ region } = args
			
			new_order = App.entitiesBus.request "new:order:entity"

			new_order.set "user_id", String(App.currentUser.id)

			console.log "new order ", new_order

			newView = @getNewView new_order

			@listenTo newView, "form:cancel", =>
				@region.reset() 

			@listenTo new_order, "created", ->
				console.log "new order created"

			formView = App.mainBus.request "form:wrapper", newView
			@show formView  

		getNewView: (new_order) ->
			new New.OrderView
				model: new_order


			
