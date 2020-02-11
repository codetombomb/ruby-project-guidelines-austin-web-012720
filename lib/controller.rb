class Jeopardy
    
    def intro
        self.banner_jeopardy
        yes_or_no = PROMPT.yes?("Welcome to Jeopardy! Are you a new user?")
            if yes_or_no
                User.create_user
            else
                User.find_user
            end
    end
    def banner_jeopardy 
        puts "\n" * 35
        puts "
                                 ██╗███████╗ ██████╗ ██████╗  █████╗ ██████╗ ██████╗ ██╗   ██╗██╗
                                 ██║██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██║
                                 ██║█████╗  ██║   ██║██████╔╝███████║██████╔╝██║  ██║ ╚████╔╝ ██║
                            ██   ██║██╔══╝  ██║   ██║██╔═══╝ ██╔══██║██╔══██╗██║  ██║  ╚██╔╝  ╚═╝
                            ╚█████╔╝███████╗╚██████╔╝██║     ██║  ██║██║  ██║██████╔╝   ██║   ██╗
                             ╚════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝
        ".light_cyan
        puts "\n" * 12

    end

end