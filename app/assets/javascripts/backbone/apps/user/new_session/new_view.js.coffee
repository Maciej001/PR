@Payrollsio.module "UserApp.Signin", (Signin, App, Backbone, Marionette, $, _) ->
	
	class Signin.User extends App.Views.ItemView 
		template: "user/new_session/signin" 

		form:
			footer: true
			buttons: 
				primary: 		"Sign in"
				cancel: 		"Cancel"
				placement: 	"left"