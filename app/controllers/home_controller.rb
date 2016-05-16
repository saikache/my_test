class HomeController < ApplicationController
  require 'open-uri'
  before_filter :get_side_bar

  def index
    @stories = JSON.load(open("http://sketches.quintype.com/api/v1/stories"))
  end

  def get_related_stories
    @a = JSON.load(open("http://sketches.quintype.com/api/v1/stories?section=Business"))
    respond_to do |format|
      format.js  { render json: @a }
      format.html
    end
  end

  private

  def get_side_bar
    @side_linkes_json = JSON.load(open("http://sketches.quintype.com/api/v1/config"))
    @side_linkes = @side_linkes_json['layout']['menu']#.collect{|s| [s['title'],s['section-slug']]}
  end

end
