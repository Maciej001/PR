class OrdersController < ActionController::Base
	respond_to :json

	def index
		@orders = Orders.all
	end

	def show
		@order = Orders.find params[:id]
	end

	def update
		@order = Order.find params[:id]

		if @order.update order_params

		else
			respond_with @order
		end
	end

	def create
		@order = Order.new new_order_params

		if @order.save

		else
			respond_with @order
		end
	end

	def destroy
		order = Order.find params[:id]
		order.destroy
		render json: {}
	end


	private

		def new_order_params
			params.permit(:price, :size, :side)
		end

		def order_params
			params.require(:order).permit(:price, :size, :side, :state)
		end

end