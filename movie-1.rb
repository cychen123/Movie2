#Chenyue Chen; cychen@brandeis.edu
class MovieData0

	attr_accessor :data
	
	def initialize(flag=nil)
		# create an array to store all information in u.data
		# each cell in the array store one line of info
		if flag==nil
			@data = []  
		else
		@data=flag
		end
	end
		
	def load_data
		# store info in u.data line by line to data
		f = File.open("u.data","r")	
			while line = f.gets		
			 user_id, movie_id, rating, timestamp  = line.split("\t")
			 #create a hash for each line
			 data.push({"user_id"=> user_id.to_i, "movie_id"=>movie_id.to_i,"rating"=> rating.to_i,"timestamp"=>timestamp.to_i})
			end
    	puts "data is loaded!"
	#return data     
    end

#puts MovieData.new().load_data.at(0)["user_id"]  #test
	
	# the way to measure popularity here is to add up all 
	# the ratings corresponding to this movie_id
	def popularity(movie_id)
		result=0
		data.each do |singleMovie|
			if singleMovie["movie_id"] == movie_id.to_i
				result += singleMovie["rating"].to_i		
			end	
		end
		return result
  	end

	def popularity_list
		@list=[]
		(1..1682).each do |i|	
			@list.push({i => popularity(i)})
		end	
		@list.sort_by {|k,v| v} 
		puts @list
	end
	

	 # find out the how similar the taste between two users	
	def similarity(user1, user2)
		#puts 'in similarity'
		user1_info = get_user_info(user1)
		user2_info = get_user_info(user2)
		
		# variable count shows how many movies both users both watched
		# then, for all those movie in common, calculate the deviation of ratings
		count = 0
		d = 0
		user1_info.each do|k1,v1| 
			 user2_info.each do |k2,v2|
			 	if k1==k2
			 	count += 1
			 	#puts "user1: movie_id=#{k1} rating=#{user1_info[k1]}\nuser2: movie_id=#{k2} rating=#{user2_info[k2]}\n-----------------------------"
			 	d+=(user1_info[k1] - user2_info[k2])**2
			 	end	 	
			 end
		end
		d=d*1.0/count
		
		#puts "the count is : #{count}"	
		#puts "the deviation is : #{d} "
	
		# variable avg shows the average of degrees
		# of overlap in the movies two users watched
		avg = ((count * 1.0)/user1_info.size() +(count * 1.0)/user2_info.size())/2
		#puts "the average of overlap is #{avg}"
		
		# the way to aggregate these index to a single number:  (1/d)*avg
		# index range: 0~1 where 1 is means most similar
		#puts (1/d)*avg
		return (1/d)*avg
	end


	# get info such as movie_id that the user has watched 
	# and its corresponding rating, and store them in a hash called user_info
	def get_user_info(user)
		user_info={}
		data.each do |singleMovie|
		# user_info is a hash storing info such as{"movie_id=>rating"}
			if singleMovie["user_id"] == user.to_i
				moive_id = singleMovie["movie_id"].to_i
				rating  =  singleMovie["rating"].to_i
				user_info[moive_id] = rating
			end
		end
		return  user_info    
	end
  
  	def most_similar(user)
  		list_of_users=[]
  		data.each {|singleMovie| list_of_users.push(singleMovie["user_id"]) }
  		#puts list_of_users
  		
  		#get the result of comparisons between 'user' and each other users

  		list_of_users = list_of_users.uniq
  		result_of_compr=[]	
  		list_of_users.each {|u| result_of_compr.push({"user_id"=>u,"how_similar"=> MovieData0.new(data).similarity(user, u)})}
  		
  		
  		###???
  		result_of_compr.each do |line|
  		if line["how_similar"] == Infinity or line["how_similar"] == NaN
  		end
  		puts result_of_compr = result_of_compr.sort_by {|hs| -hs["how_similar"]}
  		
  		#result_of_compr = result_of_compr[1..-1]
  		 
  		
  		#return result_of_compr 
  		
  	end
  	
 end 
############# testing################  	
   #oneMovieData = MovieData0.new()
   #oneMovieData.load_data()
   #puts "the popularity of movie_id:1 "
   #num = gets.chomp
   #puts oneMovieData.popularity(1)
   #oneMovieData.popularity_list   
   #oneMovieData.get_user_info(617)
   #puts oneMovieData.data
   #oneMovieData.similarity(170, 698)
   #oneMovieData.most_similar(170)
   
 
 
 
 
 

 
 

 
 
 
   