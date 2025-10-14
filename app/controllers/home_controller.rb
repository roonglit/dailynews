class HomeController < ApplicationController
  def index
    @newspapers = Newspaper.all
  end
end
