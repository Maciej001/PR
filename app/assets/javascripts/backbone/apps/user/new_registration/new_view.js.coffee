@Payrollsio.module "UserApp.Signup", (Signup, App, Backbone, Marionette, $, _) ->
	
	class Signup.User extends App.Views.ItemView 
		template: "user/new_registration/signup"

		form:
			footer: true
			buttons: 
				primary: 		"Sign up"
				cancel: 		"Cancel"
				placement: 	"left"
		


		
 