require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'

enable :sessions


get ("/") do
    p "Register load"
    db = connect_to_db
    db.results_as_hash = true
    classes = get_classes
    p classes
    slim(:register, locals:{klasser:classes})
end

get('/showlogin') do
    slim(:login)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    class_name = params[:classroom]
    pw_confirm = params[:password_confirm]
    db = connect_to_db
    class_id = db.execute("SELECT id FROM klass WHERE class_name = #{"?"}",class_name)
    p class_name

    #register_user(username, password, pw_confirm)

    if (pw_confirm == password)
        password_digest = BCrypt::Password.create(password)
        db.execute("INSERT INTO students (username,pwdigest,class_id) VALUES (?,?, ?)",username,password_digest,class_id)
        redirect("/showlogin")
      
      else
        #Fel
        "Lösenorden matchar ej"
    
    end
    
end


post("/login") do
    username = params[:username]
    password = params[:password]
  
    db = SQLite3::Database.new("db/schema.db")  
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


get("/schedule") do
    id = session[:id].to_i
    db = SQLite3::Database.new("db/schema.db")  
    db.results_as_hash = true
    result = db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = ?", id)
    p "Visar ditt schema #{result}"
    slim(:"schedule/index", locals:{scheman:result})
end