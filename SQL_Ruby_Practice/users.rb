require_relative 'questions.rb'
class Users
  attr_accessor :id,:fname,:lname
  
  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL,fname,lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    data.map {|datum| Users.new(datum)}.first 
  end
  
  def self.find_by_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,user_id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    data.map {|datum| Users.new(datum)}.first 
  end
  
  def self.all 
    data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    data.map {|datum| Users.new(datum)}
  end 
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end 
  
  # if joe joe has asked questions should return questions authored by joe joe
  def authored_questions
    Questions.find_by_author_id(@id)
  end
  
  def authored_replies 
    Replies.find_by_user_id(@id)
  end 
  
  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end
  
end 