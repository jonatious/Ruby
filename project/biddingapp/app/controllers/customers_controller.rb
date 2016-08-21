class CustomersController < ApplicationController
  before_action :redirect_if_not_loggedin, :except => [:login, :new, :create, :validate_login]
  
  def login
    redirect_to profile_customers_path if session[:username] != nil
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)
    if(params[:customer][:password] != params[:customer][:confirm_password])
      @customer.errors.add('Passwords','do not match')
      render :new
    elsif @customer.save
      session[:username] = @customer.username
      redirect_to profile_customers_path, notice: 'Welcome to the Bidding Site'
    else
      render :new
    end
  end
  
  def edit
    @customer = get_user
  end
  
  def update
    @updates = customer_params
    
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    @updates[:password] = crypt.decrypt_and_verify(Customer.find_by_username(session[:username]).password)
    
    @customer = get_user
    if @customer.update(@updates)
      flash.now[:notice] = 'Successfully Updated'
      session[:username] = params[:customer][:username]
      render :profile
    else
      render :edit
    end
  end
  
  def profile
    @customer = get_user
  end
  
  def logout
    session.delete(:username)
    redirect_to login_customers_path, notice: 'Logged out Successfully!'
  end
  
  def update_password
    @customer = get_user
    
    if !validate_user(@customer,params[:current_password])
      flash.now[:alert] = 'Current Password is incorrect'
      render :change_password
    elsif (params[:new_password] != params[:confirm_password])
      flash.now[:alert] = 'Passwords do not match'
      render :change_password
    else
      @customer.password = params[:new_password]
      if @customer.save
        flash.now[:notice] = 'Password Changed Successfully'
        render :profile
      else
        flash.now[:alert] = @customer.errors.full_messages.first
        render :change_password
      end
    end
  end
  
  def display_items
    update_sold
    @items = get_user.auction_items
    
    flash.now[:alert] = 'No items found' if @items.count == 0
  end
  
  def display_bids
    update_sold
    @items = get_user.bids.map{|bid| bid.auction_item}
    @my_bids = Hash[get_user.bids.map{|bids| [bids.auction_item.name, bids.amount]}]
    
    flash.now[:alert] = 'No bids found' if @items.count == 0
  end
  
  def search
  end
  
  def search_items
    update_sold
    @items = AuctionItem.where("name like ? and description like ?", "%#{params['name']}%", "%#{params['desc']}%").where(:sold_y_n => 'No')
    
    flash.now[:alert] = 'No items found' if @items.count == 0
  end

  def validate_login
    user = Customer.where("lower(username = ?)",params['username'].downcase).first
    if user
      if validate_user(user,params['password'])
        session[:username] = user.username
        redirect_to profile_customers_path
      else
        redirect_to login_customers_path, alert: 'Password Incorrect'
      end
    else
      redirect_to login_customers_path, alert: 'User not found'
    end
  end
  
  private
  def validate_user(user, password)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    password == crypt.decrypt_and_verify(user.password)
  end
  
  def customer_params
    params.require(:customer).permit(:username, :password, :first_name, :last_name, :address, :zipcode,:city,:state, :country, :contact_no, :email)
  end
  
  def redirect_if_not_loggedin
    redirect_to login_customers_path if session[:username] == nil
  end
  
  def get_user
    Customer.find_by_username(session[:username])
  end
  
  def update_sold
    @items = AuctionItem.all
    @items.each do |item|
      if item.created_at + item.auction_days.days < Time.now.utc
        item.sold_y_n = 'Yes'
        item.save
      end
    end
  end
end

