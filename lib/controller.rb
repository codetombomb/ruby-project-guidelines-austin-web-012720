require 'ruby2d'
require 'eventmachine'

class Jeopardy

    @@score = 0
    @@double_jeopardy = false 

    def intro
        Views.banner_jeopardy
        Jeopardy.greeting
    end

    def self.greeting
        yes_or_no = PROMPT.yes?("Are you a new user?")
        puts "\n" * 35
        if yes_or_no
            @@current_user = User.create_user
            self.main_menu
        else
            self.login
            self.main_menu
        end
    end

    
    def self.main_menu
        puts "\n" * 35
        Views.banner_jeopardy        
        print "My high score:".light_cyan
        User.check_user_highscore(@@current_user)
        puts "\n"
        print "Welcome to Jeopardy Lite" 
        puts " #{@@current_user.username}!".light_yellow.bold
        puts "\n" 
        self.make_a_selection
    end

    def self.make_a_selection
        selection = PROMPT.select("Please make a selection",%w(Play Study Top_Three Edit_My_Info Exit))
        case selection
        when "Play"
            self.about
        when "Study"
            self.study
        when "Top_Three"
            self.get_top_three
        when "Edit_My_Info"
            self.edit_my_info
        else 
            Views.banner_exit
            exit
        end
    end

    def self.study
        study_or_delete = PROMPT.select("", %w(Study Delete_All_Study_Questions))
        if study_or_delete == "Study"
            puts "\n" * 20
            Views.banner_jeopardy
            UserQuestion.study(@@current_user) 
        else
            are_you_sure = PROMPT.yes?('Are you sure you want to delete all?') do |q|
                q.suffix 'Y/N'
            end
            if are_you_sure
                @@current_user.questions.delete_all
                self.main_menu
            else
                self.main_menu
            end  
         end     
    end

    def self.get_top_three
        puts "\n" * 35
        highest_scores = User.order(high_score: :desc).first(3)
        Views.top_three
        highest_scores.each do |user|
            puts "*" * 36
            print "Username: ".light_yellow
            puts user.username
            print "Score:"
            puts user.high_score
            puts "*" * 36
        end 
        sleep(6)
        self.main_menu
    end

    def self.about
        Views.banner_jeopardy
        print "Johnny Gilbert: ".light_yellow
        puts"And now, here is the host of Jeopardy; Alex Trebek!"
        puts "\n" * 5
        sleep(4)
        print "Trebek: ".light_green
        puts "Thank you Johnny!"
        puts "\n" * 5
        sleep(2)
        print "Trebek: ".light_green
        puts "Jeopardy Lite will prepare you for your Jeopardy debut."
        puts "\n" * 5
        sleep(3)
        print "Trebek: ".light_green
        puts "You will have one minute in Jeopardy and the Double Jeopardy rounds to answer as many questions \nas you can while adding to your score."
        puts "\n" * 5
        sleep(6)
        print "Trebek: ".light_green
        puts "Each incorrect response will be saved to your account for you to study later."
        puts "\n" * 5
        sleep(4)
        print "Trebek: ".light_green
        puts "You will also be penalized 3 seconds for each incorrect response."
        puts "\n" * 5
        sleep(3)
        print "Trebek:".light_green
        puts "On the Final Jeopardy round, you can place your wager and go for the high score!"
        sleep(3)
        Views.banner_jeopardy
        ready = PROMPT.select("Press start to begin the Jeopardy Round", %w(Start Exit))
        if ready == "Start"
            puts "\n" * 35
            Views.jeopardy_round_banner
            self.jeopardy_round 
        else
            self.main_menu
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
            self.greeting           
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
            @@current_user
        else
            puts "\n" * 35
            puts "Trebek: That was an incorrect response.".light_red
            puts "Please try again!".light_yellow
            self.enter_password
        end
    end

    def self.edit_my_info
        puts "\n" * 35
        pick_an_edit = PROMPT.select("Change Username or Password?", %w(Username Password Back))
        case pick_an_edit
           when "Username"
                self.change_username
                self.main_menu
           when "Password"
                self.change_password
                puts "Your password was successfully changed"
                self.main_menu
           else "Back"
            self.main_menu
        end
    end

    def self.change_username
        given_username = PROMPT.ask("Alright #{@@current_user.username.light_green}, what do you want your new User Name to be?", required: true)
        confirm_username = PROMPT.yes?("#{given_username.light_green.bold} is what you entered. Are you sure?") do |q|
                q.suffix 'Y/N'
            end
        if confirm_username
            if User.find_by(username: given_username) == nil 
                @@current_user.username = nil   
                @@current_user.username = given_username
                @@current_user.save
            else
                puts "#{given_username.light_red.bold} is already taken. Please choose a different username."
                self.change_username
            end
        else 
            self.edit_my_info
        end
    end

    def self.change_password
        old_password = PROMPT.mask("Please enter your old password".light_yellow, required: true)
        if old_password == @@current_user.password
            new_password = PROMPT.mask("Please enter your new password".light_cyan, required: true) do |q|
            q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
            q.messages[:valid?] = 'Your passowrd must be at least 6 characters and include one number and one letter'
          end        
            confirm_password = PROMPT.mask("Please confirm your new password".light_green, required: true)
            if new_password == confirm_password
                puts "\n" * 35
                @@current_user.password = nil
                @@current_user.password = new_password
            else
                puts "\n" * 35
                puts "Those didn't match. Please try again!".light_red
                self.change_password
            end
        else
            puts "That was not right.".light_red
            puts "Please try again"
            self.change_password
        end 
    end

    def self.select_category
        random_selection = Question.all.sample(6)
        category_strings = random_selection.map{|cat| cat.category}
        selection = PROMPT.select("Select a category".light_yellow, category_strings)
        questions = Question.all.select {|question| question.category == selection}
        case selection
        when category_strings[0]
            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end
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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end
            
        when category_strings[1]
            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end

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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end        
        when category_strings[2]

            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end            
            
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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end
        when category_strings[3]
            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end
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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end
        when category_strings[4]
            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end
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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end
        else category_strings[5]

            if @@double_jeopardy
                value = Views.select_double_jeopardy_values.to_i
            else
                value = Views.select_value.to_i
            end
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
                puts "\n" * 5
                sleep(1)
                puts "\n" * 35
                puts "Your score: #{@@score}"
             else
                @@score -= value 
                study_question = UserQuestion.new(user: @@current_user, question: user_question)
                study_question.save
                print "Trebek:".light_green
                print " That is incorrect.".light_red
                puts "The correct response is #{user_question.answer}. "
                puts "\n" * 5
                sleep(3)
                puts "\n" * 35
                puts "Your score: #{@@score}"
                sleep(1)
             end
        end
    end

    def self.jeopardy_round
      self.timer
      self.display_info
    end


    def self.double_jeopardy
      puts "\n" * 20
      Views.double_jeopardy_banner
      @@double_jeopardy = true   
      self.timer
      @@double_jeopardy = false 
       if @@score <= 0 
            print "Trebek:".light_green
            puts "I'm sorry, your score does not qualify to advance to Final Jeopardy."
            sleep(5)
            self.player_stats
            self.main_menu
       end
      self.display_info_final_jeopardy
    end

    def self.make_wager
        wager = PROMPT.ask("How much would you like to wager?", required: true).to_i
        if wager <= @@score && wager > 0
            wager
        else
            puts "\n" * 3
            puts "Wager must not be greater than #{@@score} or less than 0.".light_yellow
            self.make_wager
        end
    end

    def self.final_jeopardy
      puts "\n" * 35
      Views.final_jeopardy_banner  
      @@final_clue = Question.all.sample
      puts "Your score: #{@@score}"
      print "Trebek:".light_green
      puts "Think carefully about this Final Jeopardy question."
      print "The category is" 
      puts " #{@@final_clue.category}".light_cyan.bold 
      wager = self.make_wager
      re = /<("[^"]*"|'[^']*'|[^'">])*>/
      final_selections = Question.all.select {|q| q.category == @@final_clue.category}.map {|q| q.answer}.each {|a| a.gsub!(re, '')}
      
      puts "\n" * 35 
      puts "Your wager: #{wager}"
      print "Category: ".light_yellow
      puts "#{@@final_clue.category}"
      puts "#{@@final_clue.question}"
      @think_song = Music.new('Jeopardy-theme-song.mp3')
      @think_song.play
      final_answer = PROMPT.select("What is:", final_selections)
      if final_answer == @@final_clue.answer
        puts "\n" * 3
        print "Trebek:".light_green
        puts "That is a correct response! Let's see what you'll add..."
        sleep(2)
        puts "Your wager: #{wager}"
        sleep(2)
        @@score += wager
      else
        puts "\n" * 3
        print "Trebek:".light_green
        puts "That is an incorrect response. Let's see what you'll lose..."
        sleep(2)
        puts "Your wager: #{wager}"
        sleep(2)
        @@score -= wager
      end
      puts "Your score for this game is #{@@score}"
      sleep(3)
      self.check_score
      self.player_stats
      self.main_menu
    end

    def self.player_stats
    puts "\n" * 35
    puts "Your high score is #{@@current_user.high_score}"
    puts "Thanks for playing #{@@current_user.username}"
    puts "\n" *  5 
    sleep(3)
    end

    def self.check_score
        if @@current_user.high_score < @@score 
            @@current_user.high_score = @@score
            @@current_user.save
        end
    end

    private

    def self.timer
        EM.run do
          EM.add_timer(60) do
            puts "The time is up."
            sleep(2)
            EM.stop_event_loop
          end
        
          EM.add_periodic_timer(1) do
            self.select_category
          end
        end
    
    end



    def self.display_info
      puts "\n" * 35
      Views.banner_jeopardy  
      puts "Your score is #{@@score}."
      selection = PROMPT.select("The points values will now be worth double. Are you ready for Double Jeopardy?", %w(Yes Exit))
      case selection
      when "Yes"
        self.double_jeopardy  
      else "Exit"
          self.main_menu                 
      end      
    end

    def self.display_info_final_jeopardy
        puts "\n" * 35
        Views.banner_jeopardy  
        puts "Your score is #{@@score}."
             selection = PROMPT.select("Press Start to begin Final Jeopardy", %w(Start Exit))
             case selection
             when "Start"
             self.final_jeopardy  
            else "Exit"
            self.main_menu               
        end    
    end
end
