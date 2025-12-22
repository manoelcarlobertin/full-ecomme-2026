module Admin
  class CouponsController < AdminController
    before_action :set_coupon, only: %i[edit update destroy]

    def index
      @coupons = Coupon.order(created_at: :desc)
    end

    def new
      @coupon = Coupon.new
    end

    def create
      @coupon = Coupon.new(coupon_params)
      if @coupon.save
        redirect_to admin_coupons_path, notice: "Cupom criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @coupon.update(coupon_params)
        redirect_to admin_coupons_path, notice: "Cupom atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @coupon.destroy
      redirect_to admin_coupons_path, notice: "Cupom removido."
    end

    private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      params.require(:coupon).permit(:name, :code, :status, :discount_value, :max_use, :due_date)
    end
  end
end
