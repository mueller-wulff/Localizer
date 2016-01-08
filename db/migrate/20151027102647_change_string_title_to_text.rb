class ChangeStringTitleToText < ActiveRecord::Migration
  def change
    change_column :nodes, :title, :text
  end
end
