require_relative 'questions.rb'
class QuestionLikes 
  attr_accessor :id,:user_id,:question_id
  
  def self.all 
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_likes')
    data.map {|datum| QuestionLikes.new(datum)}
  end 
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end 
end 