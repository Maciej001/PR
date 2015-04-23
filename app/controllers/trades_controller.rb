class TradesController < ActionController::Base
	respond_to :json

	def new
		respond_with Trade.new
	end

	def index
		logger.info "index params side: #{params[:side]}"
		logger.info "index params id: #{params[:id]}"
		if params[:side] == "buy"
			respond_with Trade.where side: 'buy'
		else 
			respond_with Trade.where user_id: current_user
		end
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
			params.permit(:price, :size, :side, :user_id)
		end

end