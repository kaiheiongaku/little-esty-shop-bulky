class Merchant::BulkDiscountsController < ApplicationController
  #do the before thing
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else
      flash[:notice] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def discount_params
    params.permit(:merchant_id, :quantity_threshold, :percentage_off)
  end
end
