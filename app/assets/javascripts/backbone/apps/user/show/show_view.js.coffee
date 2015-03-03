@Payrollsio.module "UserApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	class Show.UserLayout extends App.Views.LayoutView
		template: "user/show/user"

		regions:
			userActionsRegion: 	"#user-actions-region"
			userStatsRegion: 		"#user-stats-region"
			userMessageRegion:	"#message-region"

	class Show.Actions extends App.Views.ItemView
		template: "user/show/_user_actions"

	class Show.Stats extends App.Views.ItemView
		template: "user/show/_user_stats"

	class Show.Message extends App.Views.ItemView
		template: "user/show/_message"
		model: Show.MessageContent

	class Show.MessageModel extends Backbone.Model 
		name: ""
		message: ""
