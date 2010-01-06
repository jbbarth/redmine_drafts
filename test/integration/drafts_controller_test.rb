require File.dirname(__FILE__) + '/../test_helper'

class DraftsControllerTest < ActionController::TestCase
  fixtures :drafts, :issues, :users
  
  def test_add_and_remove_servers_from_an_issue
    get :edit, :id => 1
    assert_response :success
    #"issue_id"=>"5",
    #"notes"=>"",
    #"user_id"=>"1",
    #"issue"=>{"start_date"=>"2009-12-26", "estimated_hours"=>"", "priority_id"=>"3", 
    #          "lock_version"=>"8", "done_ratio"=>"0", "assigned_to_id"=>"", 
    #          "subject"=>"This is a new bug hé", "tracker_id"=>"1", "due_date"=>"", 
    #          "status_id"=>"3", "description"=>""
    #          }
    xhr :post, :create,
               :issue_id => "5",
               :notes => "There's no place like 127.0.0.argh!",
               :user_id => 1,
               :issue => { :lock_version => "8", 
                           :subject => "Hey I changed the subject !" }
  end
end
