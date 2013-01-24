# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "Javascript Features" do
  background do
    visit '/tests'
  end
  scenario 'initialise the enabled features' do
    page.should have_selector('div.enabled_feature', :count => 1)
  end

  scenario 'do not initialise the enabled features' do
    page.should_not have_selector('div.disabled_feature')
  end

  scenario 'initialise the global feature' do
    page.should have_selector('div.global_feature', :count => 1)
  end
end
