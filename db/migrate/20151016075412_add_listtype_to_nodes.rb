class AddListtypeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :listtype, :string
  end
end
