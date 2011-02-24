# -*- encoding: utf-8 -*-
require 'easyload'

module RelativeConstants
  include Easyload
end

describe 'Easyloaded modules with relatively referenced constants' do
  it 'should be able to reference relative constants via $parent' do
    RelativeConstants::Foo::REFERS_TO.should == RelativeConstants::Bar
  end
end