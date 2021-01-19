class Merchant::BulkDiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_discount, only: [:show, :edit, :update]

  def index
  end

  def new
  end

  def show
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def create
    @discount = BulkDiscount.create(discount_params)
    if @discount.id
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
    else
      flash[:notice] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
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

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_discount
    @discount = BulkDiscount.find(params[:id])
  end
end
