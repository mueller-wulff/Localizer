class CreateLanguage < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :title
      t.boolean :in_work

      t.belongs_to :app, index: true
    end
  end
end
