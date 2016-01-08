class AddTitleToColl < ActiveRecord::Migration
  def change
    add_column :collaborations, :title, :string
  end
end
