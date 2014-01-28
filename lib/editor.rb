require_relative 'error_handler'
require_relative 'image'

class Editor

  include ErrorHandler

  attr_accessor :image

  def initialize(image = nil)
    @image = image
  end

  def interactive_menu
    loop do
      menu_choice(menu_option_output)
    end
  end

  def program_menu
    user_output("menu")
  end

  #output text and get the command
  def menu_option_output
    user_output("p_command")
    $stdin.gets.chomp
  end

  def command_exist?(command)
    # please pay attention to the spelling: menu_commands
    menu_comands = ["I","C","L","V","H","F","S","X","R","B"]
    option = command.split(' ')
    # if an if statement only has true/false as outcomes, it can be omitted:
    # menu_comands.any?{|letter| letter == option[0]}
    # a better option, though:
    menu_comands.include? option.first
  end

  # Methods that end with "?" are supposed to only read data, not do any work and return a boolean value
  def image_defined?
    user_output("create_img", true) if @image.nil? # specifically, this shouldn't happen in a method ending with "?"
    return true # why return true if you never check for the return value of this method?
  end

  def check_command(command)
    return '-h' if command == '-h' 
    command_exist?(command) ? command.split(' ')[0] : user_output("undef_command", true) 
  end

  def prepare_parameters(command, counter, iter)
    check_arguments_number?(command, counter) # shouldn't end with "?", see that method for a comment
    command.shift
    command
  end

  def prepare_image_parameters(command)
    # you could have created a helper to improve readability, e.g.
    # return arguments(command) if has_two_numeric_args?(command)
    if check_arguments_number?(command, 3) && is_numeric?(command[2]) && is_numeric?(command[1])
      return [command[1], command[2]]   
    end
    [] 
  end

  def prepare_menu_commands(command)
    case command[0]
        when "V", "H"
          # http://stackoverflow.com/questions/47882/what-is-a-magic-number-and-why-is-it-bad
          return prepare_parameters(command, 5, 3)
        when "F", "L","B"
          # same here
          return prepare_parameters(command, 4, 2)
        when "I"
          return prepare_image_parameters(command)
          # it would also be nice to put these in constants to make it more readable
          # but I'm less fussy about this than the magic numbers
        when "R", "S", "C", "X"
          check_arguments_number?(command, 1)
       end
  end

  #prepare the command for image
  def prepare_command(arguments)
    command = arguments.split(' ')
    # here a method with a question mark is doing some work, this should never happen
    image_defined? if !["I", "X", "R", "-h"].include? command[0]
    prepare_menu_commands(command)
  end 

  def menu_choice_commands(letter, param)
    case letter
        when "I"
          @image = Image.new if !param.empty? # creating an image is cheap, why not do it in the initializer?
          @image.create_image(param[0], param[1]) if !param.empty?
        when "C"
          @image.clear 
        when "L"
         @image.colored_pixel(param[0], param[1], param[2]) if !param.empty?
        when "V"
          @image.draw_vertical_line(param[0], param[1], param[2], param[3]) if !param.empty?
        when "H"
          @image.draw_horizontal_line(param[0], param[1], param[2], param[3]) if !param.empty?
        when "F"
          @image.area_to_fill(param[0],param[1],param[2]) if !param.empty?
        when "B"
          @image.selected_area_to_fill(param[0],param[1],param[2]) if !param.empty?
        when "S"
          print @image.inspect
        when "R"
          system("clear")
        when "X"
          exit
        when "-h"
          program_menu
    end
  end

  def prepare_menu_choice(command, letter)
    param = letter ? prepare_command(command) : []
    menu_choice_commands(letter, param)
  end

  def menu_choice(command)
    begin
      return prepare_menu_choice(command, check_command(command))
    rescue Exception => e  
      exit if command.eql?("X") # a slightly cleaner way would be to check for the exception type thrown by exit()
      print e.message  
    end 
  end

end