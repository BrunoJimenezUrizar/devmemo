class AddAcronymToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :acronym, :string
  end
end
