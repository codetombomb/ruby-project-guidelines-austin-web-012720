require 'ruby2d'


class Jeopardy
    
    def intro
        @think_song = Music.new('Jeopardy-theme-song.mp3')
        @think_song.play
        Views.banner_jeopardy
        Jeopardy.main
    end

    def self.main
        yes_or_no = PROMPT.yes?("Welcome to Jeopardy! Are you a new user?")
        if yes_or_no
            @@current_user = User.create_user
            Jeopardy.select_category
        else
            test = Jeopardy.login
            # should be returning the @current user
            Jeopardy.select_category
        end
    end

    def self.login
        login_or_exit = PROMPT.select("", %w(Login Exit))
        case login_or_exit
        when "Login"
            self.find_user
            self.enter_password
        else "Exit"
          puts "Thank you for playing."
          exit                  
        end       
    end

    def self.find_user
        puts "\n" * 35
        find_user = PROMPT.ask("What is your username?".light_cyan, required: true)
        @@current_user = User.find_by(username: find_user)
        if @@current_user == nil
            puts "User not found".light_red
            puts "Please try again!"
            self.login
        end
    end

    def self.enter_password
        enter_password = PROMPT.mask('password:', echo: true,required: true)
        if enter_password == @@current_user.password
            # binding.pry
            @@current_user
        else
            puts "\n" * 35
            puts "Trebek: That was an incorrect response.".light_red
            puts "Please try again!".light_yellow
            # binding.pry
            self.enter_password
        end
    end

    def self.select_category
        puts "\n" * 35
        Views.select_category_banner
        new_category_questions = Question.get_category_questions
        random_selection = Question.all.sample(6)
        category_strings = random_selection.map{|cat| cat.category}
        
        selection = PROMPT.select("Select a category", category_strings)

        case selection
        when category_strings[0]
            puts "#{category_strings[0]}"
        when category_strings[1]
            puts "#{category_strings[1]}"
        when category_strings[2]
            puts "#{category_strings[2]}"
        when category_strings[3]
            puts "#{category_strings[3]}"
        when category_strings[4]
            puts "#{category_strings[4]}"
        else category_strings[5]
            puts "#{category_strings[5]}"
        end
        binding.pry
    end


end