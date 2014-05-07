require 'test_helper'

class RecycleInfoTest < ActiveSupport::TestCase

#### UT_038W ##############################################
  test "recycleinfo_nil" do
    recycleinfo=RecycleInfo.new
    assert !recycleinfo.save, "UT_038W: recycleinfo nil created!"
  end
##########################################################

#### UT_039W ##############################################
  test "recycleinfo_with_dump_nil" do
    recycleinfo=recycle_infos(:one)
    recycleinfo.dump_id=nil
    assert !recycleinfo.save, "UT_039W: recycleinfo with dump nil created!"
  end
##########################################################

#### UT_040W ##############################################
  test "recycleinfo_delete_on_cascade" do 
    recycleinfo=recycle_infos(:one)
    r_id=recycleinfo.id 
    d_id=recycleinfo.dump_id 
    Dump.find(d_id).destroy
    assert_nil RecycleInfo.find_by_id(r_id), "UT_040W: A RecycleInfo should be destroyed when its dump did"   
  end
##########################################################
  
end
