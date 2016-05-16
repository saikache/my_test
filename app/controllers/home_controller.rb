class HomeController < ApplicationController
    require 'open-uri'
  def index

    @stories = JSON.load(open("http://sketches.quintype.com/api/v1/stories"))

    @side_linkes_json = JSON.load(open("http://sketches.quintype.com/api/v1/config"))

    @side_linkes = @side_linkes_json['layout']['menu']#.collect{|s| [s['title'],s['section-slug']]}

  end


  def get_related_stories

   @stories = JSON.load(open("http://sketches.quintype.com/api/v1/stories?section=Pathankot Attack"))


  end


def hi
    @a = 'sai'


respond_to do |format|
  format.js # actually means: if the client ask for js -> return file.js
end

    
end

end
