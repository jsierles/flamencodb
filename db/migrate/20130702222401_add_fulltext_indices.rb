class AddFulltextIndices < ActiveRecord::Migration
  def change
    execute "
        create index on lyrics using gin(to_tsvector('spanish', body));
        create index on albums using gin(to_tsvector('spanish', title));
        create index on tracks using gin(to_tsvector('spanish', title));
        create index on artists using gin(to_tsvector('spanish', name));
    "
  end
end
