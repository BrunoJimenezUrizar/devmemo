class AddAttachmentPhotoToComplaints < ActiveRecord::Migration
  def self.up
    change_table :complaints do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :complaints, :photo
  end
end
