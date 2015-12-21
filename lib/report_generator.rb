class ReportGenerator
  attr_accessor :products, :brands

  def initialize(raw_data)
    @products = raw_data
    @brands = brands
  end

  def products_report
    products["items"].each do |product|
      puts "\n#{product["title"]}"
      print_line
      puts "– Retail price: #{product["full-price"]}"
      puts "– Total number of purchases: #{number_of_purchases(product)}"
      puts "– Total amount of sales: $#{total_toys_sales_amount(product)}"
      puts "– Average price/toy: $#{average_price_per_toy(product)}"
      puts "– Average discount/toy: #{average_discount(product)}%"
      print_line
    end
  end

  def brands_report
    brands_hash["brands"].each_with_index do |brand, index|
      puts "\n#{brands[index]}"
      print_line
      puts "Number of toys: #{total_stock(brand[brands[index]])}"
      puts "Average price/toy: #{brand_average_toy_price(brand[brands[index]])}"
      puts "Total revenue: $#{brand_total_revenue(brand[brands[index]])}"
      print_line
    end
  end

  private

  def print_line
    puts "#{"-" * 33}"
  end

  def number_of_purchases(product)
    product["purchases"].size
  end

  def brand_average_toy_price(brand)
    brand_total_revenue(brand) / brand_total_purchases(brand)
  end

  def total_toys_sales_amount(product)
    product["purchases"]
      .map { |purchase| purchase["price"]  }
      .reduce(:+)
  end

  def average_price_per_toy(product)
    total_toys_sales_amount(product) / product["purchases"].size
  end

  def average_discount(product)
    value = (1 - (average_price_per_toy(product) / product["full-price"].to_f)) * 100
    value.round(2)
  end

  def brands
    products["items"]
      .map { |product| product["brand"] }
      .uniq
  end

  def brands_hash
    hash = {"brands" => []}
    brands.each do |brand|
      hash["brands"] << { brand => products["items"].select { |product| product["brand"] == brand } }
    end
    hash
  end

  def total_stock(brand)
    brand
      .map { |product| product["stock"] }
      .reduce(:+)
  end

  def brand_total_purchases(brand)
    brand
      .map { |brand| brand["purchases"] }
      .flatten.size
  end

  def brand_total_revenue(brand)
    brand
      .map { |brand| brand["purchases"] }
      .flatten
      .map { |purchase| purchase["price"] }
      .reduce(:+)
      .round(2)
  end
end
