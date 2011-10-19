class ApplicationController < ActionController::Base
  protect_from_forgery 
  include SessionsHelper
  
  helper_method :admin?
  
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope  
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end









################################################################### 
  # if user is logged in, return current_user, else return guest_user
    # def current_or_guest_user
    #       if current_user
    #         if session[:guest_user_id]
    #           logging_in
    #           guest_user.destroy
    #           session[:guest_user_id] = nil
    #         end
    #         current_user
    #       else
    #         guest_user
    #       end
    #     end      
    
    # find guest_user object associated with the current session,
    # creating one as needed 
    # def guest_user
    #       User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
    #     end 
    
    # called (once) when the user logs in, insert any code your application needs
    # to hand off from guest_user to current_user.
    # def logging_in
    #     end 
    
    # private
    #     
    #     def create_guest_user
    #       u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@email_address.com")
    #       u.save(false)
    #       u
    #     end 
 
  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to root_path
      false
    end
  end
          
  def admin?
    if current_user.nil?
      return false
    else
    current_user.email == "ian.grabill@gmail.com"
    end
  end                               



end
