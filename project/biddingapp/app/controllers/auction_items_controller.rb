class AuctionItemsController < ApplicationController
  
  def new
    @auction_item = AuctionItem.new
  end
  
  def create
    @auction_item = AuctionItem.new(auction_item_params)
    @auction_item.sold_y_n = 'No'
    @customer = get_user
    if @auction_item.valid?
      @customer.auction_items << @auction_item
      @customer.save
      flash.now[:notice] = 'Successfully created item'
      @auction_item = AuctionItem.new
    end
    render :new
  end
  
  def edit
    @auction_item = get_item
  end
  
  def update
    @updates = auction_item_params
    
    @auction_item = AuctionItem.find(session[:item_id])
    if @auction_item.bidder_id && @updates[:highest_bid].to_f > @auction_item.highest_bid
      @auction_item.bidder_id = nil
      @auction_item.save
    end
    
    if @auction_item.bidder_id && @updates[:highest_bid].to_f < @auction_item.highest_bid
      @auction_item.errors.add('Bid','should be greater than the current bid')
      render :edit
    elsif @auction_item.update(@updates)
      flash.now[:notice] = 'Successfully Updated Item'
      @items = get_user.auction_items
      render '/customers/display_items'
    else
      render :edit
    end
  end
  
  def delete
    @auction_item = get_item
    @auction_item.bids.destroy_all
    @auction_item.destroy
    @items = get_user.auction_items
    flash.now[:notice] = 'Successfully Deleted Item'
    render '/customers/display_items'
  end
  
  def confirm_delete
    session[:item_id] = params[:id]
  end
  
  def view
    @customer = get_user
    @auction_item = get_item
    if @auction_item.bidder_id
      @bidder = Customer.find(@auction_item.bidder_id)
    end
  end
  
  def update_bid
    @customer = get_user
    @auction_item = get_item
    
    if(@auction_item.highest_bid < params['bid'].to_f)
      @auction_item.highest_bid = params['bid']
      @auction_item.bidder_id = @customer.id
      if @auction_item.save
        @old_bid = Bid.where("customer_id=? AND auction_item_id=?", @customer.id, @auction_item.id).first
        
        if @old_bid != nil
          @old_bid.amount = params['bid']
          @old_bid.save
        else
          @bid = Bid.new(:amount => params['bid'], :customer_id => @customer.id, :auction_item_id => @auction_item.id)
          @bid.save
        end
        flash[:notice] = 'Bid Successfully Placed!'
      end
    else
      @auction_item.errors.add('Bid','should be greater than the current bid')
    end
    render :view
  end
  
  private
  
  def auction_item_params
    params.require(:auction_item).permit(:name, :description, :highest_bid, :auction_days)
  end
  
  def get_user
    Customer.find_by_username(session[:username])
  end
  
  def get_item
    if params[:id] != nil
      session[:item_id] = params[:id]
      AuctionItem.find(params[:id])
    else
      AuctionItem.find(session[:item_id])
    end
  end
  
end
