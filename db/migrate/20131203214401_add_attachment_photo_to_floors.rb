class AddAttachmentPhotoToFloors < ActiveRecord::Migration
  def self.up
    change_table :floors do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :floors, :photo
  end
end
