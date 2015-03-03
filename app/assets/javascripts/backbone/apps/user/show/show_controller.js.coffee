@Payrollsio.module "UserApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application

		initialize: (options) ->
			@userLayoutView = @getUserLayoutView() 

			@listenTo @userLayoutView, "show", =>
				@userActionsRegion()
				@userStatsRegion()

			@show @userLayoutView

			App.mainBus.on "show:message", (message) =>
				@showMessage message

		getCurrentUserName: ->
			console.log App.currentUser
			name = App.nameFromEmail App.currentUser.get('email')
			capitalizedName = name.capitalizeWord()

		getUserLayoutView: ->
			new Show.UserLayout

		userActionsRegion: ->
			actionsView = @getActionsView()
			@show actionsView, region: @userLayoutView.userActionsRegion

		userStatsRegion: ->
			statsView = @getStatsView()
			@show statsView, region: @userLayoutView.userStatsRegion

		showMessage: (message) ->
			messageModel = new Show.MessageModel
				name: 		@getCurrentUserName()
				message: 	message

			messageView = @getMessageView 
				model: messageModel

			region = @userLayoutView.userMessageRegion

			@show messageView, region: region

			# After 10 seconds Message slides up and disappears
			messageView.$el
				.delay(7000)
				.slideUp(300)
				.queue ->
					region.reset()
			false

		getActionsView: ->
			new Show.Actions 

		getStatsView: ->
			new Show.Stats

		getMessageView: (model) ->
			new Show.Message model: model.model

		


	


