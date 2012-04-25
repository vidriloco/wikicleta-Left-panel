class FriendshipsController < ApplicationController
  
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = I18n.t('user_profiles.messages.friendships.added_and_pending', :friend => @friendship.friend.username)
    else
      flash[:error] = I18n.t('user_profiles.messages.friendships.unsuccessful_remove')
    end
    
    redirect_to friends_of_user_profile_path(current_user.username)
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.delete
    flash[:notice] = I18n.t('user_profiles.messages.friendships.removed', :friend => @friendship.friend.username, :user => @friendship.user.username)
    redirect_to friends_of_user_profile_path(current_user.username)
  end
  
  def confirm
  
  end
end
