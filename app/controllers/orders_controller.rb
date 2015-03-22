class OrdersController < ActionController::Base
	respond_to :json

	def new
		respond_with Order.new
	end

	def index
		# returns collection of Orders for current_user
		respond_with Order.all
	end

	def show
		respond_with Order.find params[:id]
	end

	def update
		respond_with( Order.find params[:id], order_params )
	end

	def create
		respond_with( Order.create order_params )
	end

	def destroy
		respond_with( Order.destroy params[:id] )
	end

	private

		def order_params
			params.permit(:price, :size, :size_left, :side, :state, :user_id)
		end

end