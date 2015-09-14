#Read products from 'product.txt'
#Calculate tax for each product, sum of tax and sum of money for all products
#Finally, display all product to console and write all to file 'outputProduct.txt'
class Product
	attr_reader :quantity, :name, :price, :tax
	@@product_array = []
	@@free_product_array = ['food', 'book','medicine']
	@@sum_tax = 0
	@@sum_money = 0

	def initialize quantity, name, price
		@quantity = quantity
		@name = name
		@price = price
		@tax = 0
	end

	def set_tax tax
		@tax = tax
	end

	def display_each_product_to_console
		puts " Description of Product :"
		puts " Quantity : #{@quantity}"
		puts " Name     : #{@name}"
		puts " Price    : #{@price}"
		puts " Tax 	  : #{@tax}%"
		puts " ------------------------------ "
	end

	def import? 
		name.start_with? 'import'
	end

	def free_tax?
		@@free_product_array.each {|item| return true if name.include? item}
		false
	end

	private
	def self.get_data_from_file file_name
		rows_of_products = IO.readlines(file_name)
		product_array = []
		for i in (0..rows_of_products.size - 1)
			product_information_in_array = rows_of_products[i].to_s.chomp.split("  ")
			product_array << product_information_in_array
		end
		product_array.each {|product| @@product_array << 
			Product.new(product.shift.to_i, product.shift, product.shift.to_i)}
	end

	def self.display_all_product_with_tax_to_console
		puts " Information of all products :"
		puts " ------------------------------ "
		@@product_array.each { |product| product.display_each_product_to_console}
		puts " Sum of Tax : " + @@sum_tax.to_s
		puts " Sum of Money " + @@sum_money.to_s
		puts " Sum of Money with tax : " + (@@sum_money + @@sum_tax).to_s
	end

	def self.write_all_product_with_tax_to_file file_name
		outputProduct_file = File.open(file_name,"w+")
		outputProduct_file.syswrite("Quantity".ljust(10))
								outputProduct_file.syswrite("Product".ljust(30))
								outputProduct_file.syswrite("Price".ljust(7))
								outputProduct_file.syswrite("Tax".ljust(5))
								outputProduct_file.syswrite("\n")
		@@product_array.each {|product|
								outputProduct_file.syswrite(product.quantity.to_s.ljust(10))
								outputProduct_file.syswrite(product.name.to_s.ljust(30))
								outputProduct_file.syswrite(product.price.to_s.ljust(7))
								outputProduct_file.syswrite(product.tax.to_s.rjust(2) + "%")
								outputProduct_file.syswrite("\n")
								}
		outputProduct_file.syswrite(" Sum of Tax : " + @@sum_tax.to_s + "\n")
		outputProduct_file.syswrite(" Sum of Money " + @@sum_money.to_s + "\n")
		outputProduct_file.syswrite(" Sum of Money with tax : " +
							 (@@sum_money + @@sum_tax).to_s)
	end

	def self.calculate_tax_and_sum_tax_and_sum_money
		@@product_array.each { |product| 	
				product.set_tax product.tax + 10 unless product.free_tax? 
				product.set_tax product.tax + 5 if product.import?}
		@@product_array.each { |product|  
				@@sum_tax += 0.1 * product.quantity * product.price unless product.free_tax? 
				@@sum_tax += 0.05 * product.quantity * product.price if product.import? }								
		@@product_array.each { |product| 	
				@@sum_money += product.quantity * product.price}
	end
end

Product.get_data_from_file "product.txt"
Product.calculate_tax_and_sum_tax_and_sum_money
Product.display_all_product_with_tax_to_console
Product.write_all_product_with_tax_to_file "outputProduct.txt"
 
