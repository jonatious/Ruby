class CreateSeedStatus < ActiveRecord::Migration
  def up
    WorkStatus.create(:status => 'Created')
    WorkStatus.create(:status => 'Assigned')
    WorkStatus.create(:status => 'Completed')
  end
  
  def down
    WorkStatus.all.destroy
  end
  
end
