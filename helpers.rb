module Helpers 

    def get_schedule_from_class_name(class_name)
        db = connect_to_db  
        db.results_as_hash = true
        return db.execute("SELECT lesson.content FROM students join klass on klass.id = students.class_id join schedule_lesson_rel on schedule_lesson_rel.schedule_id = klass.id join lesson on lesson.id = schedule_lesson_rel.lesson_id WHERE students.id = ?", class_name)
    end

    def hello_world
        return "hello worlddddd"
    end
end