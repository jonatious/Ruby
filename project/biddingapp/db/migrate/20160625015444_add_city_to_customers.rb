class AddCityToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :city, :string
    add_column :customers, :state, :string
  end
end
