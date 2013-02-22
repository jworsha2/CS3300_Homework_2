class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.movie_ratings # all the possible movies ratings
    @title_style = nil # the CSS class to apply to the table header for title
    @date_style = nil # the CSS class to apply to the date released header for title  

    redirect = nil # flag to indicate a redirect with all params is needed  

    # find the appropriate filter for this index
    @selected_ratings = params[:ratings]
    @session_ratings = session[:ratings]
    ratings = nil
    if (@selected_ratings != nil)
	ratings = @selected_ratings
	@filter = @selected_ratings.keys # get the filtering from the view
	session[:ratings] = @selected_ratings
    elsif (@session_ratings != nil)
	ratings = @session_ratings
	redirect = true
	@filter = @session_ratings.keys # get the filtering from the session
    else 
	ratings = Movie.movie_ratings_hash
	@filter = @all_ratings # otherwise display all
    end

    sort = nil
    # find the appropriate order for this index
    if (params[:sort] == 'title')
	sort = 'title'
	@movies = Movie.find_all_by_rating(@filter, :order => "title")
	@title_style = 'hilite'
	session[:sort] = 'title'
    elsif (params[:sort] == 'release')
	sort = 'release'
	@movies = Movie.find_all_by_rating(@filter, :order => "release_date")
	@date_style = 'hilite'
	session[:sort] = 'release'
    elsif (session[:sort] == 'title')
	redirect = true
	sort = 'title'
	@movies = Movie.find_all_by_rating(@filter, :order => "title")
	@title_style = 'hilite'
    elsif (session[:sort] == 'release')
	redirect = true
	sort = 'release'
	@movies = Movie.find_all_by_rating(@filter, :order => "release_date")
	@date_style = 'hilite'
    else
    	@movies = Movie.find_all_by_rating(@filter)
    end

    # if a redirect needs to be made to ensure RESTfulness, perform it
    if (redirect == true)
	flash.keep
	redirect_to :action => 'index', :sort => sort, :ratings => ratings
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
