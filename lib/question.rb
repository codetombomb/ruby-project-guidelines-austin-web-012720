class Question < ActiveRecord::Base
    has_many :user_questions
    has_many :users, through: :user_question


    def self.get_category_questions
      response = RestClient.get 'http://jservice.io/api/random?count=50'
      parsed_response = JSON.parse(response.body)

      parsed_response.each do |question|
        new_question = self.find_or_create_by(question: question["question"])
        new_question.answer = question["answer"]
        if question["value"] == nil 
          new_question.value = 100 
        else 
          new_question.value = question["value"]
        end
        new_question.category = question["category"]["title"]
        #Some of the values are nil so we need to assign an optional value
        new_question.save
      end 
    end
  

end