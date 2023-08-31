extends CanvasLayer


func _process(delta):
	
	if Input.is_action_just_pressed("tool_select"):
		$SelectionWheel.Open()
	elif Input.is_action_just_released("tool_select"):
		var tool = $SelectionWheel.Close()
		SetPlayerTool(tool)


func SetPlayerTool(t):
	$Label.text = "Player Tool: " + t
