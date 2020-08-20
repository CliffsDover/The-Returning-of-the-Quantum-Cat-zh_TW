-- $Name:量子貓的歸來$
-- $Name(ru):Возвращение квантового кота$
-- $Name(zh_TW):量子貓的歸來$
-- $Version: 1.6.1$

if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

require "xact"

gam_lang = {
	ru = 'Язык',
	en = 'Language',
	zh_TW = '語言',
}

gam_title = {
	ru = 'Возвращение квантового кота',
	en = 'Returning the Quantum Cat',
	zh_TW = '量子貓的歸來',
}
LANG = "zh_TW"
if not LANG or not gam_lang[LANG] then
	LANG = "en"
end

gam_lang = gam_lang[LANG]
gam_title = gam_title[LANG]

main = room {
	nam = gam_title;
	forcedsc = true;
	dsc = txtc (
		txtb(gam_lang)..'^^'..
		img('zh_TW.png')..' '..[[{zh_TW:中文}^]]..
		img('gb.png')..' '..[[{en:English}^]]..
		img('ru.png')..' '..[[{ru:Русский}^]]);
	obj = {
		xact("zh_TW", code [[ gamefile('main-zh_TW.lua', true); return walk 'main' ]]);
		xact("ru", code [[ gamefile('main-ru.lua', true); return walk 'main' ]]);
		xact("en", code [[ gamefile('main-en.lua', true); return walk 'main' ]]);
	}
}
