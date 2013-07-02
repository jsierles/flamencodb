class AddExternalReferenceIdToAllItems < ActiveRecord::Migration
  def change
    add_column :albums, :external_ref, :string
    add_column :artists, :external_ref, :string
    add_column :tracks, :external_ref, :string
    add_column :lyrics, :external_ref, :string
  end
end
