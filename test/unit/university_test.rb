require 'test_helper'

class UniversityTest < ActiveSupport::TestCase

#### UT_001W ##############################################
test "university_create" do
    assert University.create, "UT_001W: university should be created"
end
###########################################################

#### UT_002W ##############################################
test "university_nil" do
    university=University.new
    assert !university.save, "UT_002W: university nil created!"
end
##########################################################

#### UT_003W ##############################################
test "university_not_same_name" do
    university_one=universities(:one)
    university_two=University.new
    university_two.name=university_one.name
    assert !university_two.save, "UT_003: university with same name created!"
end
##########################################################

#### UT_004W ##############################################
test "university_not_same_acronym" do
    university_one=universities(:one)
    university_two=University.new
    university_two.acronym=university_one.acronym
    assert !university_two.save, "UT_004: university with same acronym created!"
end
##########################################################

#### UT_005W ##############################################
test "university_update" do
    university=universities(:one)
    university.name="nombre_nuevo"
    assert_equal("nombre_nuevo",university.name ,"UT_005: university name should be updated")
end
##########################################################

#### UT_006W ##############################################
test "university_destroy" do
    university=universities(:one)
    university.destroy
    assert !University.find_by_id(1), "UT_006: university should be destroyed"
end
##########################################################

end
