class PagesController < ApplicationController

  def index
    @quotes = [
      ["Work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do.", "-Steve Jobs"],
      ["When there's that moment of 'Wow, I'm not really sure I can do this,' and you push through those moments, that's when you have a breakthrough.", "-Marissa Mayer"],
      ["Don't let people tell you your ideas won't work. If you're passionate about an idea that's stuck in your head, find a way to build it so you can prove to yourself that it doesn't work.", "-Dennis Crowley"]
    ]
  end

end
