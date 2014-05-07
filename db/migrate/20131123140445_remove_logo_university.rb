class RemoveLogoUniversity < ActiveRecord::Migration
  def up
  	remove_column :universities, :logo
  end

  def down
  	add_column :universities, :logo, :string
  end
end
