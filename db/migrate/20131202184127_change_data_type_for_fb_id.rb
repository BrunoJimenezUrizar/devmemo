class ChangeDataTypeForFbId < ActiveRecord::Migration
  def self.up
    change_table :mobile_users do |t|
      t.change :fb_id, :string
    end
  end
  def self.down
    change_table :mobile_users do |t|
      t.change :fb_id, :integer
    end
  end
end
