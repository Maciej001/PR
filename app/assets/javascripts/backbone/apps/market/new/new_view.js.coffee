@Payrollsio.module "MarketApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.OrderView extends App.Views.ItemView
		template: "market/new/new_order_form"

		# add config for your form wrapper
		form: 
			buttons: 
				placement: 	"left"
				primary: 		"Place order"