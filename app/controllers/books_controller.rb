class BooksController < ApplicationController
  # GET /books
  # GET /books.xml
  def index
    @books = Book.order('books.position ASC')
     @tag = Tag.find(params[:tag_id]) if params[:tag_id]
      if params[:search].blank?
        @books = (@tag ? @tag.books : Book.order('books.position ASC'))
      else
        @books = Book.search_published(params[:search], params[:tag_id])
      end
      respond_to do |format|
        format.html { @books = @books.paginate(:page => params[:page], :per_page => books_per_page) }
        format.rss
      end  
      
      
  end

  def sort
    @books = Book.all
    @books.each do |book|
      book.position = params['book'].index(book.id.to_s) + 1
      book.save
  end

  render :nothing => true
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])
    @votes = @book.votes(:true)
    
    # #working on figuring out how to query all of the votes in the db
    # @books = Book.tally({ :at_least => 1, :at_most => 10000, :conditions => true}) 
    # @votes = Vote.tally({ :at_least => 1, :at_most => 10000})
    
  

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to(root_path, :notice => 'Book was successfully created.') }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'Book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end  
  
  def vote_for
    begin
       if current_user.nil?
         redirect_to new_user_session_path
       else
         @vote_for = current_user.vote_for(@book = Book.find(params[:id]))
         @vote_for.save!
         redirect_to book_path(@book)
       end
     rescue ActiveRecord::RecordInvalid
         render :nothing => true, :status => 404
     end   
  end 
   
  
  def vote_against
    begin
      if current_user.nil?
        redirect_to new_user_session_path
      else
        @vote_against = current_user.vote_against(@book = Book.find(params[:id]))
       # raise p @vote_against.inspect
        redirect_to book_path(@book)
      end
    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end
  end          
  
 
 
  
  
  private
  
  def books_per_page
    case params[:view]
    when "list" then 40
    when "grid" then 24
    else 10
    end
  end
end
