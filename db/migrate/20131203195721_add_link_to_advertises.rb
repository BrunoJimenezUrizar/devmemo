class AddLinkToAdvertises < ActiveRecord::Migration
  def change
    add_column :advertises, :link, :string
  end
end
