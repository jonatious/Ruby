class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :address
      t.integer :zipcode
      t.string :country
      t.string :contact_no
      t.string :email

      t.timestamps null: false
    end
  end
end
