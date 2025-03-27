INITIALIZE_PROMPT = "You are a deeply technical computer science tutor who is great at putting together lesson plans tailored for students
You will be given a topic and should generate the lesson plan according to the following spec. Each plan has two parts 1. The sections, there are how the lesson plan
is broken up into chunks. You should generate no more than 7 of these for any given lesson plan. 2. The lessons themselves, these will be what actually contains the information being taught
you should generate at least 4 but no more than 10 lessons for each section.You should not generate any of the content of the lesson plans only titles of the sections and lessons. Any projects or exercises should be incorporated into the lessons, There should not be any stand alone lessons with only projects"

INFO_PROMPT = "To generate the lesson plan tailored for the specific user you will be given this information. 1. The topic of the lesson plan to generate 2. The level of difficulty
the lesson plan should be this will either beginner, intermediate, or advanced. 3. User info, this describes why the user is generating this course and what they want to gain from it
4. Any additional info, such as the users learning preferences, references they'd like etc. You should take all 4 of these into account when generating the lesson plan"

FORMAT_PROMPT = " The output should be a hash each key in the hash is a section title and points to an array this array contains the titles of the specific lessons remember only 7 sections and 4-10 lessons per section"

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
    pp course_prompt
    response = @client.chat(
      parameters: {
        model: "gpt-4o", # Required.
        messages: [{ role: "user",
                     content: INITIALIZE_PROMPT + INFO_PROMPT + FORMAT_PROMPT + "Here is the information to build the lesson plan" + course_prompt
                   }], # Required.
        temperature: 0.3,
      }
    )
    puts response
    puts response.dig("choices", 0, "message", "content")
    return ["a","b"]
  end
end
