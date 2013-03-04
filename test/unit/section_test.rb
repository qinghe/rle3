require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "should update section" do
    @section = Section.find(2)
    section={"is_enabled"=>"1",  "slug"=>"root", }
    @section.attributes=section
    assert @section.save
    assert @section.update_attribute "root_id", @section[:id]
     # assert @section.update_attributes(section)          
  end
  
  test "should build menu content" do
    
    @section = Section.root
    #assert @section
Rails.logger.debug "content:#{@section.build_html}"     
    assert @section.build_html
  end
  
  test "should create a section named container" do
    spp = SectionPieceParam.find(:all, :conditions=>["section_piece_id=?",2])
    root = Section.create_section(2, :slug=>"container")
    assert root
    assert root.section_params.size == spp.size
  end
  
end
