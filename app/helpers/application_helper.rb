module ApplicationHelper
  class HTMLWithRouge < Redcarpet::Render::HTML
    def block_code(code, language)
      language ||= "plaintext"
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
      "<pre class=\"highlight\"><code>#{formatter.format(lexer.lex(code))}</code></pre>"
    end
  end

  def markdown(text)
    renderer = HTMLWithRouge.new(filter_html: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true, autolink: true, tables: true)
    markdown.render(text).html_safe
  end
end