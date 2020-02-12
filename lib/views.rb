class Views 

    def self.banner_jeopardy 
        puts "\n" * 35
        puts "
                                 ██╗███████╗ ██████╗ ██████╗  █████╗ ██████╗ ██████╗ ██╗   ██╗██╗
                                 ██║██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██║
                                 ██║█████╗  ██║   ██║██████╔╝███████║██████╔╝██║  ██║ ╚████╔╝ ██║
                            ██   ██║██╔══╝  ██║   ██║██╔═══╝ ██╔══██║██╔══██╗██║  ██║  ╚██╔╝  ╚═╝
                            ╚█████╔╝███████╗╚██████╔╝██║     ██║  ██║██║  ██║██████╔╝   ██║   ██╗
                             ╚════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝
        ".light_blue
        puts "\n" * 12

    end

    def self.select_category_banner
        puts "
                  ██████╗ █████╗ ████████╗███████╗ ██████╗  ██████╗ ██████╗ ██╗███████╗███████╗
                 ██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔════╝ ██╔═══██╗██╔══██╗██║██╔════╝██╔════╝
                 ██║     ███████║   ██║   █████╗  ██║  ███╗██║   ██║██████╔╝██║█████╗  ███████╗
                 ██║     ██╔══██║   ██║   ██╔══╝  ██║   ██║██║   ██║██╔══██╗██║██╔══╝  ╚════██║
                 ╚██████╗██║  ██║   ██║   ███████╗╚██████╔╝╚██████╔╝██║  ██║██║███████╗███████║
                  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝ 
        ".light_blue
    end

    def self.select_value
        select_value = PROMPT.select("Select value", %w(100 200 600 800 1000 ))
    end

    def self.display_question(selected_question,question_list,clue_value)
        puts "\n" * 35
        print "Category:".light_yellow 
        puts"#{selected_question.category}"
        print "Trebek:".light_green 
        puts"For #{clue_value} dollars, #{selected_question.question}"
        puts "\n" * 3
        selections = question_list.map {|q| q.answer}.shuffle
        given_answer = PROMPT.select("What is:", selections)
        given_answer
    end


    

end