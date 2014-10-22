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

  def faq

    faq1 = Faq.new
    faq1.question = "What is gCamp?"
    faq1.answer = "gCamp is an awesome tool that is going to change your life. gCamp is your one stop shop to organize all your tasks and documents. You'll also be able to track comments that you and others make. gCamp may eventually replace all need for paper and pens for the entire world. Well, maybe not, but it's going to be pretty cool."

    faq2 = Faq.new
    faq2.question = "How do I join gCamp?"
    faq2.answer = "Right now, gCamp is still in development. So, there is not a sign up page open to the public, yet! Your best option is to become best friends with a gCamp developer. They can be found hanging around gSchool all day."

    faq3 = Faq.new
    faq3.question = "When will gCamp be finished?"
    faq3.answer = "gCamp is a work in progress. That said, it should be fully functional by March 2015. Functional, but our developers will continue to improve the site for the foreseeable future. Check in daily for new features and awesome functionality. It's going to blow your mind."

    @faqs = [faq1, faq2, faq3]

  end

end
