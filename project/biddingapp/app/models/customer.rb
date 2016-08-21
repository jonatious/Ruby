class Customer < ActiveRecord::Base
  
  validates :username, :uniqueness => true, :length => {:in => 3..20}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness => true, format: { with: VALID_EMAIL_REGEX }

  validates :password, :confirmation => true
  validates_length_of :password, :in => 6..20
  
  validates_presence_of :username, :email, :first_name, :last_name

  before_save :encrypt_password
  after_save :clear_password
  
  has_many :auction_items
  has_many :bids

  def encrypt_password
    if password.present?
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
      self.password = crypt.encrypt_and_sign(password)
    end
  end

  def clear_password
    self.password = nil
  end
end
