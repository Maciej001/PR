@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.LayoutView extends App.Views.LayoutView
		template: "market/show/show_layout"

		regions: 
			ordersRegion:		 	"#orders-region"
			newOrderRegion:		"#new-order-region"
			chartRegion: 			"#chart-region"
			sessionRegion: 		"#session-region"
			listOrdersRegion:	"#list-orders-region"

	class Show.Orders extends App.Views.ItemView
		template: "market/show/_orders" 

		triggers: 
			"click #new-order": "new:order:clicked"

	class Show.Chart extends App.Views.ItemView
		template: "market/show/_chart"

	class Show.Session extends App.Views.ItemView
		template: "market/show/_session"

	# List Orders - Composite View

	class Show.ListOrderItem extends App.Views.ItemView
		template: 	"market/show/_order_item"
		tagName: 		"tr"

	class Show.ListOrdersView extends App.Views.CompositeView
		template:							"market/show/_list_orders"
		childView:						Show.ListOrderItem
		childViewContainer: 	"tbody"






