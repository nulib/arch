class RenameSingleUseLinkAttributes < ActiveRecord::Migration[5.0]
  def change
    existing = SingleUseLink.column_names
    to_change = ['downloadKey', 'itemId']
    to_change.each do |col|
      col.downcase! if existing.include?(col.downcase)
      rename_column :single_use_links, col.to_sym, col.underscore.to_sym
    end
  end
end
