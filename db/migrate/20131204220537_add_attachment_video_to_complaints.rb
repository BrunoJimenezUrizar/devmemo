class AddAttachmentVideoToComplaints < ActiveRecord::Migration
  def self.up
    change_table :complaints do |t|
      t.attachment :video
    end
  end

  def self.down
    drop_attached_file :complaints, :video
  end
end
