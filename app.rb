require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative 'model'
require_relative 'helpers'

enable :sessions

include Model # Wat dis?
include Helpers

before do
  unless session[:logged_in] 
    return if request.path_info == "/users/new" || request.path_info == "/" || request.path_info == "/showlogin" || request.path_info == "/login" 
    redirect("/")
  end
end

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
    slim(:"users/register", locals:{klasser:classes})
end

#--------REDIRECT-TO-LOGIN---------------
# Displays login form
get('/showlogin') do
    slim(:"users/login")
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
    return "Username unavailible" if user_exists(username)
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
# @see Model#user_exists
# @see Model#encrypt_password
post("/login") do
    username = retrive_username
    password = retrive_password
    if (username == "") || (password == "")  #Checks if either password or username is nil
      "Please enter a valid username and password"
      redirect("/showlogin")
    end
    db = connect_to_db  
    db.results_as_hash = true
    return "User does not exist" unless user_exists(username) #Checks if user exists
    pwdigest = get_pw_digest(username)
    id = get_student_id(username)

    if encrypt_password(pwdigest) == password
      session[:id] = id
      

      if id == 13
          session[:admin] = true
        else
          session[:admin] = false
      end


      session[:logged_in] = true
      p session[:logged_in]
      redirect("/schedule")

  
      
    else
      "Password or username incorrect"
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
# Updates the chosen schedule based on choices in the form
#
# @see Model#get_old_content
# @see Model#get_new_content
# @see Model#connect_to_db
# @see Model#get_id_from_content
# @see Model#update_schedule
post("/schedule/:schedule_id/edit") do |schedule_id|
  old_value = get_old_content
  new_value = get_new_content

  db = connect_to_db
  old_value_id = get_id_from_content(old_value)
  update_schedule(new_value, schedule_id, old_value_id)
  redirect("/schedule")
end

# Displays schedule editing form 
#
# @see Model#connect_to_db
# @see Model#get_3a_schedule
# @see Model#get_3b_schedule
# @see Model#get_3c_schedule
# @see Model#get_all_lessons
get("/edit") do
  db = connect_to_db
  db.results_as_hash = true
  slim(:"administrator/edit", locals:{a_klassen:get_3a_schedule, b_klassen:get_3b_schedule, c_klassen:get_3c_schedule, lektioner:get_all_lessons})
end

# Deletes chosen user
#
# @see Model#connect_to_db
# @see Model#retrive_username
# @see Model#delete_user

post("/delete_student") do
  db = connect_to_db
  username = retrive_username
  delete_user(username)
  redirect("/schedule")
end