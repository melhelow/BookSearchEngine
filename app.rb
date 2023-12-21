require "sinatra"
require "sinatra/reloader"
require "httparty"
require "json"



get("/") do
  erb(:info_prompt)
  end
  
  get("/results") do
    @book_name = params.fetch("book_name")

    secret_key = ENV.fetch("BOOK_SEARCH_ENGINE")
    api_url = "https://www.googleapis.com/books/v1/volumes?q=#{@book_name}&maxResults=10&key=#{secret_key}"

    raw_response = HTTParty.get(api_url)
  
    raw_data_string = raw_response.to_s
    
    parsed_response = JSON.parse(raw_data_string)

    @books = parsed_response["items"].map do |item|
      volume_info = item.fetch("volumeInfo")
      {
        :title => volume_info.fetch("title"),
        :author => volume_info["authors"] ? volume_info["authors"].at(0) : "Unknown Author",
        :description => volume_info.fetch("description", "No description available."),
        :page_count => volume_info.fetch("pageCount", "Page count not available."),
        :thumbnail => volume_info.fetch("imageLinks", {}).fetch("thumbnail", "No thumbnail available."),
        :preview => volume_info.fetch("previewLink", "#")
      }
    end
    #sales = parsed_response["items"].at(2)
    #sales_info = sales.fetch("saleInfo")
    #list_price = sales_info.fetch("listPrice")
    #@book_price = list_price.fetch("amount")
   # @curruncy = list_price.fetch("currencyCode")

    erb(:results)
  end
  