class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    return false unless authorize(permissions = ["view_comment"])
    @comments = Comment.paginate :page => params[:page], :order => 'created_at DESC', :conditions => ['patient_id = ?', params[:patient_id]],:per_page => 50
    #@posts = Post.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    return false unless authorize(permissions = ["view_comment"])
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    return false unless authorize(permissions = ["create_comment"])
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    return false unless authorize(permissions = ["edit_comment"])
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    return false unless authorize(permissions = ["create_comment"])
    @patient = Patient.find(params[:patient_id])
    @comment = @patient.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        flash.now[:notice] = t('messages.comments.create')
        format.html { redirect_to patient_comment_path(:patient_id => params[:patient_id], :id => @comment) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    return false unless authorize(permissions = ["edit_comment"])
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash.now[:notice] = t('messages.comments.update')
        format.html { redirect_to patient_comment_path(:patient_id => params[:patient_id], :id => @comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_comment"])
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to patient_comments_path(:patient_id => params[:patient_id]) }
      format.xml  { head :ok }
    end
  end
end
