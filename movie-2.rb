#Chenyue Chen; 2015.9
=begin
z.rating(u,m) returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
z.predict(u,m) returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
z.movies(u) returns the array of movies that user u has watched
z.viewers(m) returns the array of users that have seen movie m
z.run_test(k) runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results.
The parameter k is optional and if omitted, all of the tests will be run.
=end

require_relative 'movie-1'

class MovieData
	attr_accessor :datab, :datat    
	
	 def initialize(name, flag=nil)
	 	if flag.nil?
	 		file_obj = File.open("#{name}/u.data")
	 		@datab=load_file(file_obj)
	 		puts "u.data loaded, no testing data."
	 	else
	 		file_obj_base = File.open("#{name}/#{flag}.base")
	 		file_obj_test = File.open("#{name}/#{flag}.test")
	 		@datab=load_file(file_obj_base)
			@datat=load_file(file_obj_test)
			puts "#{flag}.base and #{flag}.test loaded."
			#puts datab
	 	end
	 	
	 end

	# store info as hashes within an array
	def load_file(f)
		data = []
        f.each do |line| 
        user_id, movie_id, rating, timestamp  = line.split("\t")
        data.push({"user_id"=> user_id.to_i, "movie_id"=>movie_id.to_i,"rating"=> rating.to_i,"timestamp"=>timestamp.to_i})
		end
		return data
	end
	
  
   def rating(u,m)
	   datab.each do |line|              
			if line["user_id"]==u.to_i and line["movie_id"] == m.to_i	
			return line["rating"]
			end
	   end
	   return 0
   end
   
  
   # the prediction is the average of: 
   # 1.the average of all ratings that user gave to all movies he/she has watched
   # 2.the rating of the movie from the most similar user, if any
   def predict(u,m)
   
   # 1. the average
   		count=0
   		sum=0.0
   		datab.each do |line|               
			if line["user_id"]==u.to_i
			count+=1
			sum+=line["rating"]
			end
   		end
   		ans1 = sum/count
   	# 2. rating from the most similar user
   	 	a_movie_data = MovieData0.new(datab)
   	 	
   	 	similar_user_info_arr = a_movie_data.most_similar(u)
   	  puts	similar_user_info_arr
   	 	puts "here predict2"
   	 	similar_rating = 0.0
   	 	top_20percent_index = 0.2*similar_user_info_arr.size()  #only search in top 20percent most similar users
   	 	
   	 	similar_user_info_arr[0..top_20percent_index].each do |hs| 
   	 	
   	 		user_id=hs["user_id"] 
			if z.rating(user_id,m)!=0
			similar_rating z.rating(user_id,m)
			end
   	 	end
   	 	
   	 	if similar_rating == 0 
   	 		puts "no matches"
   	 		return ans1
   	 	else
   	 		return (similar_rating+ans1)/2
   	 	end
   end
   
   
   def movies(u)
   	   arr=[]
	   datab.each do |line|
		   if line["user_id"]==u.to_i 
		   arr.push(line["movie_id"])
		   end
	   end 
	   return arr
   end
   
   def viewers(m)
   	  arr=[]
      datab.each do |line|
		   if line["movie_id"]== m.to_i 
		   arr.push(line["user_id"])
		   end
	  end
	  return arr
   end
   
      
   def run_test(k)
   		compr = []
   		datat[0..k].each do |hs|
   			user_id_t = hs["user_id"]
   			movie_id_t = hs["movie_id"]
   			rating = hs["rating"]
   			prediction = z.rating(user_id_t,movie_id_t)
   			compr.push({"user_id"=>user_id_t, "movie_id"=>movie_id_t,"rating"=>rating,"prediction"=>prediction})
   		end 		
   		t = MovieTest.new(compr)
   	end
  
end

=begin
t.mean returns the average predication error (which should be close to zero)
t.stddev returns the standard deviation of the error
t.rms returns the root mean square error of the prediction
t.to_a returns an array of the predictions in the form [u,m,r,p]. You can also generate other types of error measures if you want, but we will rely mostly on the root mean square error.
=end


class MovieTest 
	attr_accessor :test_result, :error_arr
		
		def initialize(arr)
			@test_result=arr
			@error_arr=[]
		end
		
		
		def stddev
			count=0
			sum=0.0
		
		
			test_result.each do |hs|
				count++
				error =hs["rating"].to_i-hs["prediction"].to_i
				error_arr.push(error)
				sum+=error
			end
		
			mean = sum/count 
		
			cal=0
			error_arr.each do |n| 
				cal+=(n-mean)**2 
			end
			return Math.sqrt(cal/count)
		
		end
		
		def rms
			sum=0.0
			count=0
			error_arr.each do |n| 
				count++
				sum+=n**2
			end
			return Math.sqrt(sum/count)
		end
		
		def to_a
			return test_result
		end
		
end

################## testing #################
  #z = MovieData.new("ml-100k")
   z = MovieData.new('ml-100k',:u1)
   
   #puts z.rating(1,19)
   puts z.predict(1,305)
   #puts z.movies(1)
   #puts z.viewers(181)
   #puts z.run_test(3)
   #puts t.stddev
   #puts t.rms
   #puts t.to_s	