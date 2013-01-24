# -*- encoding : utf-8 -*-
class TestsController < ApplicationController
  def show
    if params[:id][0] == "_"
      render :partial => params[:id][1..-1]
    else
      render params[:id]
    end
  end
end
