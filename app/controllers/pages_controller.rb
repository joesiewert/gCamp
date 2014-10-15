class PagesController < ApplicationController

  def index

    quote1 = Quote.new
    quote1.text = "Work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do."
    quote1.author = "-Steve Jobs"

    quote2 = Quote.new
    quote2.text = "When there's that moment of 'Wow, I'm not really sure I can do this,' and you push through those moments, that's when you have a breakthrough."
    quote2.author = "-Marissa Mayer"

    quote3 = Quote.new
    quote3.text = "Don't let people tell you your ideas won't work. If you're passionate about an idea that's stuck in your head, find a way to build it so you can prove to yourself that it doesn't work."
    quote3.author = "-Dennis Crowley"

    @quotes = [quote1, quote2, quote3]
  end

end
