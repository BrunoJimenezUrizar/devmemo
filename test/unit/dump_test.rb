require 'test_helper'

class DumpTest < ActiveSupport::TestCase

#### UT_032W ##############################################
  test "dump_create" do
    assert Dump.create, "UT_032W: dump should be created"
  end
##########################################################

#### UT_033W ##############################################
  test "dump_nil" do
    dump=Dump.new
    assert !dump.save, "UT_033W: dump nil created!"
  end
##########################################################

#### UT_034W ##############################################
  test "dump_with_por_nil" do
    dump=dumps(:one)
    dump.por_id=nil
    assert !dump.save, "UT_034W: dump with por nil created!"
  end
##########################################################

#### UT_035W ##############################################
  test "dump_destroy" do
    dump=dumps(:one)
    dump.destroy
    assert !Dump.find_by_id(1), "UT_035W: dump should be destroyed"
  end
##########################################################

#### UT_036W ##############################################
  test "dump_delete_on_cascade" do 
    dump=dumps(:one)
    d_id=dump.id 
    p_id=dump.por_id 
    Por.find(p_id).destroy
    assert_nil Dump.find_by_id(d_id), "UT_036W: A dump should be destroyed when its PoR did"   
  end
##########################################################

#### UT_037W ##############################################
  test "dump_update" do
    dump=dumps(:one)
    dump.description="nombre_nuevo"
    assert_equal("nombre_nuevo",dump.description ,"UT_037W: dump name should be updated")
  end
##########################################################
  
end
