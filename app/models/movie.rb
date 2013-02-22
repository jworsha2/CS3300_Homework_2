class Movie < ActiveRecord::Base

def self.movie_ratings
   ratings = ['G', 'PG', 'PG-13', 'R']
end

def self.movie_ratings_hash
   ratings = {:G => 1, :PG => 1, :PG-13 => 1, :R => 1}
end

end
