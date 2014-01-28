require_relative 'pixel'
require_relative 'error_handler'



class Image
  
  include ErrorHandler
  attr_accessor :pixels, :m_columns, :n_rows

  def initialize
    @m_columns, @n_rows, @pixels = 0, 0, []
  end
#=================================================================================
  #creating NxM image with color 
  def create_image(n, m, color = 'O')
    prepare_image_creation(m, n, color) 
    initializing_image_pixels(color)
  end
  # color single pixel
  def colored_pixel(x, y, color)
    x, y = check_coordinate(x, @m_columns), check_coordinate(y, @n_rows)
    check_color?(color) # same problem: methods with ? shouldn't do any work
    @pixels[(x-1)+(y-1)*@m_columns].color = color
  end
  #colored Vertical line
  def draw_vertical_line(x1, x2, x3, color)
    params = check_vertical_line_params(x1, x2, x3, color)
    coordinates = prepare_vertical_line(params[0], params[1], params[2])
    colored_pixels_by_coordinates(coordinates, color)
  end
  #colored Horizontal line
  def draw_horizontal_line(x1, x2, x3, color)
    params = check_horizontal_line_params(x1, x2, x3, color)
    coordinates = prepare_horizontal_line(params[0], params[1], params[2])
    colored_pixels_by_coordinates(coordinates, color)
  end
  #select areas R to fill pixels with color  === !! fixed to area_to_fill
  def selected_area_to_fill(x, y, color)
    coordinates = check_area_parameters(x, y, color)
    full_array = prepare_area_to_fill(coordinates[0], coordinates[1], color)
    colored_pixels_groups(full_array, color) if !full_array.empty?
  end
  #clear table of image
  def clear(color = 'O')
    check_color?(color) if color.eql?('O')
    @pixels.each{|px| px.color = color }
  end
  # show current image
  def inspect
    output = ""
    @pixels.each{|px| output += px.x % @m_columns == 0 ? px.color + "\n" : px.color }
    output
  end

    #select area R to fill pixels with color
  def area_to_fill(x, y, color)
    coordinates = check_area_parameters(x, y, color)
    color_old = find_pixel_color(coordinates[0], coordinates[1]) 
    recursion_area_to_fill(coordinates[0], coordinates[1], color_old, color, [])
  end

  def recursion_area_to_fill(x,y,color_old, color,list)
    # you're doing two things here. Firstly, you're maintaining the list
    # of coordinates to fill. Secondly, you're using recursion to go through
    # this list. If you're using a recursive solution, you don't need to 
    # maintain the list (but you'd need to do it if you were iterating over it instead).
    # In other words, the solution could be simpler.
    list = update_list(x,y,color_old, color,list)
    if !list.empty?
      coor = list.shift
      recursion_area_to_fill(coor[0],coor[1],color_old,color,list)
    end 
    return # an empty return at the end of the method is pointless
  end

  def update_list(x,y,color_old, color,list)
    neighbors = [[x,y-1],[x-1,y],[x+1,y],[x,y+1]]
    neighbors.each do |px|
      index = find_pixel_index(px[0], px[1])
      if index && @pixels[index].color == color_old
        list <<  [@pixels[index].x, @pixels[index].y]
        @pixels[index].color = color;
      end
    end
    list
  end

 #============================================================================= 
  #Vertical coordinates line draw
  def prepare_vertical_line(x1, x2, x3)
    result = []
    x2.upto(x3){|iter| result << [x1, iter] }
    result
  end
  #check vertical line coordinates and color
  def check_vertical_line_params(x1, x2, x3, color)
    x_bigger_y?(x2, x3) # it's absolutely not obvious from this line that this may raise an error
    check_color?(color)
    check_line_coordinates(x1, x2, x3)
  end
  #Horizontal coordinates line draw
  def prepare_horizontal_line(x1, x2, x3)
    result = []
    x1.upto(x2){|iter| result << [iter, x3] } # case for inject?
    result
  end
  #check line coordinates
  def check_line_coordinates(x1, x2, x3, line = "V")
    if line == "V"
      return [check_coordinate(x1, @m_columns), check_coordinate(x2, @n_rows), check_coordinate(x3, @n_rows)] 
    end
    return [check_coordinate(x1, @m_columns), check_coordinate(x2, @m_columns), check_coordinate(x3, @n_rows)]
  end
  #check horizontal line coordinates and color
  def check_horizontal_line_params(x1, x2, x3, color)
    coords = check_line_coordinates(x1, x2, x3, "H")
    x_bigger_y?(x1, x2)
    check_color?(color)
    coords
  end 
  #coloring pixels as giving array with px coordinates
  def colored_pixels_by_coordinates(group_pixels, color)
    group_pixels.each{|px| 
      @pixels[(px[0]-1)+(px[1]-1)*@m_columns].color = color
    }
  end
  #coloring pixels as giving pixels object array but not coordinates
  def colored_pixels_groups(group_pixels, color)
    group_pixels.each{|px| px.color = color }
  end
  #get the color of pixel of giving coordinates
  def find_pixel_color(x, y)
    @pixels[(x-1)+(y-1)*@m_columns].color
  end
  #get the same color pixels in image
  def same_color_pixels(x, y)
    color = find_pixel_color(x,y) 
    @pixels.select{|px| px.color == color }
  end
  #select area R to fill pixels with color
  def check_area_parameters(x, y, color)
    check_color?(color)
    [check_coordinate(x, @m_columns), check_coordinate(y, @n_rows)]
  end
  #select pixels for area
  def prepare_area_to_fill(x, y, color)
    group_pixels = same_color_pixels(x, y)
    return group_pixels if group_pixels.count == pixels_count
    group_pixels.each{|px| find_pixel_neighbors(px.x, px.y, color) } 
    []
  end
  #if x or y exist in image
  def exist_coordinate?(coord, size)
    coord >=1 && coord <= size # or (1..size).include? coord
  end
  #if both coordinates is in range of image
  def exist_x_y?(x,y)
    exist_coordinate?(y, @n_rows) && exist_coordinate?(x, @m_columns)
  end
  #finds pixel neighbors coordinates
  def find_pixel_neighbors(x, y, color)
    # If this comment isn't necessary, don't include it in the submitted code
   # neighbors = [[x-1,y-1],[x,y-1],[x+1,y-1],[x-1,y],[x,y],[x+1,y],[x-1,y+1],[x,y+1],[x+1,y+1]]
    neighbors = [[x,y-1],[x-1,y],[x,y],[x+1,y],[x,y+1]]
    prepare_pixel_neighbors(neighbors, color)
  end
  #color pixel neighbors
  def prepare_pixel_neighbors(template_neighbors, color)
    template_neighbors.each{|coordinates| 
      index = find_pixel_index(coordinates[0], coordinates[1]) 
      @pixels[index].color = color if !index.nil?
    }
  end
  #find the index im pixels by gave coordinates of pixel
  def find_pixel_index(x, y)
    (x-1)+(y-1)*@m_columns if exist_x_y?(x, y)
  end
  #counting image pixels
  def pixels_count
    @pixels.count
  end
  #prepare image to create
  def prepare_image_creation(n, m, color) 
    check_image_range?(n, m)
    check_color?(color) if color != 'O'
    @n_rows, @m_columns = n.to_i, m.to_i
  end
  #init image pixels
  def initializing_image_pixels(color)
    for y in 1..@n_rows
      for x in 1..@m_columns 
        @pixels << Pixel.new(x, y ,color)
      end
    end
  end

end