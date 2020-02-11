class User < ActiveRecord::Base
    has_many :user_categories
    has_many :categories, through: :user_categories  
    

    def create_user
        #Ask user to enter a name and a password 
        #check to see that it is not already in the database
        #
    end

    def find_user
        #Prompts user to enter their username and verifies password
    end



end