require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'

enable :sessions


get ("/") do
    slim(:register)
end

get('/showlogin') do
    slim(:login)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    pw_confirm = params[:password_confirm]

    #register_user(username, password, pw_confirm)

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


post("/login") do
    username = params[:username]
    password = params[:password]
  
    db = SQLite3::Database.new("db/todo.db")  
    db.results_as_hash = true
    result = db.execute("SELECT * FROM students WHERE username = ?", username).first
    p result
    pwdigest = result["pwdigest"]
    id = result["id"]
    
    if BCrypt::Password.new(pwdigest) == password
      session[:id] = id
      redirect("/schedule")
  
    else
      "Lösenord eller användarnamn stämmer ej"
  
    end
end