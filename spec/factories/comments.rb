# encoding: utf-8

FactoryGirl.define do
  
  # simple example cases for StreetMarks model
  factory :comment_for_bike, :class => "Comment" do |c|
    c.comment "A simple comment"
    c.commentable { FactoryGirl.create(:bike) }
    c.association(:user) { FactoryGirl.create(:user) }
  end
  
end