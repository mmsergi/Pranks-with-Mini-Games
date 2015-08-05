languageCode = system.getPreference("locale", "language")
print( "languageCode = "..languageCode )

-- Para añadir más códigos buscar en esta web: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
function idiomas()
	if languageCode == "es" then 
		if espanol==0 then
			language = "ingles"
			print("language = "..language)
		elseif espanol==1 then
			language = "espanol" 
			print("language = "..language)
		end
	elseif languageCode == "pt" then 
		if portugues==0 then
			language = "ingles"
			print("language = "..language)
		else
			language = "portugues" 
			print("language = "..language)
		end
	elseif languageCode == "ru" then 
		if ruso==0 then
			language = "ingles"
			print("language = "..language)
		else
			language = "ruso" 
			print("language = "..language)
		end
	elseif languageCode == "fr" then 
		if frances==0 then
			language = "ingles"
			print("language = "..language)
		else
			language = "frances" 
			print("language = "..language)
		end
	elseif languageCode == "de" then 
		if aleman==0 then
			language = "ingles"
			print("language = "..language)
		else
			language = "aleman" 
			print("language = "..language)
		end
	elseif languageCode == "it" then 
		if italiano==0 then
			language = "ingles"
			print("language = "..language)
		else
			language = "italiano" 
			print("language = "..language)
		end
	else 
		language = "ingles" 
		print("language = "..language)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EjemploTexto = display.newText(translations["Hello"][language], cx, cy, native.systemFont, 50)
-- Activar/Desactivar idiomas:
espanol = 1
portugues = 1
ruso = 1
frances = 1
aleman = 1
italiano = 1
-- Para cambiar activar/desactivar idiomas en otras partes del código como en el menú, se puede cambiar la variable y llamar de nuevo la función idiomas()
idiomas()

translations =
{
	["Verdad"] = 
	{
		["ingles"] = "True",
		["espanol"] = "Verdad",
		["portugues"] = "Verdade",
		["ruso"] = "правда",
		["frances"] = "Vrai",
		["aleman"] = "Wahr",
		["italiano"] = "Vero",
	},

	["Mentira"] = 
	{
		["ingles"] = "False",
		["espanol"] = "Mentira",
		["portugues"] = "Falso",
		["ruso"] = "Ложь",
		["frances"] = "Faux",
		["aleman"] = "Falsch",
		["italiano"] = "Falso",
	},

	["Escaneando"] = 
	{
		["ingles"] = "Scanning...",
		["espanol"] = "Escaneando...",
		["portugues"] = "Digitalização...",
		["ruso"] = "сканирование...",
		["frances"] = "Numérisation...",
		["aleman"] = "Scannen...",
		["italiano"] = "Scansione...",
	},

	["Escaneo abortado"] = 
	{
		["ingles"] = "Scan aborted",
		["espanol"] = "Escaneo abortado",
		["portugues"] = "Digitalização abortada",
		["ruso"] = "Сканирование прерывается",
		["frances"] = "Numérisation annulée",
		["aleman"] = "Scannen abgebrochen",
		["italiano"] = "Scansione interrotta",
	},

	["Jugar"] = 
	{
		["ingles"] = "Play",
		["espanol"] = "Jugar",
		["portugues"] = "Jogar",
		["ruso"] = "Играть",
		["frances"] = "Jouer",
		["aleman"] = "Spielen",
		["italiano"] = "Gioca",
	},

	["Simulador"] = 
	{
		["ingles"] = "Simulator",
		["espanol"] = "Simulador",
		["portugues"] = "Simulador",
		["ruso"] = "Симулятор",
		["frances"] = "Simulateur",
		["aleman"] = "Simulator",
		["italiano"] = "Simulatore",
	},

	["Lie Detector"] = 
	{
		["ingles"] = "Lie Detector",
		["espanol"] = "Detector de mentiras",
		["portugues"] = "Detector de mentiras",
		["ruso"] = "Детектор лжи",
		["frances"] = "Détecteur de mensonge",
		["aleman"] = "Lügendetektor",
		["italiano"] = "Rivelatore di bugia",
	},

	["Juegos"] = 
	{
		["ingles"] = "Games",
		["espanol"] = "Juegos",
		["portugues"] = "Jogos",
		["ruso"] = "Игры",
		["frances"] = "Jeux",
		["aleman"] = "Spiele",
		["italiano"] = "Giochi",
	},

	["Fake Call"] = 
	{
		["ingles"] = "Fake call",
		["espanol"] = "Llamada falsa",
		["portugues"] = "Chamada falsa",
		["ruso"] = "Поддельный звонок",
		["frances"] = "Faux appel",
		["aleman"] = "Unechter Anruf",
		["italiano"] = "Chiamata simulata",
	},

	["Laser Sword"] = 
	{
		["ingles"] = "Laser Sword",
		["espanol"] = "Espada láser",
		["portugues"] = "Espada laser",
		["ruso"] = "Лазерный меч",
		["frances"] = "Sabre-laser",
		["aleman"] = "Laser-Schwert",
		["italiano"] = "Spada laser",
	},
}
 
return translations

