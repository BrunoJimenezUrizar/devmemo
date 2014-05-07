class AddNotNullConstraintToEventCoordinates < ActiveRecord::Migration
  def up
		connection.execute("ALTER TABLE events ALTER COLUMN coordinates SET NOT NULL;")
  end

  def down
		connection.execute("ALTER TALBE events ALTER COLUMN coordinates DROP NOT NULL;")
  end
end
