extends Control

onready var lobby_list = $"%LobbyList"
onready var lobby_name = $"%LobbyName"

var selected_lobby
var lobbies = []

func _ready():
	$"%CreateLobbyButton".connect("pressed", self, "_on_create_lobby_button_pressed")

	SteamLobby.connect("lobby_match_list_received", self, "_on_lobby_match_list_received", [], CONNECT_DEFERRED)
	$"%BackButton".connect("pressed", self, "_on_back_button_pressed")

func _on_create_lobby_button_pressed():
	var availability
	if $"%PublicButton".pressed:
		availability = SteamLobby.LOBBY_AVAILABILITY.PUBLIC
	else :
		availability = SteamLobby.LOBBY_AVAILABILITY.FRIENDS
	SteamLobby.LOBBY_NAME = get_lobby_name()
	SteamLobby.create_lobby(availability, $"%LobbySize".value)

func _on_back_button_pressed():
	Network.stop_multiplayer()
	get_tree().reload_current_scene()

func show():
	.show()
	_on_LobbySize_value_changed($"%LobbySize".value)
	$"%ConnectingLabel".show()
	clear_lobby_list()
	request_lobby_list()


func request_lobby_list(code = ""):
	SteamLobby.request_lobby_list(code, Global.VERSION if $"%FilterIncompatibleButton".pressed else "")

func get_lobby_name():
	var lobby_text = lobby_name.text.strip_edges()
	if lobby_text == "":
		return SteamHustle.STEAM_NAME + "'s Lobby"
	return lobby_text

func clear_lobby_list():
	for child in lobby_list.get_children():
		child.free()

func _on_lobby_match_list_received(lobbies):
	self.lobbies = lobbies
	$"%ConnectingLabel".hide()
	

	clear_lobby_list()
	var sorting_methods = [
		"sort_player_count", 
		"sort_name", 
	]
	
	lobbies.sort_custom(self, sorting_methods[$"%SortButton".selected])

	for lobby in lobbies:
		
		var lobby_name:String = Steam.getLobbyData(lobby, "name")

		var lobby_version:String = Steam.getLobbyData(lobby, "version")
		
		var lobby_max_members:int = Steam.getLobbyMemberLimit(lobby)
		
		
		var lobby_num_members:int = Steam.getNumLobbyMembers(lobby)
		
		var lobby_entry = preload("res://ui/SteamLobby/LobbyEntry.tscn").instance()
		lobby_list.add_child(lobby_entry)
		lobby_entry.connect("selected", self, "_on_lobby_clicked", [lobby_entry])
		var data = {
			"name":lobby_name, 

			"version":lobby_version, 
			"player_count":lobby_num_members, 
			"max_players":lobby_max_members, 
			"id":lobby, 
		}
		lobby_entry.set_data(data)
		if lobby == selected_lobby:
			lobby_entry.select()
		pass


func sort_player_count(a, b):
	return Steam.getNumLobbyMembers(a) > Steam.getNumLobbyMembers(b)

func sort_name(a, b):
	return Steam.getLobbyData(a, "name") > Steam.getLobbyData(b, "name")
	pass

func _on_lobby_clicked(entry):

	if SteamLobby.LOBBY_ID != 0:
		return 
	for lobby in lobby_list.get_children():
		if lobby != entry:
			lobby.deselect()
	if entry.lobby_data.version != Global.VERSION:
		error("Mismatched versions. Make sure your game is fully updated, or you both have the same mods enabled.")
		return 
	selected_lobby = entry.lobby_id
	SteamLobby.join_lobby(entry.lobby_id)
	$"%LobbyList".hide()
	$"%LobbyConnectingLabel".show()

func error(text):
	$"%ErrorLabel".text = text

func _on_SteamLobbyList_visibility_changed():
	if not visible:
		$"%RefreshTimer".stop()
	pass

func _on_FilterIncompatibleButton_toggled(button_pressed):
	request_lobby_list($"%CodeSearch".text)



func _on_RefreshButton_pressed():
	request_lobby_list()
	pass


func _on_SortButton_item_selected(index):
	request_lobby_list()

	pass


func _on_SearchButton_pressed():
	request_lobby_list($"%CodeSearch".text)
	pass


func _on_CodeSearch_text_entered(new_text):
	request_lobby_list(new_text)
	pass

func _on_LobbySize_value_changed(value):
	$"%LobbySizeLabelCount".text = str(value)
	pass
