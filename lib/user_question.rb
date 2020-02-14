class UserQuestion < ActiveRecord::Base
    belongs_to :user 
    belongs_to :question 

    def self.study(user)
        categories = user.questions.map {|q| q.category}
        if categories.length == 0
            print "Trebek:".light_green 
            print " You do not have any questions to study."
            puts "\n" * 4
            sleep(3)
            Jeopardy.main_menu
        end
        # binding.pry
        selection = PROMPT.select("These are the categories you need to study.  Please make a selection or scroll down to exit to the main menu.\n", categories, %w(Exit_To_Main))
        puts "\n" * 8
        if selection == "Exit_To_Main"
            Jeopardy.main_menu
        end
        questions = user.questions.select {|q| q.category == selection}.map {|q| q.question}
        select_question = PROMPT.select("Select to see answer", questions, %w(Exit))
        puts "\n" * 35
        if select_question != "Exit"
          answer = Question.find_by(question: select_question).answer
          print "What is:".light_green 
          puts " #{answer}"
          puts "\n" * 10
          sleep(3)
          puts "\n" * 35
          self.study(user)
        else
            Jeopardy.main_menu
        end
    end

end