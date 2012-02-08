#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Announcements in places HTML show:" do
  
  describe "Given I am reviewing a registered place" do
    
    before(:each) do
      @user = Factory(:user)
      attrs = Factory.attributes_for(:recent_place, :name => "Fondita de Doña Pina", :mobility_kindness_index => 9, :category => Factory(:restaurant), :twitter => "")
      @fondita = Place.new_with_owner(attrs, @user)
      @fondita.save
    end
    
    describe "with no announcements registered" do
      
      scenario "can see the announcements listing from here", :js => true do
        visit place_path(@fondita)
      
        within('#main-box') do
          show_announcements 0
          
          within('#tabbed-content') do
            page.should have_content I18n.t('places.subviews.show.announcements.empty')
          end
        end
      
      end
      
    end
    
    describe "having logged-in" do
      
      scenario "when posting an announcement it should show an error message if I leave the start and end dates unchanged"
      
    end 
    
    describe "having two announcements registered" do
      
      before(:each) do
        announcer = Factory(:pipo)
        @fondita.add_recommender(announcer, [:owner, :verified])
        @user.recommendations.first.update_attribute(:is_verified, true)
                
        @upcomming_announcement = @fondita.add_announcement(@user, Factory.attributes_for(:upcoming_announcement))
        @ongoing_announcement = @fondita.add_announcement(announcer, Factory.attributes_for(:ongoing_announcement))
        
        @fondita.save

      end
      
      it "should list them", :js => true do
        visit place_path(@fondita)
        
        within('#main-box') do
          show_announcements 2
          
          within('#tabbed-content') do
            within("#announcement-#{@upcomming_announcement.id}") do
              page.should have_content @upcomming_announcement.header
              page.should have_content @upcomming_announcement.message
        
              page.should have_content I18n.t('places.subviews.show.announcements.starts_in')
              page.should_not have_content I18n.t('places.subviews.show.announcements.actions.delete')
            end
        
            within("#announcement-#{@ongoing_announcement.id}") do
              page.should have_content @ongoing_announcement.header
              page.should have_content @ongoing_announcement.message
        
              page.should have_content I18n.t('places.subviews.show.announcements.finishes_in')
              page.should_not have_content I18n.t('places.subviews.show.announcements.actions.delete')
            end
          end
        end
      end
      
      describe "and having logged-in" do
      
        before(:each) do
          login_with(@user)
        end
      
        it "should let me delete the one I posted", :js => true do
          visit place_path(@fondita)

          within('#main-box') do
            show_announcements 2

            within('#tabbed-content') do
              within("#announcement-#{@upcomming_announcement.id}") do
                click_link I18n.t('places.subviews.show.announcements.actions.delete')
              end
            end
            
            page.driver.browser.switch_to.alert.accept
            sleep 4
            
            page.has_css?("#announcement-#{@upcomming_announcement.id}").should be_false

            within(".announcements") do
              page.should have_content I18n.t('places.views.show.announcements').singularize
              page.should have_content 1
            end
          end
        end
        
        it "should let me add a new one", :js => true do 
          visit place_path(@fondita)
          click_link I18n.t('places.views.show.announcements')
          
          within('#main-box') do
            click_link I18n.t('places.subviews.show.announcements.actions.new')
            
            fill_in "announcement_header", :with => "Ahorra 10 pesos en cualquier postre si llegas en bici"
            fill_in "announcement_message", :with => "Llega en bici y ahórrate una lana"
            
            click_on I18n.t('actions.save')
          end
          
          within('#tabbed-content') do
            within("#announcement-#{Announcement.last.id}") do
              page.should have_content "Ahorra 10 pesos en cualquier postre si llegas en bici"
              page.should have_content "Llega en bici y ahórrate una lana"
              
              find_link I18n.t('places.subviews.show.announcements.actions.delete')
            end
          end
          
          within(".announcements") do
            page.should have_content I18n.t('places.views.show.announcements')
            page.should have_content 3
          end
        end
      
      end
      
    end
    
  end
  
  def show_announcements(num)
    within("#status-bar") do
      within(".announcements") do
        page.should have_content num
        click_link I18n.t('places.views.show.announcements')
      end
    end
  end
  
end