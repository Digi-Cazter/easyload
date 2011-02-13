# -*- encoding: utf-8 -*-
require 'easyload'

module NamingExamples
  Easyload
end

describe 'Easyload file names' do
  it 'should use a single lowercase name for a single word constant' do
    Examples.easyload_path_component_for_sym(:Single).should == 'single'
    Examples.easyload_path_component_for_sym(:A).should == 'a'
  end
  
  it 'should break CamelCase constants into lowercase words separated by underscores' do
    Examples.easyload_path_component_for_sym(:TwoWords).should == 'two_words'
    Examples.easyload_path_component_for_sym(:OneTwoThreeFour).should == 'one_two_three_four'
  end
  
  it 'should treat strings of adjacent capital letters as acronyms' do
    Examples.easyload_path_component_for_sym(:ABC).should == 'abc'
    Examples.easyload_path_component_for_sym(:WTFWord).should == 'wtf_word'
  end
end