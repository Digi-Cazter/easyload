# -*- encoding: utf-8 -*-
require 'easyload'

$LOAD_PATH.unshift(File.dirname(__FILE__))

module Examples
  include Easyload
end

module Deep
  module Example
    include Easyload
  end
end

module SpecRoot
  class << self
    attr_accessor :load_count
  end
  self.load_count = 0
end

describe 'A basic easyload module' do
  it 'should default to the class/module name for the easyload root' do
    Examples.easyload_root.should == 'examples'
  end
  
  it 'should be able to load constants one level deep' do
    Examples::Node::ABOUT.should == 'A node?'
  end
  
  it 'should raise standard NameErrors for unknown constants' do
    expect {
      Examples::Missing
    }.to raise_error(NameError)
  end
  
  it 'should not load files twice' do
    SpecRoot.load_count.should == 0
    
    Examples::LoadCounter::ABOUT.should == 'load counter: 1'
    SpecRoot.load_count.should == 1
    
    Examples::LoadCounter::ABOUT.should == 'load counter: 1'
    SpecRoot.load_count.should == 1
  end
  
  it 'should be able to load nested modules' do
    Examples::Nested::Leaf::ABOUT.should == 'A leaf?'
  end
  
  it 'should be able to automatically guess a nested module name' do
    Deep::Example.easyload_root.should == 'deep/example'
    thing = Deep::Example::Thing.new
  end
end