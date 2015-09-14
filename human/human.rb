#First choose way to create human
#Create human with information from console or create humans from human hash array
#or create humans with information from input_human_in_hash.txt'
#Display all humans to console
#Search human with gender, more or less or equal an age
#Display humans suitable with the above condition 
class Human
	@@human_array = []
	person1 = {name: "Thien", gender: "male", age: 23}
	person2 = {name: "Hung", gender: "female", age: 121}
	person3 = {name: " ", gender: "male", age: 15}
	person4 = {name: "Kien", gender: "male", age: 14}
	person5 = {name: "Phuc", gender: "female", age: 45}
	person6 = {name: "Anh", gender: "female", age: 24}
	@@human_hash_array = [person1, person2, person3, person4, person5, person6]
	attr_accessor :name, :age, :gender

	def initialize name, age, gender
		@name, @age, @gender = name, age, gender
	end

	def display_one_human_to_console
		puts " Description of human :"
		puts " Name   : #{@name}"
		puts " Age    : #{@age}"
		puts " Gender : #{@gender}"
		puts " ------------------------------ "
	end

	def self.human_hash_array
		@@human_hash_array
	end

	def self.create_humans_from_hash_array human_hash_array
		human_hash_array.each {
			|human_hash| @@human_array[@@human_array.size] = 
					Human.new human_hash[:name],human_hash[:age], 
					human_hash[:gender] if check_validate_human_hash? human_hash
		}
	end

	def self.check_valid_human_hash? human_hash
		return false unless valid_name? human_hash[:name]
		return false unless valid_age? human_hash[:age]
		return false unless valid_gender? human_hash[:gender]
		true
	end

	def self.valid_name? name
		((name.is_a? String) && (name.delete(' ') != ''))
	end

	def self.valid_age? age
		((age.is_a? Integer) && (age >= 1) && (age <= 100))
	end

	def self.valid_gender? gender
		return false unless gender.is_a? String
		((gender.downcase == 'male') || (gender.downcase == 'female'))
	end

	def self.invalid_comparison? comparison
		comparison != 'more' && comparison != 'less' && comparison != 'equal'
	end

	def self.get_humans_from_file file_name
		rows_of_humans = IO.readlines(file_name)
		for i in (0..rows_of_humans.size - 1)
			human = rows_of_humans[i].to_s.chomp.split("  ")
			human_hash = {name: human.shift, age: human.shift.to_i, gender: human.shift}
			@@human_hash_array << human_hash if check_valid_human_hash? human_hash
		end
	end

	def self.create_new_human_from_console
		puts "Input information of human : "
		puts "Input your name : "
		name = gets.chomp
		puts "Input your age : "
		age = gets.to_i
		while age <= 0 
			puts "Your age must be a positive integer!"
			puts "Input your age again : "
			age =  gets.to_i
		end
		puts "Input your gender : "
		gender = gets.chomp
		while invalid_gender? gender
			puts "Your gender must be 'male' or 'female'!"
			puts "Input your gender again"
			gender = gets.chomp
		end
		@@human_array[@@human_array.size] = Human.new name, age, gender
		confirm_new_human
	end
	
	def self.confirm_new_human
		puts "Do you want to create new human : y/n"
		choice = gets.chomp
		while (choice == 'y' || choice == 'Y' || choice == 'yes')
			Human.create_new_human_from_console
			choice = ""
		end
	end
	
	def self.display_all_human
		puts " ------------------------------ "
		puts " Information of all human : "
		@@human_array.each{|human| human.display_one_human_to_console}
	end

	def self.filter_human_by_gender_and_age_with_comparison gender, age, comparison
		if comparison == 'more'
			array_of_human_suitable_arguments = @@human_array.select {|human| 
																		human.gender == gender && human.age > age}
		elsif comparison == 'less'
			array_of_human_suitable_arguments = @@human_array.select {|human| 
																		human.gender == gender && human.age < age}
		elsif comparison == 'equal' 
			array_of_human_suitable_arguments = @@human_array.select {|human| 
																		human.gender == gender && human.age == age}
		else
			puts "Input 'more' or less for third argument:"
		end
		array_of_human_suitable_arguments
	end

	def self.create_new_search_by_gender_and_age_with_compare_that_age
		puts "Which gender do you want to search?"
		gender = gets.chomp
		while !valid_gender? gender
			puts "Your gender must be 'male' or 'female'!"
			puts "Input your gender again"
			gender = gets.chomp
		end

		puts "Which age do you want to search"
		age = gets.to_i
		while age <= 0 
			puts "Your age must be a positive integer!"
			puts "Input your age again : "
			age =  gets.to_i
		end

		puts "Which comparison do you want to comapre with the age you input !"
		comparison = gets.chomp
		while invalid_comparison? comparison
			puts "Your comparison must be 'more', 'less' or 'equal'!"
			puts "Input your comparison again"
			comparison = gets.chomp
		end

		puts " ------------------------------ "
		array_of_human_suitable_arguments = 
			filter_human_by_gender_and_age_with_comparison gender, age, comparison
		puts "Result of the search with gender = "
											"#{gender}, #{comparison} #{age} age: "
		if array_of_human_suitable_arguments.size == 0
			puts "No human suitable with your conditions."
		end
		array_of_human_suitable_arguments.each do 
			|human| human.display_one_human_to_console
		end
		confirm_new_search
	end

	def self.confirm_new_search
		puts "Do you want to search again : y/n"
		choice = gets.chomp
		while (choice == 'y' || choice == 'Y' || choice == 'yes')
			create_new_search_by_gender_and_age_with_more_or_less_that_age
			choice = ""
		end
	end

	def self.convert_human_hash_array_to_human_array human_hash_array
		human_hash_array.each{|human_hash| 
			human = Human.new human_hash[:name], human_hash[:age], human_hash[:gender]
			@@human_array << human }
	end

	def self.choose_way_to_create_human
		puts "Do you want to create human from console or from array of human hash
				 	or from file :"
		puts "Type 1 for console, type 2 for array of human hash or type 3 for file: "
		choice = gets.to_i
		loop do
			if choice == 1 
				@@human_hash_array.size.times { @@human_hash_array.shift}
				Human.create_new_human_from_console 
				break
			elsif choice == 2
				@@human_hash_array.select!{|human_hash| check_valid_human_hash? human_hash}
				convert_human_hash_array_to_human_array human_hash_array
				break
			elsif choice == 3
				@@human_hash_array.size.times { @@human_hash_array.shift}
				get_humans_from_file 'input_human_in_hash.txt'
				convert_human_hash_array_to_human_array human_hash_array
				break
			else 
				puts "I dont know what's your means! Please type 1 or 2 or 3"
				choice = gets.to_i
			end
		end
	end
end
Human.choose_way_to_create_human
Human.display_all_human
Human.create_new_search_by_gender_and_age_with_compare_that_age


