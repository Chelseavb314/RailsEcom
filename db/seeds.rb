require 'csv'


Wrestlerproduct.destroy_all
Product.destroy_all
Wrestler.destroy_all
Producttype.destroy_all

file = Rails.root.join('db/data4.csv')

csv_data = File.read(file)

data = CSV.parse(csv_data, headers:true, encoding: 'UTF-8')

data.each do |row|
  producttype = Producttype.find_or_create_by(name: row['category'])

  wrestler = Wrestler.find_or_create_by(name: row['name'])

  if producttype.valid? && wrestler.valid?
    product = Product.find_or_initialize_by(name: row['product']) do |p|
      if p.price.blank?
        p.producttype = producttype
        p.price = (row['price'].to_d * 100 ).to_i
        p.save
      end
    end

     Wrestlerproduct.create(wrestler: wrestler, product: product)
  end

end