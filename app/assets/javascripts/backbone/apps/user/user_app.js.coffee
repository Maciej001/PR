@Payrollsio.module "UserApp", (UserApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API = 
		show: ->
			new UserApp.Show.Controller
				region: App.userRegion

		signup: ->
			@signupController = new UserApp.Signup.Controller 
				region: App.formRegion

		signin: ->
			@signinController = new UserApp.Signin.Controller
				region: App.formRegion

		logout: ->
			console.log App.userSession
			App.userSession.destroy
				url: Routes.destroy_user_session_path()
			  success: (model, response, options) -> 
			    if response.csrfToken 
			      console.log response


		closeForm: (options={}) ->
			{ controller, region } = options
			region.reset() if region
			controller.destroy() 


	UserApp.on "start", ->
		API.show()

	App.mainBus.on "user:signup", ->
		API.signup()

	App.mainBus.on "user:signin", ->
		API.signin()

	App.mainBus.on "user:logout", ->
		API.logout()

	App.mainBus.on "close:form", (region, controller) ->
		API.closeForm region
		