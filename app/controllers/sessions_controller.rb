class SessionsController < ApplicationController  
  
 def new
   if current_user.nil?
    deny_access
  else
    @service = Service.new
    @title = "Create New Service"
  end
 end                            
 
end
