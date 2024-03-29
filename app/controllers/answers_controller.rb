class AnswersController < ApplicationController
  
  def index
    @answers = Answer.all
  end 
  
  def show 
    @answer = Answer.find(params[:id])
  end 
  
  def new
    @job = Job.find(params[:job_id])
     
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end
  
  def create 
      store_location
      @question = Question.find(params[:question_id]) 
      
     if current_user.nil?
       cookies[:answer_entry] = params[:answers][:value]   
       # raise p cookies[:answer_entry].inspect 
       deny_access
     else
       params[:answers].each do |question_id, answer_text|
         next if answer_text.blank?
         question = Question.find(question_id)
         question.answers.create!(:answer => answer_text)
         flash[:notice] = "You have sucessfully submitted your answer!"
         redirect_to job_questions_path(@job), :notice => "You have successfully submitted your Answer, please answer more!"
       end
     end
  end
  
  def vote_for
    begin
      if current_user.nil?
        deny_access  
      else    
        if current_user.voted_for?(@answer = Answer.find(params[:id]))  
          flash[:notice] = "You already voted up"
        else
          @vote_for = current_user.vote_exclusively_for(@answer = Answer.find(params[:id]))
          @vote_for.save!
        end
        redirect_to :controller => "answers", :action => "show", :id => @answer.id  
      end
    rescue ActiveRecord::RecordInvalid
     render :nothing => true, :status => 404 
    end
  end
  
  def vote_against
    begin
      if current_user.nil?
        deny_access
      else
        if current_user.voted_against?(@answer = Answer.find(params[:id]))
          flash[:notice] = "You already voted down"
        else 
          @vote_against = current_user.vote_exclusively_against(@answer = Answer.find(params[:id]))
          # raise p @vote_against.inspect 
        end  
        redirect_to :controller => "answers", :action => "show", :id => @answer.id 
      end
    rescue ActiveRecord::RecordInvalid 
      render :nothing => true, :status => 404
    end
  end 
    
  


end
         