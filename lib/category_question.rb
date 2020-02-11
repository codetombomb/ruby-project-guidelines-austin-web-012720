class CategoryQuestion < ActiveRecord::Base
    belongs_to :category

    def self.get_category_questions
      response = RestClient.get 'http://jservice.io/api/random?count=8'
      parsed_response = JSON.parse(response.body)
      parsed_response.each do |question|
        
        new_question = CategoryQuestion.find_or_create_by(question: category["question"])

        new_question.answer = CategoryQuestion.find_or_create_by(answer: category["answer"])
        new_value = CategoryQuestion.find_or_create_by(value: category["value"])
        
        
      end 
    end
    #to access question category["question"]
    #to access answer category["answer"]
    #to access value category["value"]
    #to access api_id question["category"]["id"]

end