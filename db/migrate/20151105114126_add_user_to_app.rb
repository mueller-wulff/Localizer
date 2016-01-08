class AddUserToApp < ActiveRecord::Migration
  def change
    add_column :apps, :user_id, :integer, index:true
    add_column :users, :app, :integer, index:true
  end
end
