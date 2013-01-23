# -*- encoding : utf-8 -*-
class XhrController < ApplicationController
  layout false
  def index
    response.headers['X-JavascriptFeatures-Init'] = 'load'
  end
end
