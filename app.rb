require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'

enable :sessions

#--------REGISTER-INITIALIZE------------

get ("/") do
    p "Register load"
    db = connect_to_db
    db.results_as_hash = true
    classes = get_classes
    p classes
    slim(:register, locals:{klasser:classes})
end

#--------REDIRECT-TO-LOGIN---------------

get('/showlogin') do
    slim(:login)
end

#------------REGISTER---------------

post('/users/new') do
    username = retrive_username
    password = retrive_password
    class_name = retrive_class_name
    pw_confirm = retrive_password_confirm

    db = connect_to_db
    class_id = get_class_id(class_name)


    if (pw_confirm == password)
        create_new_user(username, password, class_id)
        redirect("/showlogin")
      
      else
        "Lösenorden matchar ej"
    
    end
    
end

#-----------------LOGIN--------------------

post("/login") do
    username = retrive_username
    password = retrive_password
  
    db = connect_to_db  
    db.results_as_hash = true
    pwdigest = get_pw_digest(username)
    id = get_student_id(username)
    
    if BCrypt::Password.new(pwdigest) == password
      session[:id] = id
      redirect("/schedule")
  
    else
      "Lösenord eller användarnamn stämmer ej"
    end
end

#-----------CONTENT----------

get("/schedule") do
    id = session[:id].to_i
    db = connect_to_db  
    db.results_as_hash = true
    result = retrive_schedule(id)
    p "Visar ditt schema #{result}"
    slim(:"schedule/index", locals:{scheman:result})
end