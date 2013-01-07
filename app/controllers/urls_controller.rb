class UrlsController < ApplicationController
  
  before_filter :is_authenticated
  helper_method :sort_column, :sort_direction

  def bookmarklet
    @page_title = "Shorten a URL - #{REDIRECT_DOMAIN}"
  end
  
  def show
    begin
      @url = Url.mine(current_user).find params[:id]
    rescue
      flash[:error] = "Insufficient privileges. Access denied."
      redirect_to urls_path
    end
  end

  def index
    @page_title = "Shorten a URL - #{REDIRECT_DOMAIN}"
    
    hilite
    
    @search_text = params[:search] || session[:search]
  
    if params[:search] != session[:search]
      session[:search] = @search_text
    end
    
    if current_user.superadmin?
      @urls = Url.search(@search_text).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => params[:per_page])
    else
      @urls = Url.search(@search_text).mine(current_user).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => params[:per_page])
    end
  end

  def create
    @url = Url.new(
      :shortened  => params[:url][:shortened],
      :to => params[:url][:to]
    )
    @url.user_id = current_user.id
    
    respond_to do |f|
      f.html {
        if @url.save
          #render :text => "<h2 class='generated_url'>Huzzah!: <a href='http://brk.mn/#{@url.shortened}'>http://brk.mn/#{@url.shortened}</a></h2>", :layout => ! request.xhr?, :partial => 'shared/url_list'
          flash[:notice] = "Shortened URL (http://brk.mn/#{@url.shortened}) was successfully created."
        else
          logger.warn(@url.errors.inspect)
          #render :text => "#{@url.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity
          flash[:error] = "ERROR: #{@url.errors.full_messages}"
        end
      }
    end
    
    redirect_to urls_path
  end
  
  def edit
    begin
      @url = Url.mine(current_user).find params[:id]
    rescue
      flash[:error] = "Insufficient privileges. Access denied."
      redirect_to urls_path
    end
  end
  
  def update
    respond_to do |f|
      f.html {
        if @url.update_attributes(params[:url])
		  flash[:notice] = "Shortened URL (http://brk.mn/#{@url.shortened}) was successfully updated."
        else
          logger.warn(@url.errors.inspect)
          flash[:error] = "ERROR: #{@url.errors.full_messages}"
        end
      }
    end
    
    redirect_to edit_url_path(@url.id)
  end
  
  def reset
    respond_to do |f|
      f.html {
        if @url.update_attribute(:clicks, 0)
		  flash[:notice] = "Shortened URL (http://brk.mn/#{@url.shortened}) 'Clicks' was reset to zero."
        else
          logger.warn(@url.errors.inspect)
          flash[:error] = "ERROR: #{@url.errors.full_messages}"
        end
      }
    end
    
    redirect_to edit_url_path(@url.id)
  end
  
  def destroy
    respond_to do |f|
      f.html {
        if @url.destroy
          flash[:notice] = "Shortened URL (http://brk.mn/#{@url.shortened}) was successfully deleted."
        else
          logger.warn(@url.errors.inspect)
          flash[:error] = "ERROR: #{@url.errors.full_messages}"
        end
      }
    end
    
    redirect_to urls_path
  end
  
  private
  def sort_column
  
    sort = params[:sort] || session[:sort]
  
    if params[:sort] != session[:sort]
      session[:sort] = sort
    end

    %w[shortened "to" clicks].include?(sort) ? sort : "shortened"
  end
  
  def sort_direction
  
    direction = params[:direction] || session[:direction]
  
    if params[:direction] != session[:direction]
      session[:direction] = direction
    end
    
    %w[asc desc].include?(direction) ?  direction : "asc"
  end
  
  def hilite   
    case params[:sort] || session[:sort]
    when '"to"'
      @to_header = 'to hilite'
      @click_header = 'clicks'
      @shortened_header = 'shortened'
    when "clicks"
      @clicks_header = 'clicks hilite'
      @to_header = 'to'
      @shortened_header = 'shortened'
    else
      @shortened_header = 'shortened hilite'
      @click_header = 'clicks'
      @to_header = 'to'
    end
  end

end
