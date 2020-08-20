game.codepage="UTF-8";
game.act = '沒有辦法這樣做…';
game.inv = 'Hmm... Wrong...';
game.use = '這樣行不通…';
game.dsc = [[Commands:^
    look (or just Enter), act <on what> (or just on what), use <what> [on what], go <where>,^
    back, inv, way, obj, quit, save <fname>, load <fname>. Tab to autocomplete.^^
Oleg G., Vladimir P., Ilia R., et al. in the science-fiction and dramatic text adventure by Pyotr K.^^
THE RETURNING OF THE QUANTUM CAT^^
Former hacker. He left to live in the forest. But he's back. Back for his cat.^^
“I JUST CAME TO GET BACK MY CAT...” ^^]];

--require "dbg";

me().nam = 'Oleg';
main = room {
	nam = '量子貓的歸來',
	pic = 'gfx/thecat.png',
	dsc = [[
我的小木屋外，白雪又一次到來。如同那天一樣，壁爐裡的木頭滋滋作嚮…這已經是第三個冬天了。^^

僅管已經過了兩個冬天，我想要說的故事，就像昨天才發生一樣，歷歷在目…^^

我已經從事森林守護員的工作十年了。在這十年裡，我住在林中的小木屋，蒐集盜獵者的陷井，每週或隔週前往鄰近的小鎮一次…在當地的教會作完禮拜之後，我會去附近的商站採買我所需要的東西:散彈槍的彈藥，穀物，麵包，藥品…^^

我過去算是個不錯的資訊技術專家…但那已經不重要了…已經有將近十年的時間，沒看過電腦螢幕…我並不感到後悔。^^

我了解那些事件的起源，遠至於將近我三十歲初頭的時候…但是我最好還是頭從娓娓道來…^^

那是個寒冷的二月天，我當時正一如往常，準備前往鎮上…]],
obj = { vobj(1,'Next','{Next}.') },
act = function()
	return walk('home');
end,
exit = function()
	set_music("mus/ofd.xm");
end,
};
set_music("mus/new.s3m");
dofile("ep1-zh_TW.lua");
dofile("ep2-en.lua");
dofile("ep3-en.lua");

me().where = 'eroom';
--inv():add('mywear');
--inv():add('gun');
--inv():add('trap');

