class AddBooleansForCompilationAndPrincipalArtist < ActiveRecord::Migration
  def change
    add_column :albums, :compilation, :boolean
    add_column :track_participations, :principal, :boolean
  end
end
