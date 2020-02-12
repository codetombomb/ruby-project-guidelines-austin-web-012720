class UserQuestion < ActiveRecord::Base
    belongs_to :user 
    belongs_to :question 

    def self.study(user)
        categories = user.questions.map {|q| q.category}
        selection = PROMPT.select("These are the categories you need to study.  Please make a selection", categories)
        questions = user.questions.select {|q| q.category == selection}.map {|q| q.question}
        select_question = PROMPT.select("Select to see answer", questions, %w(Exit))
        if select_question != "Exit"
          answer = Question.find_by(question: select_question).answer
          print "What is:".light_green 
          puts "#{answer}"
          puts "\n" * 10
          self.study(user)
        else
            Jeopardy.main_menu
        end
    end
end