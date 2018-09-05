require_relative 'questions.rb'
class QuestionFollows 
  attr_accessor :id,:question_id,:users_id
  
  def self.all 
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_follows')
    data.map {|datum| QuestionFollows.new(datum)}
  end 
  
  def self.followed_questions_for_user_id(users_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,users_id)
    SELECT
      *
    FROM
      question_follows 
    JOIN 
      questions  
    ON
      question_follows.question_id = questions.id
    WHERE
      users_id = ?
    SQL
    raise "no followed questions" if data.empty?
    data.map {|datum| Questions.new(datum)}
  end
  
  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL,question_id)
    SELECT
      *
    FROM
      question_follows 
    JOIN 
      users  
    ON
      question_follows.users_id = users.id
    WHERE
      question_id = ?
    SQL
    raise "no followers :(" if data.empty?
    data.map {|datum| Users.new(datum)}
  end
  
  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL,n)
    SELECT
      question_id, COUNT(*)  -- COUNT(*) --questions, count(followers of that question)
    FROM 
      question_follows
    GROUP BY
      question_id
    ORDER BY COUNT(*) DESC LIMIT ?
    JOIN
      questions
    ON
      question_follows.question_id = questions.id
    SQL
    #data.map {|datum| QuestionFollows.new(datum)}
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @users_id = options['users_id']
  end
  
   

end 
