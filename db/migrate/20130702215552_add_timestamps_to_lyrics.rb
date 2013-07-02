class AddTimestampsToLyrics < ActiveRecord::Migration
  def change
    add_column :lyrics, :updated_at, :datetime
    add_column :lyrics, :created_at, :datetime
    Lyric.find_each do |l|
      now = Time.now
      l.updated_at = now
      l.created_at = now
      l.save
    end
  end
end
