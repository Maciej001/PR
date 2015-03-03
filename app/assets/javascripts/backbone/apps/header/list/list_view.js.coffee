@Payrollsio.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Nav extends App.Views.ItemView 
		tagName:	"li"

		getTemplate: ->
			"header/list/_nav"

	class List.Header extends App.Views.CompositeView	
		template: 					"header/list/header"
		childView:					List.Nav
		childViewContainer:	"#nav-links"

		triggers: 
			"click #login": 	"login:button:clicked"
			"click #logout": 	"logout:button:clicked"
			"click #signup": 	"signup:button:clicked"