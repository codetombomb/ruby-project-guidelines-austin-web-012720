class User < ActiveRecord::Base
    has_many :user_questions
    has_many :questions, through: :user_questions

    def self.create_user
        puts "\n" * 35
        Views.banner_jeopardy
        new_user = User.get_username
        new_user.password = User.set_password
        new_user.save
        new_user
    end

    def self.get_username
        given_username = PROMPT.ask("What do you want your new User Name to be?", required: true)
        confirm_username = PROMPT.yes?("#{given_username.light_green.bold} is what you entered. Are you sure?") do |q|
          q.suffix 'Y/N'
        end
        if confirm_username
           if User.find_by(username: given_username) == nil
                User.create(username: given_username)           
            else
                puts "#{given_username.light_red.bold} is already taken. Please choose a different username."
                 self.get_username 
            end
        else 
            self.get_username
        end
    end

    def self.set_password
        given_password = PROMPT.mask("Please enter your password".light_yellow, required: true) do |q|
        q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
        q.messages[:valid?] = 'Your password must be at least 6 characters and include one number and one letter'
      end        
        confirm_password = PROMPT.mask("Please confirm password".light_green, required: true)
        if given_password == confirm_password
            puts "\n" * 35
            given_password
        else
            puts "\n" * 35
            puts "Those didn't match. Please try again!".light_red
            self.set_password
        end
    end  

end