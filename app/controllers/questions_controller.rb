class QuestionsController < ApplicationController

  def index
    @book = Book.find(params[:book_id])
  end 
  
  def show
    @book = Book.find(params[:book_id]) 
    @question = @book.questions.find(params[:id])
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
