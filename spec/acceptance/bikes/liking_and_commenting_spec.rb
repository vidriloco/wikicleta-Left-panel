#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Bike likes and details:" do
  
  before(:each) do
    @user = FactoryGirl.create(:pancho)
    @bike = FactoryGirl.create(:bike, :user => @user)
  end
  
  scenario "Can see the details of a bike" do
    visit bike_path(@bike)
    
    page.should have_content @bike.name
    page.should have_content @bike.description
  end
  
  describe "If I am NOT logged-in then" do
    scenario "I cannot write a comment for a bike" do
      visit bike_path(@bike)
      page.should have_content I18n.t('comments.views.index.login_required')
      click_on I18n.t('actions.register_or_login')
      page.current_path.should == new_user_session_path
    end
  end
  
  describe "If I am logged-in", :js => true do
    
    before(:each) do
      @other_bike = FactoryGirl.create(:alternate_bike)

      login_with(@user)
    end
  
    scenario "can write a comment" do
      visit bike_path(@other_bike)
      
      find(".actions").should_not be_visible
      
      fill_in 'comment_comment', :with => "Una bici muy divertida y ligera"
      find(".actions").should be_visible
      
      click_on I18n.t('comments.actions.cancel')
      find(".actions").should_not be_visible
      fill_in 'comment_comment', :with => "Una bici muy divertida y ligera"
      sleep 2
      find(".actions").should be_visible
      
      click_on I18n.t('comments.actions.comment')
      sleep 5
      page.should have_content "Una bici muy divertida y ligera"
    end
    
    scenario "can write and delete a comment" do
      visit bike_path(@other_bike)
      fill_in 'comment_comment', :with => "Una bici muy divertida y ligera"
      click_on I18n.t('comments.actions.comment')
      sleep 5
      comment_id = Comment.first.id
      page.should have_content "Una bici muy divertida y ligera"
      
      accept_confirmation_for do 
        within("#com-#{comment_id}") do
          click_on I18n.t('comments.actions.delete')
        end
      end
            
      page.should_not have_content "Una bici muy divertida y ligera"
    end
    
    describe "from the listing page" do
      
      before(:each) do
        visit bikes_path
      end
      
      scenario "can like and dislike a bike" do
        enable_bike(@bike)
        within("##{@other_bike.id}") do
          page.should have_content "#{0}#{I18n.t('bikes.views.show.likes.some')}"
        end
        disable_bike(@bike)
      end
      
      scenario "can go to the comments page of a bike" do   
        within("##{@bike.id}") do
          click_on I18n.t('bikes.views.show.comments.some')
        end

        page.current_path.should == bike_path(@bike)
        page.current_url.split("#")[1].should == "comments"
      end
    end

    scenario "can like and dislike a bike from it's details page" do
      visit bike_path(@other_bike)
      enable_bike(@other_bike)
      disable_bike(@other_bike)
    end
    
  end
  
end

def enable_bike(bike)
  within("##{bike.id}") do
    page.should have_content "#{0}#{I18n.t('bikes.views.show.likes.some')}"
    find('.heart').click()
    sleep 5
    page.should have_content "#{1}#{I18n.t('bikes.views.show.likes.one')}"
  end
end

def disable_bike(bike)
  within("##{bike.id}") do
    page.should have_content "#{1}#{I18n.t('bikes.views.show.likes.one')}"
    find('.heart').click()
    page.should have_content "#{0}#{I18n.t('bikes.views.show.likes.some')}"
    
  end
end