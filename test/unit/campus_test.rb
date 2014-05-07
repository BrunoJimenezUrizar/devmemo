require 'test_helper'

class CampusTest < ActiveSupport::TestCase
 
#### UT_012W ##############################################
test "campus_create" do
    assert Campus.create, "UT_12: Campus should be created"
end
##########################################################

#### UT_013W ##############################################
test "campus_nil" do
    campus=Campus.new
    assert !campus.save, "UT_13: Campus nil created!"
end
##########################################################

#### UT_014W ##############################################
test "campus_with_university_nil" do
    campus=campuses(:one)
    campus.university=nil
    assert !campus.save, "UT_14: Campus with university nil created!"
end
##########################################################

#### UT_015W ##############################################
test "campus_not_same_name" do
    campus_one=campuses(:one)
    campus_two=Campus.new
    campus_two.university_id=campus_one.university_id
    campus_two.name=campus_one.name
    assert !campus_two.save, "UT_015: campus with same name created!"
end
##########################################################

#### UT_016W ##############################################
test "campus_update" do
    campus=campuses(:one)
    campus.name="nombre_nuevo"
    assert_equal("nombre_nuevo",campus.name ,"UT_16: Campus name should be updated")
end
##########################################################

#### UT_017W ##############################################
test "campus_destroy" do
    campus=campuses(:one)
    campus.destroy
    assert !Campus.find_by_id(1), "UT_17: Campus should be destroyed"
end
##########################################################

#### UT_018W ##############################################
test "campus_delete_on_cascade" do 
    campus=campuses(:one)
    c_id=campus.id 
    u_id=campus.university_id 
    University.find(u_id).destroy
    assert_nil Campus.find_by_id(c_id), "UT_18: A campus should be destroyed when its university did"   
end
##########################################################

  


  

  

  

  


end