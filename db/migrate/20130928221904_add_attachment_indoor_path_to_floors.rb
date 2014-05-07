class AddAttachmentIndoorPathToFloors < ActiveRecord::Migration
  def self.up
    change_table :floors do |t|
      t.attachment :indoor_path
    end
  end

  def self.down
    drop_attached_file :floors, :indoor_path
  end
end
