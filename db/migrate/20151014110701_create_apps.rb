class CreateApps < ActiveRecord::Migration
  def change

    create_table :apps do |t|
      t.timestamps null: false
    end

    add_reference :nodes, :app, index: true, foreign_key: true

  end
end
