@Payrollsio.module "MarketApp.New", (New, App, Backbone, Marionette, $, _) ->
	
	class New.Controller extends App.Controllers.Application

		initialize: (args) ->

			{ model } = args

			new_order = App.entitiesBus.request "new:order:entity"

			if model 
				new_order.set('price', model.get('price'))
				new_order.set('size_left', model.get('size_left'))
				new_order.set('side', model.get('side'))
			
			new_order.set "user_id", String(App.currentUser.id)

			newView = @getNewView new_order

			@listenTo newView, "form:cancel", =>
				@region.reset() 

			@listenTo new_order, "created", ->
				formView.remove()
				# collection.add new_order
				App.mainBus.trigger "new:order:added", new_order

			App.mainBus.on "clear:new:order:messages", ->
				$('#new-form-message').text('')

			App.mainBus.on "new:order:message", (msg) ->
				$('#new-form-message').text(msg)

			formView = App.mainBus.request "form:wrapper", newView
			@show formView  

		getNewView: (new_order) ->
			new New.OrderView
				model: new_order


			
