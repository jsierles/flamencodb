class SearchController < ApplicationController
  
  def search
    @results = Kaminari.paginate_array(PgSearch.multisearch(params[:q]).to_a).page(params[:page] || 1)
  end

end
