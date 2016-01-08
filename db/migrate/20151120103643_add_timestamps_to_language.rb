class AddTimestampsToLanguage < ActiveRecord::Migration
  def change
    add_column(:languages, :created_at, :datetime)
    add_column(:languages, :updated_at, :datetime)
  end
end
