module Places
  class CommitsController < ApplicationController
    
    before_filter :authenticate_user!
    
    def evaluate
      survey = Survey.from_hash(params[:survey].merge(:user_id => current_user.id))
      
      if survey.save
        respond_to do |format|
          format.js 
        end
      else
        render(:nothing => true)
      end
    end
    
  end
end