require_relative 'questions.rb'
class Replies 
  attr_accessor :id,:body, :question_id, :author_id, :parent_id
  
  def self.all 
    data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    data.map {|datum| Replies.new(datum)}
  end 
  
  def self.find_by_user_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,author_id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?
    SQL
    data.map {|datum| Replies.new(datum)}.first
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    data.map {|datum| Replies.new(datum)}
  end
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    data.map {|datum| Replies.new(datum)}.first 
  end
  
  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @author_id = options['author_id']
    @parent_id = options['parent_id']
  end
  
  def author
    Users.find_by_id(@author_id)
  end
  
  def question
    Questions.find_by_id(@question_id)
  end
  
  def parent_reply
    Replies.find_by_id(@parent_id)
  end
  
  def child_replies
    question.replies.map {|reply| reply if reply.parent_id == @id}
  end
  
end 