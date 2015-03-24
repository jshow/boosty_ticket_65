class PostsController < ApplicationController

  before_action :get_post, :only => [:show, :edit, :update]
  
  def new
    @post = Post.new
  end
  
  def show
  end
  
  def index
    @posts = Post.all
  end
  
  def edit 
  end
  
  private
  
  def get_post
    @Post = Post.find(params[:id])
  end
end
