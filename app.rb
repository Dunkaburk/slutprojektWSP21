require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative 'model'
require_relative 'helpers'

enable :sessions

include Model # Wat dis?
include Helpers

#--------REGISTER-INITIALIZE------------

# Display landing page
# Displays register form 
# 
# @see Model#connect_to_db
# @see Model#get_classes
get ("/") do
    p "Register load"
    db = connect_to_db
    db.results_as_hash = true
    classes = get_classes
    slim(:register, locals:{klasser:classes})
end

#--------REDIRECT-TO-LOGIN---------------
# Displays login form
get('/showlogin') do
    slim(:login)
end

#------------REGISTER---------------

# Creates new user and redirects to "/showlogin"
# @param [String] username, The registered Username
# @param [String] password, The registered Password
# @param [String] pw_confirm, A string identical to password used to confirm the password
# @param [String] class_name, The registered class
# 
# @see Model#retrive_username
# @see Model#retrive_password
# @see Model#retrive_class_name
# @see Model#retrive_password_confirm
# @see Model#connect_to_db
# @see Model#get_class_id
# @see Model#create_new_user
post('/users/new') do
    username = retrive_username
    password = retrive_password
    class_name = retrive_class_name
    pw_confirm = retrive_password_confirm

    db = connect_to_db
    class_id = get_class_id(class_name)
    db.results_as_hash = true
    student_exists = get_student_list.include?(username)
    if student_exists == true
      sleep(3)
      redirect("users/new")
    end
    if (pw_confirm == password) 
      if (username != "") && (password != "")
        create_new_user(username, password, class_id)
        redirect("/showlogin")
      else
        "Please enter a valid username and password"
      end

    else
        "Lösenorden matchar ej"
    
    end
    
end

#-----------------LOGIN--------------------
# Attempts to log in user and updates the session then redirects to "/schedule"
#
# @params [String] username, The username entered 
# @params [String] password, The password entered
#
# @see Model#retrive_username
# @see Model#retrive_password
# @see Model#connect_to_db
# @see Model#get_pw_digest
# @see Model#get_student_id
post("/login") do
    username = retrive_username
    password = retrive_password
    if (username == "") || (password == "")
      "Please enter a valid username and password"
      redirect("/showlogin")
    end
    db = connect_to_db  
    db.results_as_hash = true
    pwdigest = get_pw_digest(username)
    id = get_student_id(username)

    
  
    
    
    if encrypt_password(pwdigest) == password
      session[:id] = id
      

      if id == 13
        
        session[:admin] = true
      else
        session[:admin] = false
      end

        redirect("/schedule")
      
    else
      "Lösenord eller användarnamn stämmer ej"
    end
end

#-----------CONTENT----------
# Displays the current users schedule
#
# @see Model#connect_to_db
# @see Model#retrive_schedule
# @see Model#get_username_from_id
# @see Model#get_student_list
get("/schedule") do
    id = session[:id].to_i
    db = connect_to_db  
    db.results_as_hash = true
    result = retrive_schedule(id)
    current_user = get_username_from_id(id)
    student_list = get_student_list
    p "Visar #{current_user[0]} schema #{result}"
    slim(:"schedule/index", locals:{scheman:result, current_user:current_user, klass_lista:student_list})
end



#-----------CRUD------------
post("/schedule/:schedule_id/edit") do |schedule_id|
  old_value = params[:old_value]
  new_value = params[:new_value]

  p old_value

  p new_value

  db = connect_to_db
  old_value_id = db.execute("SELECT id FROM lesson WHERE content = ?",old_value)
  db.execute("UPDATE schedule_lesson_rel SET lesson_id = ? WHERE schedule_id = ? AND lesson_id = ?", new_value, schedule_id.to_i, old_value_id)
  redirect("/schedule")
end


get("/edit") do
  db = connect_to_db
  db.results_as_hash = true
  slim(:"edit", locals:{a_klassen:get_3a_schedule, b_klassen:get_3b_schedule, c_klassen:get_3c_schedule, lektioner:get_all_lessons})
end

post("/delete_student") do
  db = connect_to_db
  db.execute("DELETE FROM students WHERE username = ?", retrive_username)
  redirect("/schedule")
end