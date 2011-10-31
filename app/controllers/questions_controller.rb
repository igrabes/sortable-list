class QuestionsController < ApplicationController

  def index
    @job = Job.find(params[:job_id])
  end 
  
  def show
    @job = Job.find(params[:job_id]) 
    @question = @job.questions.find(params[:id])
    
    if user_signed_in?
      @answer = cookies[:answer_entry]
      # raise p @answer.inspect   
      # @answer.scan(/(\d+)\W+(\w+)/).collect { |question_id, answer_text| { :question_id => question_id, :answer_text => answer_text }}
      # @answer = Hash[ [:question_id, :answer_text].zip(@answer.split(/[\d+[a-z]+]/))]  
      # @answer = 
      # raise p @answer.inspect 
    else
     cookies[:answer_entry] = nil
     # raise p cookies[:answer_text]
   end
  end
  
  def new
    @question = Question.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end
  
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

end
