require 'test_helper'

class EventTest < ActiveSupport::TestCase

#### UT_025W ##############################################
  test "event_create" do
    assert Event.create, "UT_025W: event should be created"
  end
##########################################################

#### UT_026W ##############################################
  test "event_nil" do
    event=Event.new
    assert !event.save, "UT_026W: event nil created!"
  end
##########################################################

#### UT_027W ##############################################
  test "event_with_start_date_nil" do
    event=events(:one)
    event.start_date= nil
    assert !event.save, "UT_027W: sShouldn't exists an event with start date nil "
  end
##########################################################

#### UT_028W ##############################################
  test "event_with_end_date_nil" do
    event=events(:one)
    event.end_date= nil
    assert !event.save, "UT_028W: Shouldn't exists an event with end date nil "
  end
##########################################################

#### UT_029W ##############################################
  test "event_start_after_end_date" do
    event=events(:one)
    event.start_date="2013-11-05 22:00:00"
    event.end_date="2013-11-01 22:00:00"
    assert !event.save, "UT_029W: Shouldn't exists a event with start date afterward the end date "
  end
##########################################################

#### UT_030W ##############################################
  test "event_update" do
    event=events(:one)
    event.name="nombre_nuevo"
    assert_equal("nombre_nuevo",event.name ,"UT_030W: event name should be updated")
  end
##########################################################
 
#### UT_031W ##############################################
  test "event_destroy" do
    event=events(:one)
    event.destroy
    assert !Event.find_by_id(1), "UT_031W: event should be destroyed"
  end
########################################################## 

end