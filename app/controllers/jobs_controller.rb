class JobsController < ApplicationController  
  

   def index
     @jobs = Job.order('jobs.position ASC')
     @tag = Tag.find(params[:tag_id]) if params[:tag_id]
       if params[:search].blank?
         @jobs = (@tag ? @tag.jobs : Job.order('jobs.position ASC'))
       else
         @jobs = Job.search_published(params[:search], params[:tag_id])
       end

       respond_to do |format|
         format.html { @jobs = @jobs.paginate(:page => params[:page], :per_page => jobs_per_page) }
         format.rss
       end
   end

   def sort
     @jobs = Job.all
     @jobs.each do |job|
       job.position = params['job'].index(job.id.to_s) + 1
       job.save
     end
     render :nothing => true
   end

   def show
     @job = Job.find(params[:id])
     @votes = @job.votes(:true)

     # #working on figuring out how to query all of the votes in the db
     # @jobs = Job.tally({ :at_least => 1, :at_most => 10000, :conditions => true}) 
     # @votes = Vote.tally({ :at_least => 1, :at_most => 10000})



     respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @job }
     end
   end

   def new
     @job = Job.new 
     5.times do
      question = @job.questions.build 
    end 

     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @job }
     end
   end

   def edit
     @job = Job.find(params[:id])
   end

   def create
     @job = Job.new(params[:job]) 
     # raise p @job.inspect 

     respond_to do |format|
       if @job.save
         format.html { redirect_to(root_path, :notice => 'Job was successfully created.') }
         format.xml  { render :xml => @job, :status => :created, :location => @job }
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
       end
     end
   end

   def update
     @job = Job.find(params[:id])

     respond_to do |format|
       if @job.update_attributes(params[:job])
         format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
       end
     end
   end

   def destroy
     @job = Job.find(params[:id])
     @job.destroy

     respond_to do |format|
       format.html { redirect_to(jobs_url) }
       format.xml  { head :ok }
     end
   end  

   def vote_for
     begin
       if current_user.nil?
         deny_access  
       else    
         if current_user.voted_for?(@job = Job.find(params[:id]))  
           flash[:notice] = "You already voted up"
         else
           @vote_for = current_user.vote_exclusively_for(@job = Job.find(params[:id]))
           @vote_for.save!
         end
           redirect_to @job  
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
         if current_user.voted_against?(@job = Job.find(params[:id]))
           flash[:notice] = "You already voted down"
         else 
           @vote_against = current_user.vote_exclusively_against(@job = Job.find(params[:id]))
           # raise p @vote_against.inspect 
         end  
         redirect_to @job 
       end
     rescue ActiveRecord::RecordInvalid 
       render :nothing => true, :status => 404
     end
   end

   private

   def jobs_per_page
     case params[:view]
     when "list" then 40
     when "grid" then 24
     else 15
     end
   end

 end
