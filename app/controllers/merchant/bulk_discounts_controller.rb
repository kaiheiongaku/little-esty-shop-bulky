class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.create(discount_params)
    if @discount.id
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
    else
      flash[:notice] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:merchant_id, :quantity_threshold, :percentage_off)
  end
end
