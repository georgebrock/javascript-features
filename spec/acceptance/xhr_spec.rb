# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "Javascript Features" do
  background do
    visit '/xhrtests'
  end

  scenario 'complete the XHR request' do
    page.should have_selector('.real.xhr-response', :count => 1)
  end

  scenario 'initialise the feature required by the XHR content' do
    page.evaluate_script('jQuery(".real.xhr-response").attr("class")').should match(/touched-by-load/)
  end

  scenario 'limit the scope of the feature required by the XHR content to the XHR content itself' do
    page.evaluate_script('jQuery(".unrelated.xhr-response").attr("class")').should_not match(/touched-by-load/)
  end

  scenario 're-run global initialisation code when the XHR completes, limited to the scope of the XHR content' do
    page.should have_selector('.real.xhr-response .touched-by-global-init', :count => 1)
    page.should have_selector('.unrelated.xhr-response .touched-by-global-init', :count => 1)
  end
end
