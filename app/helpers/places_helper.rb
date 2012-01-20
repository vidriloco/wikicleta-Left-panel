module PlacesHelper
  def categories_for_select
    Category.all.inject({}) do |hash, f| 
      hash[I18n.t("categories.all.#{f.standard_name}").to_sym] = f.id
      hash
    end
  end
end