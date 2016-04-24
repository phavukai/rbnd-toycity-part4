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

  #find item by index
  def self.find(index)
    products = all
    if(index > products.length)
      raise ProductNotFoundErrors, "'#{index}' out of range."
    end
    products.each do |product|
      if(product.id == index)
        return product
      end
    end
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
  def update(attributes = {})
    @brand = attributes[:brand]
    @price = attributes[:price]
    cvsData = CSV.read(@@data_path)
    cvsData.delete_at(0)
    cvsData.each do |data|
      if(data[0].to_i == @id)
        data[1] = @brand
        data[3] = @price
      end
    end

    #create new dbs
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end

    #append remaining data
    CSV.open(@@data_path, "a") do |csv|
      cvsData.each do |data|
        csv << [data[0], data[1], data[2], data[3]]
      end
    end
    self
  end

  #remove an item
  def self.destroy(index)
    #read dbs and remove element
    cvsData = all
    if(index > cvsData.length)
      raise ProductNotFoundErrors, "'#{index}' out of range."
    end
    deletedProduct = nil
    i = 0
    cvsData.each do |data|
      if(data.id == index)
        deletedProduct = data
        cvsData.delete_at(i)
      end
      i += 1
    end

    #create new dbs
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end

    #append remaining data
    CSV.open(@@data_path, "a") do |csv|
      cvsData.each do |data|
        csv << [data.id, data.brand, data.name, data.price]
      end
    end
    deletedProduct
  end

  #create find_by name and brand methods 
  def self.method_missing(method_name, arguments)
    if(method_name.to_s.start_with?("find_by"))
      create_finder_methods("name", "brand")
      self.public_send(method_name, arguments)
    end
  end

  
end
