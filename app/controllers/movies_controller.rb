class MoviesController < ApplicationController

  @@filter = nil

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.movie_ratings # all the possible movies ratings
    @title_style = nil # the CSS class to apply to the table header for title
    @date_style = nil # the CSS class to apply to the date released header for title
    
    # if this is your first visit, show all ratings
    if @@filter == nil
	@@filter = @all_ratings
    end

    # if a filter is selected, apply that instead
    @selected_ratings = params[:ratings]
    if (@selected_ratings != nil)
	@@filter = @selected_ratings.keys # get the filtering from the view
    end

    if (params[:sort] == 'title')
	@movies = Movie.find_all_by_rating(@@filter, :order => "title")
	@title_style = 'hilite'
    elsif (params[:sort] == 'release')
	@movies = Movie.find_all_by_rating(@@filter, :order => "release_date")
	@date_style = 'hilite'
    else
    	@movies = Movie.find_all_by_rating(@@filter)
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
