@tool
extends Control


const SPRITE_SIZE = Vector2(32, 32)


@export var bkg_color: Color
@export var line_color: Color
@export var highlight_color: Color

@export var outer_radius = 256
@export var inner_radius = 64

@export var line_width = 4

@export var options: Array[WheelOption] = []
var selected = 0


func avg(a, b):
	return (a + b) / 2.0


func Open():
	show()

func Close():
	hide()
	
	return options[selected].name


func _draw():
	var offset = SPRITE_SIZE / -2
	
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 256, line_color, line_width, true)
	
	if len(options) >= 3:
		
		# draw separator lines
		for i in range(len(options) - 1):
			var rads = (TAU * i) / (len(options)-1)
			var point_normalized = Vector2.from_angle(rads)
			draw_line(point_normalized*inner_radius, point_normalized*outer_radius, line_color, line_width, true)
		
		# highlight current selection
		if selected == 0:
			draw_circle(Vector2.ZERO, inner_radius, highlight_color)
		
		# draw center option
		draw_texture_rect_region(options[0].atlas, Rect2(offset, SPRITE_SIZE), options[0].region)
		
		# draw remaining options
		for i in range(1, len(options)):
			var start_rads = (2 * PI * (i-1)) / (len(options)-1)
			var end_rads = (2 * PI * i) / (len(options)-1)
			var mid_rads = avg(start_rads, end_rads) * -1
			var radius_mid = avg(inner_radius, outer_radius)
			
			# highlight current selection
			if selected == i:
				draw_circle_outer_arc_poly(inner_radius, outer_radius, start_rads, end_rads, highlight_color)
			
			var draw_pos = radius_mid*Vector2.from_angle(mid_rads) + offset
			draw_texture_rect_region(options[i].atlas, Rect2(draw_pos, SPRITE_SIZE), options[i].region)

# copied from https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
func draw_circle_outer_arc_poly(i_radius, o_radius, angle_from, angle_to, color):
	var points_per_arc = 24
	var points_inner = PackedVector2Array()
	var points_outer = PackedVector2Array()
	var colors = PackedColorArray([color])

	var a = []
	for i in range(points_per_arc+1):
		var angle = angle_from + i * (angle_to - angle_from) / points_per_arc
		a.append(angle)
		points_inner.append(i_radius * Vector2.from_angle(TAU-angle))
		points_outer.append(o_radius * Vector2.from_angle(TAU-angle))
	
	points_outer.reverse()
	draw_polygon(points_inner + points_outer, colors)


func _process(delta):
	var mouse_pos = get_local_mouse_position()
	var mouse_radius = mouse_pos.length()
	
	if mouse_radius < inner_radius:
		selected = 0
	else:
		var mouse_rads = fposmod(-1 * mouse_pos.angle(), TAU)
		selected = ceil((mouse_rads / TAU) * (len(options)-1))
	
	queue_redraw()
