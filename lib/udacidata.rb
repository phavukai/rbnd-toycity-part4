#require_relative 'product'
require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"
   
  #create new entry in the dbs
  def self.create(attributes = nil)
    product = new(attributes)
    
    # check if id is already in the dbs
    cvsData = CSV.read(@@data_path)
    cvsData.each do |data|
      if(data[0].to_i == product.id)
        return product
      end
    end
    
   #add product to dbs
   CSV.open(@@data_path, "a+b") do |productData|
      productData << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  #return an array of all Products
  def self.all
    newProducts = []
    CSV.foreach(@@data_path, headers:true) do |product|
      id, brand, name, price = product["id"], product["brand"], product["product"], product["price"]
      newProducts << new(id: id, brand: brand, name: name, price: price)
    end
    newProducts
  end
  
  #return first n items of products (first item if no argument is given)
  def self.first(index = 1)
    products = all
    if(index == 1)
      products.first
    else
      products.first(index)
    end
  end

  #return last n items of products (last item if no argument is given)
  def self.last(index = 1)
    products = all
    if(index == 1)
      products.last
    else
      products.last(index)
    end
  end

#  #find item by index
#  def self.find(index)
#    products = all
#    if(index > products.length)
#      raise ProductNotFoundErrors, "'#{index}' out of range."
#    end
#    products.each do |product|
#      if(product.id == index)
#        return product
#      end
#    end
#  end

  #New find by id 
  def self.find(id)
      data = CSV.read(@@data_path).drop(1)
      product = data.select{ |item| item[0] == id.to_s}.first
      if !product
        raise ProductNotFoundErrors, "'#{id}' not found."
      end
      return Product.new({id: product[0], brand: product[1], name: product[2], price:product[3]})
  end

   def self.destroy(product_id)
       deleted_product = Product.find(product_id)
          if deleted_product
            data = CSV.table(@@data_path)
            data.delete_if do |row|
             row[:id] == product_id
          end        
        File.open(@@data_path, 'w') do |f|
          f.write(data.to_csv)
        end
      if !deleted_product
	raise ProductNotFoundErrors, "'#{id}' not found."
	end
      end
      return deleted_product	
  end



  #find items by attribute
  def self.where(attributes = {})
    products = all
    productsByBrand = []

    if(attributes.keys[0] == :brand)
      products.each do |product|
        if(product.brand == attributes.values_at(:brand).join)
          productsByBrand << product
        end
      end
    elsif(attributes.keys[0] == :name)
      products.each do |product|
        if(product.name == attributes.values_at(:name).join)
          productsByBrand << product
        end
      end
    end
    productsByBrand
  end

  #update an item
  def update(params = {})
    data = CSV.table(@@data_path)
    data.each do |row|
      if row[:id] == @id
        if params[:price]
          row[:price] = params[:price]
        end

        if params[:brand]
          row[:brand] = params[:brand]
        end
      end
    end

    File.open(@@data_path, 'w') do |f|
          f.write(data.to_csv)
    end
    
    return Product.find(@id)
  end  

  #create find_by name and brand methods 
  def self.method_missing(method_name, arguments)
    if(method_name.to_s.start_with?("find_by"))
      create_finder_methods("name", "brand")
      self.public_send(method_name, arguments)
    end
  end

  
end
