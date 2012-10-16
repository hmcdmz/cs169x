class Movie < ActiveRecord::Base

  def self.enum_ratings
    ['G','PG','PG-13','R']
  end
end
