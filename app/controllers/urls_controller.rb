class UrlsController < ApplicationController
  before_filter :is_authenticated
  helper_method :sort_column, :sort_direction

  def bookmarklet
    @page_title = "Shorten a URL - #{REDIRECT_DOMAIN}"
    
  end
  
  def show
  	@url = Url.find params[:id]
  end

  def index
    @page_title = "Shorten a URL - #{REDIRECT_DOMAIN}"
    
    @urls = Url.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => params[:per_page])
   
   #  ordering = 'created_at desc'
#     @sort = params[:sort] || session[:sort]
#     @search = params[:search] || session[:search]
#     
#     case @sort
#     when "shortened_url"
#       ordering, @shortened_header, @full_header, @clicks_header = 'shortened asc', 'hilite_shortened', 'to', 'clicks'
#     when "full_url"
#       ordering, @full_header, @shortened_header, @clicks_header = '"to" asc', 'hilite_to', 'shortened', 'clicks'
#     when "clicks_sort"
#       ordering, @clicks_header, @shortened_header, @full_header, = 'clicks desc', 'hilite_clicks',  'shortened', 'to'
#     end
#     
#     @all_owners = Url.all_owners
#     @selected_owners = params[:owners] || session[:owners] || {}
#   
#     if @selected_owners == {}
#       @selected_owners = Hash[@all_owners.map {|owner| [owner, owner]}]
#     end
#     
#     if params[:sort] != session[:sort] or params[:owners] != session[:owners]
#       session[:sort] = @sort
#       session[:owners] = @selected_owners
#       session[:search] = @search
#       flash.keep
#       redirect_to :sort => @sort, :owners => @selected_owners, :search => @search and return
#     end
    
   # if params[:owners] != session[:owners] and @selected_owners != {}
    #  session[:sort] = @sort
    #  session[:owners] = @selected_owners
    #  flash.keep
    #  redirect_to :sort => @sort, :owners => @selected_owners and return
   # end
   
    # if (@selected_owners.keys.include?("Other") and @selected_owners.keys.include?("User")) || @selected_owners == {}
#       @urls = Url.where((@search.blank?) ? ['1 = 1'] : ['"shortened" like ? OR "to" like ?', "%#{@search}%", "%#{@search}%"]).order(ordering).paginate(:page => params[:page], :per_page => params[:per_page])
#     elsif @selected_owners.keys.include?("Other")
#       @urls = Url.where((@search.blank?) ? ['user_id <> ' + current_user.id.to_s] : ['("shortened" like ? OR "to" like ?) AND user_id <> ' + current_user.id.to_s, "%#{@search}%", "%#{@search}%"]).order(ordering).paginate(:page => params[:page], :per_page => params[:per_page])
#     else
#       @urls = Url.where((@search.blank?) ? ['user_id = ' + current_user.id.to_s] : ['("shortened" like ? OR "to" like ?) AND user_id = ' + current_user.id.to_s, "%#{@search}%", "%#{@search}%"]).order(ordering).paginate(:page => params[:page], :per_page => params[:per_page])
#     end
  end
  
  private
  def sort_column
    %w[shortened "to" clicks].include?(params[:sort]) ? params[:sort] : "shortened"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
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
    @url = Url.find params[:id]
  end
  
  def update
    @url = Url.find params[:id]
    
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
    @url = Url.find params[:id]
    
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
    @url = Url.find params[:id]
    
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

end
