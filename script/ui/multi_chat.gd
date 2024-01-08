extends CanvasLayer


func _on_button_pressed():
	for i in MultiplayerManager.list_player:
		if (MultiplayerManager.list_player[i].id == multiplayer.get_unique_id()):
			self.handle_message(i);

func handle_message(id):
	var message = $LineEdit.text.lstrip(' ').rstrip(' ');
	if message.is_empty(): return;
	if message.begins_with('/'):
		self.handle_command(message, id);
	else:
		self.handle_send_message(id)
	$LineEdit.text = '';

func handle_command(command: String, id: int):
	
	var command_args = command.split(' ', 1);
	
	match(command_args[0]):
		'/battle':
			var player_name = command_args[1] if len(command_args) == 2 else 'unknow';
			
			if player_name in MultiplayerManager.get_names():
				var chosen_player = MultiplayerManager.get_player_from_name(player_name);
				if(chosen_player != -1):
					send_confirmation_message.rpc_id(chosen_player, "send_confirmation_message", MultiplayerManager.list_player[id], MultiplayerManager.list_player[chosen_player])
				else:
					$RichTextLabel.append_text("[color=red]Player '%s' not found.[/color]\n" % [player_name]);
			
			else:
				$RichTextLabel.append_text("[color=red]The name '%s' does not exists.[/color]\n" % [player_name]);
			
		_:
			$RichTextLabel.append_text("[color=red]The command '%s' doesn't exists. Try /help to see the list of command[/color]\n" % [command_args[0]]);

func handle_send_message(i):
	$RichTextLabel.append_text("[color=white]You : [/color][color=green]%s[/color]\n" % [$LineEdit.text]);
	self.send_message.rpc(multiplayer.get_unique_id(), MultiplayerManager.list_player[i].name,  $LineEdit.text);
	$LineEdit.text = "";
	return;

@rpc("any_peer", "call_remote")
func send_message(id, name, message):
	$RichTextLabel.append_text("[color=white]%s : [/color][color=green]%s[/color]\n" % [name, message]);


@rpc("any_peer", "call_remote")
func send_confirmation_message(id, initialiser_player, chosen_player):
	print("confirmation message sent")
	var confirm_message = load("res://scene/ui/multiplayer_battle_confirm.tscn").instantiate()
	
	confirm_message.initialiser_player = initialiser_player
	confirm_message.enemy_player = chosen_player
	
	confirm_message.connect("battle_reject", _on_battle_rejected)
	confirm_message.connect("battle_accepted", _on_battle_accepted)
	
	add_child(confirm_message)

func _on_battle_rejected(_initialiser_player, _enemy_player):
	print("rejected")
	pass;

func _on_battle_accepted(_initialiser_player, _enemy_player):
	print("accepted")	
	MultiplayerBattleManager.start_battle(_initialiser_player, _enemy_player)
	pass;
