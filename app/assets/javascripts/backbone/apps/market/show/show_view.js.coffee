@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.LayoutView extends App.Views.LayoutView
		template: "market/show/show_layout"

		regions: 
			bidsRegion:		 		"#bids-region"
			offersRegion: 		"#offers-region"
			newOrderRegion:		"#new-order-region"
			chartRegion: 			"#chart-region"
			sessionRegion: 		"#session-region"
			listOrdersRegion:	"#list-orders-region"
			listTradesRegion: "#list-trades-region"

	class Show.Price extends App.Views.ItemView
		template: "market/show/_price"
		tagName:	"li"

		modelEvents: 
			"change": 	"render"

	class Show.EmptyPriceView extends App.Views.ItemView
		template: "market/show/_empty_price"

	class Show.Bids extends App.Views.CompositeView
		template: 					"market/show/_bids" 
		childView: 					Show.Price
		childViewContainer:	"ul"
		emptyView:						Show.EmptyPriceView

	class Show.Offers extends App.Views.CompositeView
		template: "market/show/_offers" 
		childView: 					Show.Price
		childViewContainer:	"ul"
		emptyView:						Show.EmptyPriceView

	class Show.Chart extends App.Views.ItemView
		template: "market/show/_chart"

	class Show.Session extends App.Views.ItemView
		template: "market/show/_session"

	class Show.EmptyOrdersView extends App.Views.ItemView
		template:		"market/show/_orders_empty"

	class Show.ListOrderItem extends App.Views.ItemView
		template: 	"market/show/_order_item"
		tagName: 		"tr"

		ui:				
			"delete":			".delete-button"

		triggers: 
			"click @ui.delete":			"delete:order:clicked"

	class Show.ListOrdersView extends App.Views.CompositeView
		template:							"market/show/_list_orders"
		childView:						Show.ListOrderItem
		childViewContainer: 	"tbody"
		emptyView:						Show.EmptyOrdersView

		triggers: 
			"click #new-order":	"new:order:clicked"

	class Show.ListTradeItem extends App.Views.ItemView
		template:		"market/show/_trade_item"
		tagName:		"tr"
		
	class Show.EmptyTradesView extends App.Views.ItemView
		template:		"market/show/_trades_empty"
		
	class Show.ListTradesView extends App.Views.CompositeView
		template: 						"market/show/_list_trades"
		childView:						Show.ListTradeItem
		childViewContainer:		'tbody'
		emptyView:						Show.EmptyTradesView






