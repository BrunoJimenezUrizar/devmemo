class CreateUserCampuses < ActiveRecord::Migration
   	def up
	    create_table :usercampuses do |t|
	        t.references :campus
	      	t.references :user
	    end
        add_index :usercampuses,:campus_id
        add_index :usercampuses,:user_id
  	end
  	def down
        drop_table :usercampuses
  	end
end
