@Payrollsio.module "UserApp.Signin", (Signin, App, Backbone, Marionette, $, _) ->
	
	class Signin.Controller extends App.Controllers.Application

		initialize: (options) ->
			App.addBlackOverlay()
			
			{ @region } = options

			# user becomes UserSession
			user = App.entitiesBus.request "new:user:signin:entity"

			@signinView = @getSigninView user

			@listenTo @signinView, "form:cancel", ->
				App.mainBus.trigger "close:form", 
					region: @region
					controller: @

			@listenTo @signinView.model, "created",  (model, response) ->
				@signinComplete model, response

			@formView = App.mainBus.request "form:wrapper", @signinView

			@show @formView, region: @region

		onBeforeDestroy: ->
			App.removeBlackOverlay()
			@formView.destroy()

		getSigninView: (user) ->
			new Signin.User
				model: user

		signinComplete: (model, response) ->
			App.entitiesBus.trigger "create:current:user", model, response

			App.mainBus.trigger "user:authenticated"

			App.mainBus.trigger "show:message", "welcome back!"

			$(@formView.el).fadeOut 200, =>
				App.mainBus.trigger "close:form", 
					controller: @



