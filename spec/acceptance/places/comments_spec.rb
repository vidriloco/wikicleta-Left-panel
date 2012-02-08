#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Comments in places HTML show:" do
  
  describe "Given I am reviewing a registered place" do
    
    before(:each) do
      @user = Factory(:user)
      attrs = Factory.attributes_for(:recent_place, :name => "Fondita de Doña Pina", :mobility_kindness_index => 9, :category => Factory(:restaurant), :twitter => "")
      @fondita = Place.new_with_owner(attrs, @user)
      @fondita.save
    end
    
    describe "that has no comments yet" do
      
      it "shows an empty comment message", :js => true do
        visit place_path(@fondita)
        
        within('#main-box') do
          show_comments
          
          page.should have_content I18n.t('places.subviews.show.comments.empty')
        end
        
      end
      
    end
    
    describe "that has two comments" do

      before(:each) do
        @pipo = Factory(:pipo)
        @pancho = Factory(:pancho)
        @com1=@fondita.add_comment(@pipo, "Muy buena comida sirve Doña Pina")
        @com2=@fondita.add_comment(@pancho, "Había un pelo en mi sopa, pero está cerca del metro")
      end
      
      it "should show them to me after I click on comments", :js => true do
        visit place_path(@fondita)
        
        within('#main-box') do
          show_comments
          
          within("#comment-#{@com1.id}") do
            page.should have_content("Muy buena comida sirve Doña Pina")
            page.has_css?('.image').should be_true
            page.should have_content @pipo.username
            page.should_not have_content I18n.t('places.subviews.show.comments.actions.delete')
          end
          
          within("#comment-#{@com2.id}") do
            page.should have_content("Había un pelo en mi sopa, pero está cerca del metro")
            page.has_css?('.image').should be_true
            page.should have_content @pancho.username
            page.should_not have_content I18n.t('places.subviews.show.comments.actions.delete')
          end
        end
      end

    end
    
    scenario "cannot register a comment if not logged-in", :js => true do
      visit place_path(@fondita)
      
      within('#main-box') do
        show_comments
        page.should have_content I18n.t('places.messages.error.login_required', :action => I18n.t('places.messages.error.complements.commenting'))
      end
    end
    
    describe "if I am logged-in it" do
      
      before(:each) do
        @pipo = Factory(:pipo)
        login_with(@pipo)
      end
      
      it "should let me register a comment", :js => true do
        visit place_path(@fondita)
        
        within('#main-box') do
          show_comments
        end
        
        fill_in "place_comment", :with => "Está muy buena la comida, además puedo llegar en bici"
        click_button I18n.t('actions.share')
        
        within("#comment-#{PlaceComment.last.id}") do
          page.should have_content("Está muy buena la comida, además puedo llegar en bici")
          page.has_css?('.image').should be_true
          page.should have_content @pipo.username
          find_link I18n.t('places.subviews.show.comments.actions.delete')
        end
        
        within(".comments") do
          page.should have_content I18n.t('places.views.show.comments').singularize
          page.should have_content 1
        end
      end
      
      describe "having posted myself a comment it" do
        
        before(:each) do
          @fondita.add_comment(@pipo, "Un comentario sin valor")
        end
        
        it "should let me delete it", :js => true do
          visit place_path(@fondita)

          within('#main-box') do
            show_comments(:singularized)
          end
          
          place_comment_id = PlaceComment.last.id
          within("#comment-#{place_comment_id}") do
            page.should have_content("Un comentario sin valor")
            click_link I18n.t('places.subviews.show.comments.actions.delete')
          end
          
          page.driver.browser.switch_to.alert.accept
          sleep 4
          
          page.has_css?("#comment-#{place_comment_id}").should be_false
          
          within(".comments") do
            page.should have_content I18n.t('places.views.show.comments')
            page.should have_content 0
          end
        end
        
      end
      
    end
    
  end
  
  def show_comments(singular=nil)
    within("#status-bar") do
      within(".comments") do
        if singular.eql?(:singularized)
          click_link I18n.t('places.views.show.comments').singularize
        else
          click_link I18n.t('places.views.show.comments')
        end
      end
    end
  end
end