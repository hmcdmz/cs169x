class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "PARAMS INTO index", params
    @all_ratings = Movie.enum_ratings
    
    if !params[:ratings].nil?
      @ratings_selected = params[:ratings].keys
    elsif !params[:old_ratings].nil?
      @ratings_selected = params[:old_ratings]
    else
      @ratings_selected = @all_ratings
    end

    puts "selected ratings", @ratings_selected

    if params[:orderby].nil?
      @movies = Movie.find_all_by_rating(@ratings_selected)
    else
      @movies = Movie.order(params[:orderby]).find_all_by_rating(@ratings_selected)
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
