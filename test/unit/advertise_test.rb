require 'test_helper'

class AdvertiseTest < ActiveSupport::TestCase

#### UT_007W ##############################################
test "advertise_create" do
    assert Advertise.create, "UT_007: advertise should be created"
end
##########################################################

#### UT_008W ##############################################
test "advertise_nil" do
    advertise=Advertise.new
    assert !advertise.save, "UT_008: advertise nil created!"
end
##########################################################

#### UT_009W ##############################################
test "advertise_start_after_end_date" do
  	advertise=advertises(:one)
  	advertise.start_date="2013-11-05 22:00:00"
  	advertise.end_date="2013-11-01 22:00:00"
  	assert !advertise.save, "UT_009: Shouldn't exists ana  advertise with start date afterward the end date "
end
##########################################################

#### UT_010W ##############################################
test "advertise_update" do
    advertise=advertises(:one)
    advertise.name="nombre_nuevo"
    assert_equal("nombre_nuevo",advertise.name ,"UT_10: advertise name should be updated")
end
##########################################################

#### UT_011W ##############################################
test "advertise_destroy" do
    advertise=advertises(:one)
    advertise.destroy
    assert !Advertise.find_by_id(1), "UT_11: advertise should be destroyed"
end
######################################################################

end