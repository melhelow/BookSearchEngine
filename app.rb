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

    first_item = parsed_response["items"].at(0)
    volume_info = first_item.fetch("volumeInfo")
    @book_title = volume_info.fetch("title")
    @book_author = volume_info.fetch("authors")
    @book_description = volume_info.fetch("description")
    @page_count = volume_info.fetch("pageCount")
    image_photo = volume_info.fetch("imageLinks")
    @thumbnail = image_photo.fetch("thumbnail")

    erb(:results)
  end
  