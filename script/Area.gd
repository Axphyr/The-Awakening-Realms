extends Area2D


@export var audio_name: String = "res://assets/musics/theme.mp3";
@export var area_name: String = "Test";

const notifScene = preload("res://scene/ui/AreaNotification.tscn")

func _on_body_entered(body: Node2D):
	
	print(body)
	if (body is CharacterBody2D ):
		AudioManager.stream = load(self.audio_name);
		print(self.audio_name)
		AudioManager.play();
		
		InteractionManager.current_zone_name = self.area_name;
		print("Entering ", self.area_name);
		
		var notif = notifScene.instantiate();
		var rect = notif.get_node("NinePatchRect");

		var label = notif.get_node("NinePatchRect/MarginContainer/Label");
		
		label.text = self.area_name;
		
		self.get_tree().root.get_node("World").add_child(notif);
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
		tween.tween_interval(1)
		tween.parallel().tween_property(rect, "position:y", rect.position.y, .9).from(rect.position.y-100)
		
		await get_tree().create_timer(5).timeout;
		
		var tween2 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
		tween2.parallel().tween_property(rect, "position:y", rect.position.y-100, .9).from(rect.position.y)
		await get_tree().create_timer(1).timeout;
		
		notif.queue_free();
		print("Notif deleted")


func _on_body_exited(_body):
	AudioManager.stop();
