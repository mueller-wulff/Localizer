class AddBaseLangToColl < ActiveRecord::Migration
  def change
    add_column :collaborations, :baselang, :string
  end
end
