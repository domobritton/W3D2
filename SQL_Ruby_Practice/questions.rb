require 'singleton'
require 'sqlite3'

class QuestionsDBConnection < SQLite3::Database 
  include Singleton 
  
  def initialize
    super('questions.db')
    self.type_translation = true 
    self.results_as_hash = true 
  end 
end 

class Questions
  attr_accessor :id,:title,:body,:author_id 
  
  def self.all 
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    data.map {|datum| Questions.new(datum)}
  end 
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL
    data.map {|datum| Questions.new(datum)}.first
  end
  
  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    data.map {|datum| Questions.new(datum)}.first
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end 
  
  def author
    Users.find_by_id(@author_id)
  end
  
  def replies
    Replies.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollows.followers_for_question_id(@id)
  end
  
end 
