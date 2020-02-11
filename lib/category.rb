class Category < ActiveRecord::Base
    has_many :user_categories 
    has_many :users, through: :user_categories
    has_many :category_questions

    def self.get_category
      response = RestClient.get 'http://jservice.io/api/categories?count=8'
      parsed_response = JSON.parse(response.body)
      parsed_response.each do |category|
        new_category = Category.find_or_create_by(api_id: category["id"])
        new_category.category_name = category["title"]
        new_category.save
      end 
      #needs to return an array of category objects   
    end

    
end