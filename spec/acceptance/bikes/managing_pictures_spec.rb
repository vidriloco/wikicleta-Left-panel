#encoding: utf-8
require 'acceptance/acceptance_helper'

# TODO: Enable upload segments for this spec once the capyabara-webkit driver works as expected
feature "Bike photo management:" do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    specialized = FactoryGirl.create(:specialized)
    @bike = FactoryGirl.create(:bike, :bike_brand => specialized)
  end
  
  describe "If I am logged in" do
    
    before(:each) do
      login_with(@user)
    end
    
    describe "given I am not the owner of a bike", :js => true do
      
      before(:each) do
        another_user=FactoryGirl.create(:pipo)
        @bike.update_attribute(:user, another_user)
      end
      
      scenario "cannot add photos" do
        visit bike_path(@bike)
        
        within('.bike-photos') do
          page.should have_no_selector('.reveals-picture-manager')
        end
      end
      
    end
    
    describe "and given I am the owner of a bike", :js => true do
      
      before(:each) do
        @bike.update_attribute(:user, @user)
      end
      
      scenario "allows me to add photos" do
        visit bike_path(@bike)
        launchPictureModal
        within('#picture-manager-modal') do
          page.attach_file(pluploadField, Rails.root+'spec/resources/bike.jpg')
          page.should have_content "bike.jpg"
          
          within('#filelist') do
            click_link("Eliminar")
            page.should_not have_content "bike.jpg"
          end
          
          page.attach_file(pluploadField, Rails.root+'spec/resources/bike.jpg')
        
          page.attach_file(pluploadField, Rails.root+'spec/resources/big_bike.jpg')
          page.should have_content "big_bike.jpg"
          page.should have_content "Error de tamaño de archivo"
        
          find_link I18n.t('pictures.manager.files.upload')
          #click_link I18n.t('pictures.manager.files.upload')
          #page.should have_content "Las fotos seleccionadas fueron guardadas"
        end
      
      end
      
      describe "with previous photos loaded" do
        
        before(:each) do
          #launchPictureModal
          #within('#picture-manager-modal') do
          #  page.attach_file(pluploadField, Rails.root+'spec/resources/bike.jpg')
          #  page.attach_file(pluploadField, Rails.root+'spec/resources/other_bike.jpg')
          #  click_on I18n.t('pictures.manager.files.upload')
          #end
          
          @picture1 = Picture.new_from(:bike_id => @bike.id, :file => File.open(Rails.root+'spec/resources/bike.jpg'))
          @picture1.save
          @picture2=Picture.new_from(:bike_id => @bike.id, :file => File.open(Rails.root+'spec/resources/other_bike.jpg'))
          @picture2.save
          
          visit bike_path(@bike)
        end
      
        scenario "allows me to change the main photo for a bike" do
        
          launchPictureModal
          within('#picture-manager-modal') do
            click_on I18n.t('pictures.manager.sections.uploaded')
            page.should have_content I18n.t('pictures.manager.picture.is_main')
          
            within('.simplePagerNav') do
              click_on "2"
            end
          
            click_on I18n.t('pictures.manager.actions.set_main')
          end
        
          page.should have_content I18n.t('pictures.manager.messages.updated.main_picture')
        
          launchPictureModal
          within('#picture-manager-modal') do
            find_link I18n.t('pictures.manager.actions.set_main')
            click_on I18n.t('pictures.manager.sections.uploaded')
          
            within('.simplePagerNav') do
              click_on "2"
            end
          
            page.should have_content I18n.t('pictures.manager.picture.is_main')
          end
          
        end
      
        scenario "allows me to remove a photo from a bike" do
          
          launchPictureModal
          within('#picture-manager-modal') do
            click_on I18n.t('pictures.manager.sections.uploaded')
            
            page.should have_css("#picture-#{@picture1.id}")            
            page.should have_css("#picture-#{@picture2.id}")            
            
            click_on I18n.t('pictures.manager.actions.delete')
            click_on I18n.t('common_answers')[false]
            
            click_on I18n.t('pictures.manager.actions.delete')
            click_on I18n.t('common_answers')[true]
                            
          end
          sleep 2
          within('#picture-manager-modal') do
            page.should_not have_css("#picture-#{@picture1.id}")      
            page.should have_css("#picture-#{@picture2.id}")            
          end
          
        end
      end
      
    end
    
  end
  
  scenario "cannot do it If not logged in", :js => true do
    visit bike_path(@bike)
    
    within('.bike-photos') do
      page.should have_no_selector('.reveals-picture-manager')
    end
  end
  
end

def pluploadField
  page.evaluate_script("$($('.plupload').children('input')).attr('id');")
end

def launchPictureModal
  within('.bike-photos') do
    find('.reveals-picture-manager').click
  end
end