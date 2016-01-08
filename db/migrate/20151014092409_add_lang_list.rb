class AddLangList < ActiveRecord::Migration
  def change
    add_column :nodes, :lang, :string
    add_column :nodes, :list, :boolean, :default => false
  end
end
