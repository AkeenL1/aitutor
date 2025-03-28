INITIALIZE_PROMPT = "You are a deeply technical computer science tutor who is great at putting together lesson plans tailored for students
You will be given a topic and should generate the lesson plan according to the following spec. Each plan has two parts 1. The sections, there are how the lesson plan
is broken up into chunks. You should generate no more than 14 sections for any given lesson plan. 2. The lessons themselves, these will be what actually contains the information being taught
you should generate at least 4 but no more than 10 lessons for each section.You should not generate any of the content of the lesson plans only titles of the sections and lessons.
Even if the User asks for projects Any projects or exercises should be incorporated into the lessons. There should not be any stand alone sections with only projects. If the user does ask for projects THERE MUST BE PROJECTS"

INFO_PROMPT = "To generate the lesson plan tailored for the specific user you will be given this information. 1. The topic of the lesson plan to generate 2. The level of difficulty
the lesson plan should be this will either beginner, intermediate, or advanced. 3. User info, this describes why the user is generating this course and what they want to gain from it
4. Any additional info, such as the users learning preferences, references they'd like etc. You should take all 4 of these into account when generating the lesson plan"

FORMAT_PROMPT = " The output should be a hash each key in the hash is a section title and points to an array this array contains the titles of the specific lessons remember only 7 sections and 4-10 lessons per section. Simply return the hash itself, no json coding or tagging. The output will be parsed by a ruby program"

class AiClient
  def initialize(key: ENV.fetch("OPENAI_KEY"))
    @key = key
    @client = OpenAI::Client.new(
      access_token: key,
      log_errors: true
    )
  end

  def generate_course(title, level, user_info, additional_info)
    course_prompt = "1. Topic: #{title}. 2. Level: #{level}. 3. User Information: #{user_info}. 4. Additional Info: #{additional_info}"
    response = @client.chat(
      parameters: {
        model: "gpt-4o", # Required.
        messages: [{ role: "user",
                     content: INITIALIZE_PROMPT + INFO_PROMPT + FORMAT_PROMPT + "Here is the information to build the lesson plan" + course_prompt
                   }], # Required.
        temperature: 0.2,
      }
    )
    #puts response
    #puts response.dig("choices", 0, "message", "content")

    return JSON.parse(response.dig("choices", 0, "message", "content")).transform_keys(&:to_sym)
  end

  def generate_lesson(course_title, course_level, course_goal, section_title, lesson_title)
    prompt = "You are a deeply technical computer science tutor who is great at putting together lesson plans tailored for students.
A course plan with specific sections and lessons has been generated already by an equally technical tutor.
You are being given the topic of the course, the level of difficulty the course should be, either beginner, intermediate, or advanced.
You will also be given the title of the section this lesson falls under and the title of the lesson you should generate.
You should give me a well formated verbose and in depth guide about the lesson given using the course topic and section title as context.
You will also be given the users goals with the course overall and should take this into account when generating the specific lesson.
ONLY GENERATE the guide for the lesson given using the context provided. It's possible the lesson you are being asked to generate is a project, in this case you should give the project details and description with the same level of depth and explanation you would a lesson.
If the lesson you are being asked to generate is not a project you should have some SMALL exercises or mini projects at the end of each lesson for the user to test their understanding. Of course this is only when applicable
You should generate everything using markdown
"
    response = @client.chat(
      parameters: {
        model: "gpt-4o", # Required.
        messages: [{ role: "user",
                     content: prompt + "Course Topic: #{course_title}, Course Level: #{course_level},
                    Course Goal: #{course_goal}, Section Title: #{section_title}, Lesson Title: #{lesson_title},"
                   }], # Required.
        temperature: 0.2,
      }
    )
    puts response.dig("choices", 0, "message", "content")
    return (response.dig("choices", 0, "message", "content"))
  end
end
