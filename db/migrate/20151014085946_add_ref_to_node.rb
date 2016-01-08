class AddRefToNode < ActiveRecord::Migration
  def change
    add_reference :nodes, :parent, index: true
  end
end
