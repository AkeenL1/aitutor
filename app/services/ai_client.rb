INITIALIZE_PROMPT = """
You are a technical computer science tutor who creates tailored lesson plans.
When given a course topic, generate a lesson plan with two parts:
1. Sections: Divide the course into up to 14 sections.
2. Lessons: For each section, list 4 to 10 lesson titles.
Only output the titles (do not include lesson content).
If projects or exercises are requested, integrate them within the lessons and at the end of each section there should be some project or lessons to test the users knowledge on the topics discussed.
"""

INFO_PROMPT = """
You will receive the following information:
1. The course topic.
2. The difficulty level: beginner, intermediate, or advanced.
3. User info describing the course goals.
4. Additional details (e.g., learning preferences, reference materials).

Tailor the lesson plan by adapting the content based on the difficulty level:
- **Beginner:** Emphasize clear explanations, foundational context, and accessible terminology.
- **Intermediate:** Combine core concepts with deeper exploration and practical applications.
- **Advanced:** Focus on sophisticated, less common topics, and assume strong prior knowledge.

Use all these inputs to create a lesson plan that aligns with the user’s needs.
"""


FORMAT_PROMPT = """
Return a hash where each key is a section title, and its value is an array of lesson titles.
Limit the output to exactly 7 sections, with each section containing 4 to 10 lesson titles.
Output only the hash; no extra formatting or tagging is allowed.
"""


class AiClient
  def initialize(key: ENV.fetch("OPENAI_KEY"))
    @key = key
    @client = OpenAI::Client.new(
      access_token: key,
      log_errors: true
    )
  end

  def generate_course(title, level, user_info, additional_info)
    retries = 2
    begin
      course_prompt = "1. Topic: #{title}. 2. Level: #{level}. 3. User Information: #{user_info}. 4. Additional Info: #{additional_info}"
      response = @client.chat(
        parameters: {
          model: "o3-mini", # Required.
          messages: [{ role: "user",
                       content: INITIALIZE_PROMPT + INFO_PROMPT + FORMAT_PROMPT + "Here is the information to build the lesson plan" + course_prompt
                     }]
        }
      )
      #puts response
      #puts response.dig("choices", 0, "message", "content")
      return JSON.parse(response.dig("choices", 0, "message", "content")).transform_keys(&:to_sym)
    rescue => e
      if retries > 0
        retries -= 1
        sleep 1  # wait 1 second before retrying
        retry
      else
        pp e.message
        raise e
      end
    end

  end

  def generate_lesson(course_title, course_level, course_goal, section_title, lesson_title)
    prompt = """
You are an expert computer science tutor who designs lesson plans tailored to students' needs.
You are provided with:
- The course topic and overall goals.
- A difficulty level: beginner, intermediate, or advanced.
- The title of the course section and the lesson to generate.

Generate a well-formatted, in-depth markdown guide for the lesson using the provided context.
Adjust the content based on the difficulty level:
- **Beginner:** Cover core fundamentals with clear, simple explanations.
- **Intermediate:** Introduce essential concepts with moderate complexity.
- **Advanced:** Focus on sophisticated, less common topics, skipping basic explanations.

If the lesson is a project, detail the project requirements and description. Otherwise, conclude with small exercises or mini-projects to reinforce learning.
ONLY generate the guide for the given lesson using the provided context.
"""
    response = @client.chat(
      parameters: {
        model: "o3-mini", # Required.
        messages: [{ role: "user",
                     content: prompt + "Course Topic: #{course_title}, Course Level: #{course_level},
                    Course Goal: #{course_goal}, Section Title: #{section_title}, Lesson Title: #{lesson_title},"
                   }]
      }
    )
    puts response.dig("choices", 0, "message", "content")
    return (response.dig("choices", 0, "message", "content"))
  end
end
