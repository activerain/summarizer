module SummarizerHelper
  # Reduces a fragment of html to a few words of text.  Intended for short post
  # summaries.  It's not perfect, but better than the truncate method used
  # in the rest of the Rails world.
  # 
  #   summarizer(%{[...lots of rough html...]})
  #   # => "[first few sentences of that html]"
  #
  def summarizer(text, characters=250)
    plain_text = strip_tags(add_spaces_after_closing_tags(text)). # strip out html
      gsub("&nbsp;", " ").squeeze(" ")                            # replace manual spaces with regular spaces

    truncate_characters(plain_text, characters).      # truncate to a reasonable blurb length
      gsub(/([\?\!\.\,]+)/, '\1 ').         # add a space after stop characters
      gsub(/\s+[\,\;\?\!\.]/, '\1').        # remove spaces from before hugging punctuation
      gsub(/\.{3,}/, '&hellip;').           # convert three+ periods to elipsis
      gsub(/active\s*rain/i, 'ActiveRain'). # pure narcissism
      squish                                # replace multiple spaces with single spaces
  end

  # One of the problems with strip_tags is that it converts this: "<p>I like pie</p><p>Yes, I do</p>" 
  # to this: "I like pieYes, I do".  This helper inserts a space after all closing tags.
  #
  #   strip_tags(add_spaces_after_closing_tags("<p>I like pie</p><p>Yes, I do</p>"))
  #   # => "I like pie Yes, I do"
  #
  def add_spaces_after_closing_tags(text)
    text.gsub(/(\/.*?\>)/, '\1 ')
  end

  # Truncates a fragment of text to the specified number of sentences.
  #
  #   truncate_sentences("This is my sentence!  Here's sentence two.")
  #   # => "This is my sentence!"
  #
  def truncate_sentences(text, limit=3)
    text.scan(/.*?[.!?]|.*?$/m).first(limit).join + "... (continued)"
  end

  # Truncates a fragment of text to the specified number of characters,
  # then backs up to the nearest word boundary and appends "..."
  #
  #   truncate_characters("Crikey mate", 10)
  #   # => "Crikey..."
  #
  def truncate_characters(text, limit=250)
    text.first(limit)[/^(.*)\W.*$/m,1] + "..."
  end
end

