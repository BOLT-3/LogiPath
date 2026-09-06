extends Control

const LEVELS_PATH := "res://levels"

var background: TextureRect
var background_tint: ColorRect
var file_dialog: FileDialog


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	setup_background()
	show_main_menu()



# BACKGROUND


func setup_background() -> void:
	
	# Wallpaper
	

	background = TextureRect.new()

	background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	background.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_COVERED
	)

	background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	background.texture = load_saved_wallpaper()

	if background.texture == null:
		background.texture = create_default_background()

	add_child(background)
	move_child(background, 0)


	
	# Dark tint
	

	background_tint = ColorRect.new()

	background_tint.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	background_tint.color = Color(
		0.02,
		0.04,
		0.07,
		0.55
	)

	background_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(background_tint)
	move_child(background_tint, 1)


func create_default_background() -> Texture2D:
	var image := Image.create(
		1280,
		720,
		false,
		Image.FORMAT_RGBA8
	)

	image.fill(Color("#0b111a"))

	return ImageTexture.create_from_image(image)


func load_saved_wallpaper() -> Texture2D:
	var path := "user://wallpaper.png"

	if not FileAccess.file_exists(path):
		return null

	var image := Image.load_from_file(path)

	if image == null:
		return null

	return ImageTexture.create_from_image(image)


func change_wallpaper() -> void:
	if file_dialog == null:
		file_dialog = FileDialog.new()

		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM

		file_dialog.filters = PackedStringArray([
			"*.png",
			"*.jpg",
			"*.jpeg",
			"*.webp"
		])

		file_dialog.file_selected.connect(
			_wallpaper_selected
		)

		add_child(file_dialog)

	file_dialog.popup_centered_ratio(0.7)


func _wallpaper_selected(path: String) -> void:
	var image := Image.load_from_file(path)

	if image == null:
		return

	var texture := ImageTexture.create_from_image(image)

	background.texture = texture

	image.save_png("user://wallpaper.png")



# MAIN MENU

func show_main_menu() -> void:
	clear_menu()

	var center := CenterContainer.new()

	center.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	add_child(center)


	var menu := VBoxContainer.new()

	menu.custom_minimum_size = Vector2(400, 0)

	menu.add_theme_constant_override(
		"separation",
		16
	)

	center.add_child(menu)


	
	# TITLE
	

	var title := Label.new()

	title.text = "PATH LOGIC"

	title.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	title.add_theme_font_size_override(
		"font_size",
		48
	)

	menu.add_child(title)


	
	# SUBTITLE
	

	var subtitle := Label.new()

	subtitle.text = "Draw paths. Solve the grid."

	subtitle.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	subtitle.add_theme_font_size_override(
		"font_size",
		18
	)

	menu.add_child(subtitle)


	
	# SPACER
	

	var spacer := Control.new()

	spacer.custom_minimum_size = Vector2(0, 25)

	menu.add_child(spacer)


	
	# PLAY
	

	var play := create_button("PLAY")

	play.pressed.connect(show_level_menu)

	menu.add_child(play)


	
	# SETTINGS
	

	var settings := create_button("SETTINGS")

	settings.pressed.connect(show_settings)

	menu.add_child(settings)


	
	# QUIT
	

	var quit := create_button("QUIT")

	quit.pressed.connect(quit_game)

	menu.add_child(quit)



# SETTINGS


func show_settings() -> void:
	clear_menu()

	var center := CenterContainer.new()

	center.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	add_child(center)


	var settings_menu := VBoxContainer.new()

	settings_menu.custom_minimum_size = Vector2(420, 0)

	settings_menu.add_theme_constant_override(
		"separation",
		16
	)

	center.add_child(settings_menu)


	
	# TITLE
	

	var title := Label.new()

	title.text = "SETTINGS"

	title.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	title.add_theme_font_size_override(
		"font_size",
		40
	)

	settings_menu.add_child(title)


	
	# WALLPAPER
	

	var wallpaper := create_button(
		"CHANGE WALLPAPER"
	)

	wallpaper.pressed.connect(
		change_wallpaper
	)

	settings_menu.add_child(wallpaper)


	
	# TINT ADJUSTER
	
	create_tint_adjuster(settings_menu)


	
	# BACK
	

	var back := create_button("BACK")

	back.pressed.connect(
		show_main_menu
	)

	settings_menu.add_child(back)



# TINT ADJUSTER


func create_tint_adjuster(parent: VBoxContainer) -> void:
	# Label

	var label := Label.new()

	label.text = "WALLPAPER TINT"

	label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	label.add_theme_font_size_override(
		"font_size",
		18
	)

	parent.add_child(label)


	# Slider

	var slider := HSlider.new()

	slider.min_value = 0.0
	slider.max_value = 0.8
	slider.step = 0.01

	slider.value = background_tint.color.a

	slider.custom_minimum_size = Vector2(
		420,
		30
	)

	slider.tooltip_text = "Wallpaper darkness"

	slider.value_changed.connect(
		func(value: float) -> void:
			background_tint.color.a = value
	)

	parent.add_child(slider)



# LEVEL MENU

func show_level_menu() -> void:
	clear_menu()

	var center := CenterContainer.new()

	center.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	add_child(center)


	var levels_menu := VBoxContainer.new()

	levels_menu.custom_minimum_size = Vector2(500, 0)

	levels_menu.add_theme_constant_override(
		"separation",
		14
	)

	center.add_child(levels_menu)


	
	# TITLE
	

	var title := Label.new()

	title.text = "SELECT LEVEL"

	title.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	title.add_theme_font_size_override(
		"font_size",
		38
	)

	levels_menu.add_child(title)


	
	# LEVELS
	
	var levels := get_levels()

	if levels.is_empty():
		var empty := Label.new()

		empty.text = "No levels available\n\nCOMING SOON"

		empty.horizontal_alignment = (
			HORIZONTAL_ALIGNMENT_CENTER
		)

		empty.add_theme_font_size_override(
			"font_size",
			22
		)

		levels_menu.add_child(empty)

	else:
		for level_path in levels:
			var button := create_button(
				level_path.get_file().get_basename()
			)

			button.pressed.connect(
				load_level.bind(level_path)
			)

			levels_menu.add_child(button)


	
	# BACK
	

	var back := create_button("BACK")

	back.pressed.connect(
		show_main_menu
	)

	levels_menu.add_child(back)


func get_levels() -> Array[String]:
	var levels: Array[String] = []

	var dir := DirAccess.open(LEVELS_PATH)

	if dir == null:
		return levels

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".tscn"):
				levels.append(
					LEVELS_PATH + "/" + file_name
				)

		file_name = dir.get_next()

	dir.list_dir_end()

	levels.sort()

	return levels


func load_level(path: String) -> void:
	get_tree().change_scene_to_file(path)



# HELPERS


func create_button(text: String) -> Button:
	var button := Button.new()

	button.text = text

	button.custom_minimum_size = Vector2(
		400,
		60
	)

	button.add_theme_font_size_override(
		"font_size",
		20
	)

	return button


func clear_menu() -> void:
	for child in get_children():
		if (
			child != background
			and child != background_tint
			and child != file_dialog
		):
			child.queue_free()


func quit_game() -> void:
	get_tree().quit()

# 5:54 6/9/2026 
# note: fuck