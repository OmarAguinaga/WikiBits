module WikisHelper
  def user_is_authorized_for_wiki?(wiki)
    current_user && (current_user == wiki.user || current_user.admin?)
  end
  
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer:language)
    end
  end
  
  
  def markdown(content)
    render = HTMLwithPygments.new(hard_wrap: true, filter_HTML: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(render, options).render(content).html_safe
  end
end
