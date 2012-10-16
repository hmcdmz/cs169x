class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.enum_ratings
    
    if !params[:ratings].nil?
      @ratings_selected = params[:ratings].keys
    elsif !params[:old_ratings].nil?
      @ratings_selected = params[:old_ratings]
    elsif !session[:sess_ratings_selected].nil?
      @ratings_selected = params[:old_ratings] = session[:sess_ratings_selected]
    else
      @ratings_selected = @all_ratings
    end

    if !params[:order_by].nil?
      @order_by = params[:order_by]
    elsif !session[:sess_order_by].nil?
      @order_by = session[:sess_order_by]
      redirect_to movies_path({:order_by => @order_by})
    end

    if @order_by.nil?
      @movies = Movie.find_all_by_rating(@ratings_selected)
    else
      @movies = Movie.order(@order_by).find_all_by_rating(@ratings_selected)
    end
    
    session[:sess_ratings_selected] = @ratings_selected
    session[:sess_order_by] = @order_by

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
