class AddAttachmentPhotoToRapidfireQuestionGroups < ActiveRecord::Migration
  def self.up
    change_table :rapidfire_question_groups do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :rapidfire_question_groups, :photo
  end
end
