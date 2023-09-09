class HomeController < ApplicationController
  def index
    @posts = Post.all
    @user = User.all
  end
end
