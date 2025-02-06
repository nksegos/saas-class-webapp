class CategoriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.posts.order(created_at: :desc)
  end
end
