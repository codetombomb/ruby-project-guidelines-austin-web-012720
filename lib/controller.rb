require 'ruby2d'
# require 'japi'


class Jeopardy

    @@score = 0
    
        def intro
        @think_song = Music.new('Jeopardy-theme-song.mp3')
        @think_song.play
        Views.banner_jeopardy
        Jeopardy.greeting
    end

    def self.greeting
        yes_or_no = PROMPT.yes?("Welcome to Jeopardy! Are you a new user?")
        if yes_or_no
            @@current_user = User.create_user
            Jeopardy.about
        else
            test = Jeopardy.login
            # should be returning the @current user
            Jeopardy.main_menu
        end
    end

    def self.main_menu
        puts "\n" *35
        Views.banner_jeopardy
        selection = PROMPT.select("",%w(Play Study Return_to_Main))
        case selection
        when "Play"
            Jeopardy.about
        when "Study"
            UserQuestion.study(@@current_user)
            
        else
            Jeopardy.greeting
        end

    end

    def self.about
        Views.banner_jeopardy
        print "Johnny Gilbert:".light_yellow
        puts"And now, here is the host of Jeopardy; Alex Trebek!"
        puts "\n" * 5
        sleep(4)
        print "Trebek:".light_green
        puts "Jeopardy Lite will get you ready for your Jeopardy debut."
        puts "\n" * 5
        sleep(4)
        puts "Each incorrect response will be saved to your account for you to study."
        puts "\n" * 5
        sleep(4)
        puts "You will have one minute in Jeopardy and the Double Jeopardy rounds to answer questions."
        puts "\n" * 5
        sleep(5)
        puts "On the Final Jeopardy round, you can place your wager and you will be given 30 seconds to guess the correct answer."
        Views.banner_jeopardy
        ready = PROMPT.yes?("The time will start now. Are you ready?")
        if ready 
            Jeopardy.select_category
        else
            Jeopardy.main_menu
        end
    end


    def self.login
        login_or_exit = PROMPT.select("", %w(Login Exit Delete_unusable_categories))
        case login_or_exit
        when "Login"
            self.find_user
            self.enter_password
        when "Exit"
            Views.banner_exit
            sleep(3)
          exit     
        else "Delete_unusable_categories"
            Question.check_category_length             
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
        random_selection = Question.all.sample(6)
        category_strings = random_selection.map{|cat| cat.category}
        selection = PROMPT.select("Select a category", category_strings)
        questions = Question.all.select {|question| question.category == selection}
        case selection
        when category_strings[0]
            # binding.pry
            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                binding.pry
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end
            # binding.pry
        when category_strings[1]


            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end        
        when category_strings[2]

            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end
        when category_strings[3]
            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end
        when category_strings[4]
            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end
        else category_strings[5]

            value = Views.select_value.to_i
            if questions.find {|q| q.value == value} == nil
                user_question = questions.first
            else
                user_question = questions.find {|q| q.value == value}
            end
             answer = Views.display_question(user_question,questions,value)
             if answer == user_question.answer
                @@score += value
                print "Trebek:".light_green
                puts "That is correct"
                puts "Your score: #{@@score}"
                # binding.pry
             else
                @@score -= value 
                print "Trebek:".light_green
                print "That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "Your score: #{@@score}"
                # binding.pry

             end
        end
        # binding.pry
    end




end