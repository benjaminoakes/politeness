# Author: Benjamin Oakes <hello@benjaminoakes.com>

# Most libraries are *very* impolite; be sure to require politeness after including them (unless you intend to whip them into shape).
require 'politeness'

class Dog
  def speak
    puts 'Woof!'
  end
end

# If you don't say "please" often enough, Ruby will stop and say that you're "not polite enough!"
dog = Dog.new
please dog.speak
dog.speak
please dog.speak
dog.speak
dog.speak

# However, you can also be *too* polite.  In this case, Ruby will stop you until you reach the approriate level of politeness:
please please please please please please please please please dog.speak # Too polite!
please dog.speak

