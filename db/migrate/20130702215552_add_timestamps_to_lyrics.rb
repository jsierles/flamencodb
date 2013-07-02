class AddTimestampsToLyrics < ActiveRecord::Migration
  def change
    add_column :lyrics, :updated_at, :datetime
    add_column :lyrics, :created_at, :datetime
  end
end
