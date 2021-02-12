require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions


def connect_to_db
    db = SQLite3::Database.new("db/schema.db")
end

def register_user(username, password, password_confirm)
    if (pw_confirm == password)
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new("db/schema.db")
        db.execute("INSERT INTO students (username,pwdigest) VALUES (?,?)",username,password_digest)
        redirect("/login")
    
    else
        #Fel
        "Lösenorden matchar ej"
    
    end
    
end

def log_in(username, password)

end