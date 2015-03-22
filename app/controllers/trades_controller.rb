class TradesController < ActionController::Base
	respond_to :json

	def new
		respond_with Trade.new
	end

	def index
		# returns collection of Orders for current_user
		respond_with Trade.all
	end

	def show
		respond_with Trade.find params[:id]
	end

	def update
		respond_with( Trade.find params[:id], trade_params )
	end

	def create
		respond_with( Trade.create trade_params )
	end

	def destroy
		respond_with( Trade.destroy params[:id] )
	end

	private

		def trade_params
			params.permit(:price, :size, :user_id)
		end

end