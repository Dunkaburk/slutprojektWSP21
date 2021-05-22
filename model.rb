require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

module Model

    def get_classes()
        db = connect_to_db
        db.results_as_hash = true
        classes = db.execute("SELECT class_name FROM klass")
        return classes 
    end

    def connect_to_db()
        SQLite3::Database.new("db/schema.db")
    end

    #------------------------REGISTER---------------------------

    def retrive_username()
        params[:username]
    end
    def retrive_password()
        params[:password]
    end
    def retrive_class_name()
        params[:classroom]
    end
    def retrive_password_confirm()
        params[:password_confirm]
    end

    def get_class_id(class_name)
        db = connect_to_db
        db.execute("SELECT id FROM klass WHERE class_name = #{"?"}",class_name)
    end

    def create_new_user (username, password, class_id)
        password_digest = BCrypt::Password.create(password)
        db = connect_to_db
        db.execute("INSERT INTO students (username,pwdigest,class_id) VALUES (?,?, ?)",username,password_digest,class_id)
    end

    def encrypt_password(user_password)
        BCrypt::Password.new(user_password)
    end

    #-----------------LOGIN---------------------

    def get_pw_digest(username)
        db = connect_to_db  
        db.results_as_hash = true
        result = db.execute("SELECT * FROM students WHERE username = ?", username).first
        return result["pwdigest"]
    end

    def get_student_id(username)
        db = connect_to_db  
        db.results_as_hash = true
        result = db.execute("SELECT * FROM students WHERE username = ?", username).first
        return result["id"]
    end

    def user_exists(name)
        db = connect_to_db
        db.results_as_hash = true
        db.execute("SELECT * FROM students WHERE username = ?", name).empty? ? false : true
    end 

    #-------------------INDEX----------------------
    def retrive_schedule(id)
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = ?", id)
    end

    def get_username_from_id(id)
        db = connect_to_db
        return db.execute("SELECT username FROM students WHERE id = ?", id).first
    end

    def get_student_list
        db = connect_to_db
        db.results_as_hash = true
        return db.execute("SELECT username FROM students")
    end



#----------CRUD-----------

    def get_3a_schedule
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = 30")
    end

    def get_3b_schedule
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = 31")
    end

    def get_3c_schedule
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = 29")
    end

    def get_all_lessons
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT * FROM lesson")
    end

    def update_schedule(new_value, schedule_id, old_value_id)
        db = connect_to_db
        db.execute("UPDATE schedule_lesson_rel SET lesson_id = ? WHERE schedule_id = ? AND lesson_id = ?", new_value, schedule_id.to_i, old_value_id)
    end

    def get_id_from_content(old_value)
        db = connect_to_db
        db.execute("SELECT id FROM lesson WHERE content = ?",old_value)
    end

    def get_old_content
        params[:old_value]
    end

    def get_new_content
        params[:new_value]
    end

    def delete_user(username)
        db = connect_to_db
        db.execute("DELETE FROM students WHERE username = ?",username)
    end

end



