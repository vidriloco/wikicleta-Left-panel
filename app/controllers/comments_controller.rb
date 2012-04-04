class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    @comment = Comment.new(params[:comment].merge(:user_id => current_user.id))
    @comment.save
    
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @comment = Comment.find_by_id_and_user_id(params[:id], current_user.id)
    @comment.destroy
    
    respond_to do |format|
      format.js
    end
  end
  
end