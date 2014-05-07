require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
 
#### UT_019W ##############################################
test "building_create" do
    assert Building.create, "UT_19: building should be created"
end
##########################################################

#### UT_020W ##############################################
test "building_nil" do
    building=Building.new
    assert !building.save, "UT_20W: building nil created!"
end
##########################################################

#### UT_021W ##############################################
test "building_not_same_name" do
    building_one=buildings(:one)
    building_two=Building.new
    building_two.campus_id=building_one.campus_id
    building_two.name=building_one.name
    assert !building_two.save, "UT_21W: building with same name created!"
end
##########################################################

#### UT_022W ##############################################
test "building_delete_on_cascade" do 
  	building=buildings(:one)
  	b_id=building.id 
  	c_id=building.campus_id 
  	Campus.find(c_id).destroy
  	assert_nil Building.find_by_id(b_id), "UT_22W: A building should be destroyed when its campus did"  	
end
##########################################################

#### UT_023W ##############################################
  test "building_update" do
    building=buildings(:one)
    building.name="nombre_nuevo"
    assert_equal("nombre_nuevo",building.name ,"UT_23W: building name should be updated")
  
  end
##########################################################

#### UT_024W ##############################################
  test "building_destroy" do
    building=advertises(:one)
    building.destroy
    assert !Building.find_by_id(1), "UT_24W: building should be destroyed"
  end
##########################################################
end 