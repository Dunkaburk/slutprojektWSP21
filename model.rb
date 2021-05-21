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

    def user_exists(name, username_list)
        i += 1
        if name == username_list[i]
            
        end
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

end







def ettan
    username = retrive_username
    {"username" => "#{username}"}
end


def tvan

end

def trean

end