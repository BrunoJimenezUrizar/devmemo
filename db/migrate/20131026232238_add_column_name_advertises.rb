class AddColumnNameAdvertises < ActiveRecord::Migration
  def change
  	add_column :advertises, :name, :string
  end
end
