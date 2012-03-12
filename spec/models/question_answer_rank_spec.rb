#encoding: utf-8
require 'spec_helper'

describe QuestionAnswerRank do  
  
  describe "for Street Marks" do
  
    before(:each) do
      @q1 = Factory(:cars_speed)
      @q2 = Factory(:comfortable)
    end
  
    describe "having two captured opinions for a given street mark" do
      
      before(:each) do
        @street_mark = Factory(:street_mark)
        pipo = Factory(:pipo)
        user = Factory(:pancho)
        Factory(:street_mark_answer, :ranked => @street_mark, :user => pipo, :cataloged_question => @q1, :cataloged_answer => @q1.cataloged_answers.first)
        Factory(:street_mark_answer, :ranked => @street_mark, :user => user, :cataloged_question => @q1, :cataloged_answer => @q1.cataloged_answers.last)
        
        Factory(:street_mark_answer, :ranked => @street_mark, :user => user, :cataloged_question => @q2, :cataloged_answer => @q2.cataloged_answers.first)
        Factory(:street_mark_answer, :ranked => @street_mark, :user => pipo, :cataloged_question => @q2, :cataloged_answer => @q2.cataloged_answers.first)
      end
      
      it "should have stored the count for each street mark answer captured" do
        QuestionAnswerRankCount.count.should == 3
        
        for_first_question_with_first_answer={
          :ranked_count_id => @street_mark.id, 
          :ranked_count_type => @street_mark.class.to_s, 
          :cataloged_answer_id => @q1.cataloged_answers.first.id
        }
        QuestionAnswerRankCount.first(:conditions => for_first_question_with_first_answer).total.should == 1
        
        for_first_question_with_second_answer={
          :ranked_count_id => @street_mark.id, 
          :ranked_count_type => @street_mark.class.to_s, 
          :cataloged_answer_id => @q1.cataloged_answers.first.id
        }
        QuestionAnswerRankCount.first(:conditions => for_first_question_with_second_answer).total.should == 1
        
        for_first_option_second_question={
          :ranked_count_id => @street_mark.id, 
          :ranked_count_type => @street_mark.class.to_s, 
          :cataloged_answer_id => @q2.cataloged_answers.first.id
        }
        QuestionAnswerRankCount.first(:conditions => for_first_option_second_question).total.should == 2
      end
      
      it "should generate the results count for each cataloged question" do
        #@q1.stats_for(@street_mark).should == { @q1.id => { @q1.cataloged_answers.first.id => 1, @q1.cataloged_answers.last.id => 1 } }
        #@q2.stats.should == { @q2.id => { @q2.cataloged_answers.first.id => 2, @q2.cataloged_answers.last.id => 0 } }
      end
      
    end
  end
end