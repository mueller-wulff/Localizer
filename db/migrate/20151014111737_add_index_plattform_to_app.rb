class AddIndexPlattformToApp < ActiveRecord::Migration
  def change
    add_column :apps, :plattform, :string
    add_column :apps, :title, :string
  end
end
