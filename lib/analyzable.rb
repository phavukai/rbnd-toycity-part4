module Analyzable
  # Your code goes here!

 def average_price(products)
    averagePrice = 0.0
    products.each do |product|
      averagePrice += product.price.to_f
    end
    averagePrice = (averagePrice/products.length).round(2)
  end

  #prints array in to report
  def print_report(product)
    report = ""
    product.each do |product|
      report += "#{product.id} #{product.brand} #{product.name} #{product.price}\n"
    end
    report
  end

  # counts products of a specific brand
  def count_by_brand(products)
    brandCount = {}
    products.each do |product|
      if(brandCount.has_key?(product.brand))
        brandCount[product.brand] += 1
      else
        brandCount[product.brand] = 1
      end
    end
    brandCount
  end

  #counts all products of a specific name
  def count_by_name(products)
    nameCount = {}
    products.each do |product|
      if(nameCount.has_key?(product.name))
        nameCount[product.name] += 1
      else
        nameCount[product.name] = 1
      end
    end
    nameCount
  end

end
