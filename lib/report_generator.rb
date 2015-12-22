class ReportGenerator
  attr_accessor :products, :brands

  def initialize(args = {})
    @products = args[:raw_data] || raw_data
    @brands = brands
    report_file = args[:report_file] || "../report.txt"
    File.new(report_file, "w+")
  end

  def raw_data(filename = "products.json")
    path = File.join(File.dirname(__FILE__), "../data/#{filename}")
    file = File.read(path)
    JSON.parse(file)
  end

  def products_report
    print_products_header

    products["items"].each do |product|
      open("../report.txt", "a") do |f|
        f.puts "\n#{product["title"]}"
        f.puts print_line
        f.puts "– Retail price: #{product["full-price"]}"
        f.puts "– Total number of purchases: #{number_of_purchases(product)}"
        f.puts "– Total amount of sales: $#{total_toys_sales_amount(product)}"
        f.puts "– Average price/toy: $#{average_price_per_toy(product)}"
        f.puts "– Average discount/toy: #{average_discount(product)}%"
        f.puts print_line
      end
    end
  end

  def brands_report
    print_brands_header

    brands_hash["brands"].each_with_index do |brand, index|
      open("../report.txt", "a") do |f|
        f.puts "\n#{brands[index]}"
        f.puts print_line
        f.puts "Number of toys: #{total_stock(brand[brands[index]])}"
        f.puts "Average price/toy: #{brand_average_toy_price(brand[brands[index]])}"
        f.puts "Total revenue: $#{brand_total_revenue(brand[brands[index]])}"
        f.puts print_line
      end
    end
  end

  def print_report_header
    open("../report.txt", "a") do |f|
      f.puts "   _____       __             ____                        __ "
      f.puts "  / ___/____ _/ /__  _____   / __ \\___  ____  ____  _____/ /_"
      f.puts "  \\__ \\/ __ `/ / _ \\/ ___/  / /_/ / _ \\/ __ \\/ __ \\/ ___/ __/"
      f.puts " ___/ / /_/ / /  __(__  )  / _, _/  __/ /_/ / /_/ / /  / /_  "
      f.puts "/____/\\__,_/_/\\___/____/  /_/ |_|\\___/ .___/\\____/_/   \\__/  "
      f.puts " __________________________________ /_/______________________"
      f.puts "/_____/_____/_____/_____/_____/_____/_____/_____/_____/_____/"
    end
  end

  def print_time_stamp
    open("../report.txt", "a") do |f|
      f.puts "Report generated on: #{Time.now.strftime('%c')}"
      f.puts ""
    end
  end

  private

  def print_products_header
    open("../report.txt", "a") do |f|
      f.puts "    ____                 __           __      "
      f.puts "   / __ \\_________  ____/ /_  _______/ /______"
      f.puts "  / /_/ / ___/ __ \\/ __  / / / / ___/ __/ ___/"
      f.puts " / ____/ /  / /_/ / /_/ / /_/ / /__/ /_(__  ) "
      f.puts "/_/   /_/   \\____/\\__,_/\\__,_/\\___/\\__/____/  "
    end
  end

  def print_brands_header
    open("../report.txt", "a") do |f|
      f.puts ""
      f.puts "    ____                       __    "
      f.puts "   / __ )_________ _____  ____/ /____"
      f.puts "  / __  / ___/ __ `/ __ \\/ __  / ___/"
      f.puts " / /_/ / /  / /_/ / / / / /_/ (__  ) "
      f.puts "/_____/_/   \\__,_/_/ /_/\\__,_/____/  "
    end
  end

  def print_line
    "—" * 33
  end

  def number_of_purchases(product)
    product["purchases"].size
  end

  def brand_average_toy_price(brand)
    brand_total_revenue(brand) / brand_total_purchases(brand)
  end

  def total_toys_sales_amount(product)
    product["purchases"]
      .inject(0) { |sum, purchase| sum + purchase["price"] }
  end

  def average_price_per_toy(product)
    total_toys_sales_amount(product) / number_of_purchases(product)
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
    brand.inject(0) { |sum, product| sum + product["stock"] }
  end

  def brand_total_purchases(brand)
    brand
      .map { |brand| brand["purchases"] }
      .flatten
      .size
  end

  def brand_total_revenue(brand)
    brand
      .map { |brand| brand["purchases"] }
      .flatten
      .inject(0) { |sum, purchase| sum + purchase["price"] }
      .round(2)
  end
end
