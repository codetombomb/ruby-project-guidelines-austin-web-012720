require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'



PROMPT = TTY::Prompt.new
# TABLE = TTY::Table.new['header1', 'header2', 'header3', 'header4', 'header6',], [['a1', 'a2', 'a3','a4', 'a5'], ['b1', 'b2', 'b3','b4', 'b5'], ['c1', 'c2', 'c3','c4', 'c5'], ['d1', 'd2', 'd3','d4', 'd5'], ['e1', 'e2', 'e3','e4', 'e5']]

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
