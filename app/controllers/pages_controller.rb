class PagesController < ApplicationController

  before_action :authenticate_user!

  def index
    @posts = Post.last(5)
  end

end
