require 'ruby-processing'
# Need to work on: 
#  - Changing color from screen
#  - Scale the height and width according to screen size


# ====================================
# || Instance Variable Descriptions: ||
# ====================================
# @colors is the RGB values that are being set
# @shape is the shape of the brush
# @pixel is the size of the brush in #s of pixels
# @stroke is the stroke(outline) color of the shape
#  - Same as background color to allow blending in
# @x is the x coordinate of the mouse
# @y is the y coordinate of the mouse
# @queue is a String of the current input
#  - Will be set back to "" when enter("\n") is pressed

class ProcessArtist < Processing::App
	def setup
		ellipse_mode CENTER
		rect_mode CENTER
		stroke(0, 0, 0)
		background(0, 0, 0) 
		# x = $width - ($width / 50.to_f)
		# #Choice White
		# fill(255, 255, 255)
		# rect(x, 15, 19, 30)
		# #Choice Red
		# fill(255, 0, 0)
		# rect(x, 45, 19, 30)
		# #Choice Green
		# fill(0, 255, 0)
		# rect(x, 75, 19, 30)
		# #Set to normal
		fill(255, 255, 255)
		@b_colors = [0, 0, 0]
		@f_colors = [255, 255, 255]
		@shape = "circle"
		@pixel = 20
		@stroke = stroke(255, 255, 255)
	end

	def draw
		@x = mouse_x
		@y = mouse_y
	end

	def key_pressed
		warn "A key was pressed! #{key.inspect}"
		@queue ||= ""
		if key == "+" || key == "="
			@pixel += 1
			puts "The size of the paintbrush is #{@pixel}"
		elsif key == "-"
			if @pixel == 1
				@pixel = 2
			else
				@pixel -= 1
			end
			puts "The size of the paintbrush is #{@pixel}"
		elsif !key.is_a?(String)
			warn "That is not a letter!"
		elsif key != "\n"
			@queue = @queue + key
		elsif key == "\n" && @queue == ""
			puts "Please enter a command"
		else
			warn "Time to run the command #{@queue}"
			run_command(@queue)
			@queue = ""
		end
	end

	def run_command(command)
		puts "Running Command #{command}"
		method = command.split("")[0]
		letters = command.slice(1..-1)
		letters = letters.split(",")
		letters = [letters[0].to_i, letters[1].to_i, letters[2].to_i]
		if method == "b"
			@b_colors = letters
			background(@b_colors[0], @b_colors[1], @b_colors[2])
			puts "Changed the background color."
		elsif method == "f"
			@f_colors = letters
			fill(letters[0], letters[1], letters[2])
			@stroke = stroke(letters[0], letters[1], letters[2])
			puts "Changed the color of the paintbrush."
		elsif command == "c"
			background(@b_colors[0], @b_colors[1], @b_colors[2])
			puts "Cleared the screen"
		elsif method == "s"
			change_shape(command)
		elsif method == "p"
			change_size(command)
		elsif method == "e"
			@previous_shape ||= @shape
			@eraser_on ||= false
			if @eraser_on
				puts "Eraser off"
				fill(@f_colors[0], @f_colors[1], @f_colors[2])
				@shape = @previous_shape
				@stroke = stroke(@f_colors[0], @f_colors[1], @f_colors[2])
				@eraser_on = false
			else
				puts "Eraser on."
				fill(@b_colors[0], @b_colors[1], @b_colors[2])
				@shape = "circle"
				@stroke = stroke(@b_colors[0], @b_colors[1], @b_colors[2])
				@eraser_on = true
			end
		elsif command == "help"
			help
		else
			puts "Sorry, that method is not executable. Please type: \"help\" and press enter for a list of executable commands."
		end
		puts ""
	end
	def change_shape(command)
		if command == "s1"
			@shape = "circle"
			@previous_shape = "circle"
		elsif command == "s2"
			@shape = "oval1"
			@previous_shape = "oval1"
		elsif command == "s3"
			@shape = "oval2"
			@previous_shape = "oval2"
		elsif command == "s4"
			@shape = "square"
			@previous_shape = "square"
		elsif command == "s5"
			@shape = "rect1"
			@previous_shape = "rect1"
		elsif command == "s6"
			@shape = "rect2"
			@previous_shape = "rect2"
		elsif command == "s7"
			@shape = "plus"
			@previous_shape = "plus"
		elsif command == "s8"
			@shape = "clover"
			@previous_shape = "clover"
		elsif command == "s9"
			@shape = "triangle"
			@previous_shape = "triangle"
		end
		puts "Changing the brush shape to #{@shape}"
	end

	def change_size(command)
		if command.slice(1..-1) == "d"
			@pixel = 20
			puts "Setting brush size to default(20 pixels)"
		else
			pixels = command.slice(1..-1).to_i
			@pixel = pixels
			if @pixel < 1
				@pixel = 20
			end
		end
		puts "Setting brush size to #{@pixel}"
	end

	def mouse_pressed
		if @shape == "circle"
			oval(@x, @y, @pixel, @pixel)
		elsif @shape == "oval1"
			oval(@x, @y, @pixel*2, @pixel)
		elsif @shape == "oval2"
			oval(@x, @y, @pixel, @pixel*2)
		elsif @shape == "square"
			rect(@x, @y, @pixel, @pixel)
		elsif @shape == "rect1"
			rect(@x, @y, @pixel*4, @pixel)
		elsif @shape == "rect2"
			rect(@x, @y, @pixel, @pixel*4)
		elsif @shape == "plus"
			rect(@x, @y, @pixel*2, @pixel/2)
			rect(@x, @y, @pixel/2, @pixel*2)
		elsif @shape == "clover"
			scaling = @pixel/(1.5)
			oval(@x-scaling, @y, @pixel, @pixel)
			oval(@x, @y-scaling, @pixel, @pixel)
			oval(@x+scaling, @y, @pixel, @pixel)
			oval(@x, @y+scaling, @pixel, @pixel)
			oval(@x, @y, @pixel, @pixel)
		elsif @shape == "triangle"
			triangle(@x-(@pixel/2), @y+(@pixel/2), @x+(@pixel/2), @y+(@pixel/2), @x, @y-(@pixel/2))
		end
	end

	def mouse_dragged
		mouse_pressed
	end


	def help
		puts "Here are some letters that you can begin your commands with:"
		commands = {
			"b" => "Must type in 3 numbers ranging from 0-255. Each number will be related to Red, Green, and Blue respectively.",
			"f" => "Same as the \"b\" command, but instead will change the color of any shapes created to that color.",
			"c" => "Clears the screen",
			"s(any # here from 1-8)" => "Changes the shape of the brush to a shape based on the # given. s1: Circle, s2: Oval1, s3: Oval2, s4: Square, s5: Rectangle1, s6: Rectangle2, s7: Plus Sign, s8: Clover",
			"p(any # here)" => "Changes the brush size to the number of pixels specified. If \"pd\" is typed, the brush size will return to its default value(20 pixels)"
		}
		commands.each do |key, value|
			puts "#{key}: #{value}"
		end
	end
end

$width = 700
$height = 700
ProcessArtist.new(:width => $width, :height => $height, :title => "ProcessArtist", :full_screen => false)
