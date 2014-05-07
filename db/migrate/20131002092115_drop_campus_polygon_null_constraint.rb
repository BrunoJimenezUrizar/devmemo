class DropCampusPolygonNullConstraint < ActiveRecord::Migration
  def up
	connection.execute("ALTER TABLE campuses ALTER COLUMN polygon DROP NOT NULL;")
  end

  def down
	connection.execute("ALTER TALBE campuses ALTER COLUMN polygon SET NOT NULL;")
  end
end
