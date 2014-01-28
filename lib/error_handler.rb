module ErrorHandler

  # 1. Please pay attention to the indentation. Many Ruby devs are very particular about it
  # 2. How come an ErrorHandler is responsible for printing the menu? This functionality has nothing
  # to do with error handling.
    PROGRAM_PHRASES = {
      "menu" => "\n\nEditor Commands as follow:\n
      > I M N - Create image MxN\n
      > C - Clear the image setting pixels to white (O)\n
      > L X Y C - Colours the pixel (X,Y) with colour C\n
      > V X Y1 Y2 C - Draw a vertical segment of colour C in column X between 
      rows Y1 and Y2\n
      > H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between 
      columns X1 and X2\n
      > F X Y C - Fill the region R with the colour C. 
      R is defined as: Pixel (X,Y) belongs to R. 
      Any other pixel which is the same colour as (X,Y) and 
      shares a common side with any pixel in R also belongs to this region.\n
      > B X Y C - Fill the regions Rs with the colour C. 
      R is defined as: Pixels (X,Y) belongs to R. 
      Any other pixels which is the same colour as (X,Y) and 
      shares a common side with any pixels in R also belongs to this region.\n
      > S - Show the contents of the current image\n
      > R - Clear the console\n
      > X - Terminate the session\n",
      "p_command" => "\nChoose the command: ",
      "undef_command" => "\nEditor do not know this command, for help put -h \n ",
      "create_img" => "\nFirst create the image!\n",
      "bad_color" => "\nColor not valid\n",
      "bad_numeric" => "\nNumber does not valid! \n",
      "bad_img_range" => "\nImage must be in range 1 <= M,N <= 250 px\n",
      "x_bigger_y" => "\nBad coodinates range\n",
      "bad_args" =>  "\nBad arguments in Command\n",
      "out_range" => "\nNumber is out of range\n"
    }

  # Again, how come ErroHandler is responsible for the output?
  # Also, many developers would sneer at using a boolean argument to dramatically alter the 
  # behaviour of the method (print vs raise). A better approach would me to split this method in two.
    #printing to console 
  def user_output(phrase, error = false) 
    phrase = PROGRAM_PHRASES[phrase]
    raise phrase if error == true
    print phrase if phrase
  end

  # Same problem as other methods that end in "?"
  def check_color?(color)
    color_template = /\A[A-Z]\z/
    user_output("bad_color", true) unless color_template.match(color.to_s)
    return true
  end

  def is_numeric?(number) 
    number_tempate = /\A\+?0*[1-9]\d*\Z/ # spelling: template
    user_output("bad_numeric", true) unless number_tempate.match(number.to_s)
    true
  end

  # This method raises an error or returns a number. It would be cleaner to return either true or false
  # depending if it's in the range and then raise the error elsewhere
  def check_coordinate(coordinate, size = 250)
    user_output("out_range", true) unless is_numeric?(coordinate) && coordinate.to_i <= size
    coordinate.to_i
  end

  # same problem as with other methods with "?" as well as the previous one
  def check_image_range?(m, n) 
    n = n.to_i if is_numeric?(n.to_i)
    m = m.to_i if is_numeric?(m.to_i)
    # magic numbers again
    user_output("bad_img_range", true) if m < 1 || m > 250 || n < 1 || n > 250
    true
  end
  
  # a method with a question mark should never raise an error
  def x_bigger_y?(x,y)
    user_output("x_bigger_y", true) if x > y
    true
  end

  # A method that ends with "?" should not do any work
  def check_arguments_number?(command, number)
    user_output("bad_args", true) if number != command.count
    true # I guess you're doing it because a method with "?" is supposed to always return a boolean but
    # a better solution would be to change the name of this method
  end

  # Same comment here (see above)
  def check_if_positive_integers?(number_list)
    number_list.each{|number| 
      check_coordinate(number)
    }
    true
  end

end