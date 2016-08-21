class PopulateSeedData < ActiveRecord::Migration
  def up
    load "#{Rails.root}/db/seeds.rb"
  end
  def down
    WorkStatus.delete_all
  end
end
