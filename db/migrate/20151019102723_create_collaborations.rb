class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|

      t.string 'lang'
      t.belongs_to :app, index: true

      t.timestamps null: false
    end
  end
end
