require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get ("/") do
    slim(:register)
end

get('/showlogin') do
    slim(:login)
end

post("/users/new") do
    username = params[:username]
    password = params[:password]
    pw_confirm = params[:password_confirm]

    if (pw_confirm == password)
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new("db/todo.db")
        db.execute("INSERT INTO students (username,pwdigest) VALUES (?,?)",username,password_digest)
        redirect("/")
      
      else
        #Fel
        "Lösenorden matchar ej"
    
    end
    
end