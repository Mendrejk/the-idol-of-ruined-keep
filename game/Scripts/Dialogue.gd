extends Node2D

signal textbox_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.level_number == 0:
		play_intro()
	elif Globals.RoderickDefeated:
		play_roderick_leave()
	elif Globals.BossDefeated:
		play_boss_defeated()
	elif Globals.level_number == ((Globals.map_length*Globals.map_miniboss_length_ratio)-1):
		play_roderick_entry()
	elif Globals.level_number == Globals.map_length-1:
		play_boss_entry()


func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("leftclick")) and $Background/TextBox.visible:
		$Background/TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Background/TextBox.show()
	$Background/TextBox/Label.text = text
	
func play_intro():
	$Background/TextBox.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: Leonie! Wstawaj!")
	await textbox_closed
	$Background/TextBox/Leader.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Hm…? O co chodzi?")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: Bezzwłocznie potrzebujemy Twojej pomocy! 
	Podczas ubiegłej nocy grupa bandytów zakradła się do naszej 
	kapliczki i skradła wielce wartościowy posążek.")
	await textbox_closed
	$Background/TextBox/Leader.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Posążek? Dlaczego jest on dla Was taki ważny?")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: Wierzymy, że utrata posążka zwiastuje marne 
	plony oraz częste choroby, do czego nie możemy dopuścić!")
	await textbox_closed
	display_text("Wódz wioski: Ale jest jeszcze coś o czym musisz wiedzieć, 
	naszemu karczmarzowi udało się rozpoznać jednego 
	z bandytów podczas nocnej kradzieży - był to Roderick.")
	await textbox_closed
	$Background/TextBox/Leader.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Roderick… A więc to tak skończył ten zdradziecki gad…")
	await textbox_closed
	display_text("Leon: Parę lat temu służyliśmy razem w gwardii królewskiej 
	jeszcze przed tym zanim wrobił mnie w kradzież królewskich 
	kosztowności.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: Czy to przez tą sytuację zostałeś wydalony 
	z gwardii królewskiej?")
	await textbox_closed
	$Background/TextBox/Leader.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Niestety tak. Dla dobra mieszkańców wioski oraz 
	osobistej zemsty wyruszę do ich siedziby aby odzyskać 
	Wasz posążek oraz rozprawić się z Roderickiem.")
	await textbox_closed
	display_text("Leon: Gdzie znajduje się ich siedziba?")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: W zrujnowanej twierdzy na północnym wzgórzu.")
	await textbox_closed
	$Background/TextBox/Leader.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: No to w drogę.")
	await textbox_closed
	get_tree().change_scene_to_file("res://Scenes/Playspace.tscn")

func play_boss_entry():
	$Background/TextBox.hide()
	$Background/TextBox/Boss.show()
	display_text("Herszt bandytów: Hm? Kto śmie zakłócać mój spokój podczas 
	biesiady?")
	await textbox_closed
	$Background/TextBox/Boss.show()
	display_text("Herszt bandytów: Hm? Kto śmie zakłócać mój spokój podczas 
	biesiady?")
	await textbox_closed
	$Background/TextBox/Boss.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Pewien zdeterminowany rycerz.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Boss.show()
	display_text("Herszt bandytów: Aaa to Ty jesteś tym wioskowym strażnikiem 
	tak? Prawie udało Ci się mnie przekonać do tego że jesteś 
	rycerzem haha!")
	await textbox_closed
	display_text("Herszt bandytów: Słuchaj widzę że przeszedłeś kawał drogi 
	aby się tu dostać, patrząc na Twoje ostrze to musiałeś pokonać 
	wielu moich chłopaków. W związku z tym dostaniesz jednorazową 
	ofertę - przyłącz się do naszej szajki, nie pożałujesz.")
	await textbox_closed
	$Background/TextBox/Boss.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Nie, nie jestem taki jak Roderick. Mnie tak łatwo nie 
	przekonasz.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Boss.show()
	display_text("Herszt bandytów: To był Twój ostatni błąd w życiu. Giń!")
	await textbox_closed
	get_tree().change_scene_to_file("res://Scenes/Playspace.tscn")

func play_roderick_entry():
	$Background/TextBox.hide()
	$Background/TextBox/Roderick.show()
	display_text("Roderick: Proszę, proszę, kogo my tu mamy.")
	await textbox_closed
	$Background/TextBox/Roderick.show()
	display_text("Roderick: Proszę, proszę, kogo my tu mamy.")
	await textbox_closed
	$Background/TextBox/Roderick.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Dobrze wiesz po co tu przyszedłem Rodericku. Nie 
	wywiniesz się tym razem.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Roderick.show()
	display_text("Roderick: Czyli jednak zdecydowałeś się mnie ścigać? Po 
	tylu latach nie jesteś w stanie sobie odpuścić?")
	await textbox_closed
	$Background/TextBox/Roderick.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: To z Twojej winy całe moje życie legło w gruzach. 
	Nie wybaczę Ci tego.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Roderick.show()
	display_text("Roderick: Oj błagam, gwardia królewska była strasznie nudna 
	i okrojona. Powinieneś mi wręcz podziękować że Cię od niej 
	uwolniłem.")
	await textbox_closed
	$Background/TextBox/Roderick.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Podziękuję Ci moim mieczem! Walcz!")
	await textbox_closed
	get_tree().change_scene_to_file("res://Scenes/Playspace.tscn")

func play_roderick_leave():
	$Background/TextBox.hide()
	$Background/TextBox/Roderick.show()
	display_text("Roderick: Jak to… Jak to możliwe?")
	await textbox_closed
	$Background/TextBox/Roderick.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Twój styl walki nic się nie zmienił przez kilka ostatnich 
	lat.")
	await textbox_closed
	$Background/TextBox/Roderick.show()
	$Background/TextBox/Leon.hide()
	display_text("Roderick: No cóż… *kaszle* W tym starciu wygrał lepszy 
	wojownik… *kaszle* Ale nie jesteś lepszy od herszta i 
	wkrótce się o tym przekonasz…")
	await textbox_closed
	$Background/TextBox/Roderick.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: To się dopiero okaże.")
	await textbox_closed
	Globals.RoderickDefeated = false
	get_tree().change_scene_to_file("res://Scenes/Map/Map.tscn")


func play_boss_defeated():
	$Background/TextBox.hide()
	$Background/TextBox/Boss.show()
	display_text("Herszt bandytów: To... niemożliwe. Pokonany przez 
	kogoś takiego jak ty...")
	await textbox_closed
	$Background/TextBox/Boss.hide()
	$Background/TextBox/Leon.show()
	display_text("Leon: Sprawiedliwość zwyciężyła.")
	await textbox_closed
	$Background/TextBox/Leon.hide()
	$Background/TextBox/Leader.show()
	display_text("Wódz wioski: Dziękujemy Ci Rodericku! Uratowałeś naszą wioskę.
	Zawsze znajdziesz u nas posiłek i dach nad głową.")
	await textbox_closed
	Globals.BossDefeated = false
	get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
