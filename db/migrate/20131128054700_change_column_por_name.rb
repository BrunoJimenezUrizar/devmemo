class ChangeColumnPorName < ActiveRecord::Migration
  def up
  	rename_column :pors, :description, :name 
  end

  def down
  	rename_column :pors, :name, :description
  end
end
