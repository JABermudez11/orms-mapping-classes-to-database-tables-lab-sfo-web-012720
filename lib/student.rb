class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id    
  end

  # creating the students table in db
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INT
      );
    SQL
    DB[:conn].execute(sql)
  end

  # deleting students table in db
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end

  # set student id in ruby by pulling from db
  def set_id
    sql = <<-SQL
      SELECT id FROM students
      ORDER BY id DESC
      LIMIT 1;
    SQL
    
    result = DB[:conn].execute(sql)
    @id = result[0][0]
  end

  # save information from ruby into db
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    
    DB[:conn].execute(sql, @name, @grade)
    set_id
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end 
