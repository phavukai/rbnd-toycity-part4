class Module
  def create_finder_methods(*attributes)
     attributes.each do |attribute|
      self.class_eval("def self.find_by_#{attribute}(argument); 
	products = all
    	products.each do |product|
      	  if(product.#{attribute} == argument)
            return product
          end
        end; end")
    end
  end
end
