# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "Enabling Features" do
   scenario '2 features enabled at once' do
     visit '/tests/two'
     page.should have_selector('div.one', :count => 1)
     page.should have_selector('div.two', :count => 1)
   end

   scenario '3 features enabled seprately' do
     visit '/tests/three'
     page.should have_selector('div.one', :count => 1)
     page.should have_selector('div.two', :count => 1)
     page.should have_selector('div.three', :count => 1)
   end

   scenario '2 features enbled on partials' do
     visit '/tests/partials'
     page.should have_selector('div.one', :count => 1)
     page.should have_selector('div.two', :count => 1)
   end
end
