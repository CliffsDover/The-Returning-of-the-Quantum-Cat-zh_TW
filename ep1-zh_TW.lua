mywear = obj {
	nam = '棉襖',
	dsc = function(s)
		if here() == stolcorridor then	
			local st='.';
			if not have('gun') then
				st = ', under which my shotgun is hidden.';
			end
			return 'Also there\'s my {quilted jacket} on the rack'..st;
		else
			return '松木門上的釘子掛著我的{棉襖}。';
		end
	end,
	inv = '雖然現在是冬天，但我正穿著一件暖和的綿襖。',
	tak = function(s)
		if here() == stolcorridor then
			if have('alienwear') then
				return 'I\'m already dressed... If I take my quilted jacket too, I\'ll look suspicious...', false;
			end
			if me()._walked then
				me()._walked = false;
				inv():add('gun');
				return 'But my quilted jacket is the best!';
			end
			return 'That would be too conspicuous... ', false;
		else
			return '我把外套從釘子上拿了下來。';
		end
	end, 
	use = function(s, o)
		if o == 'guy' then
			return 'After a short delay you exchanged coats...';
		end
	end
};

money = obj {
	nam = '現金',
	inv = '錢乃萬惡之源…辛好我沒有太多的錢。',
	use = function(s, w)
		if w == 'shopman' then
			if shopman._wantmoney then
				shopman._wantmoney = false;
				return 'I pay to Vladimir.';
			end
			return 'I don\'t want to pay without reason...';
		end
	end
};

mybed = obj {
	nam = '床',
	dsc = '窗邊有一張{床}。',
	act = '我可沒什麼時間睡覺。',
};

mytable = obj {
	nam = 'table',
	dsc = '在左邊角落有個有抽屜的橡木{桌子}。',
	act = function()
		if not have(money) then
			take('money');
			return '翻找了一下抽屜，我找到一些現金。';
		end
		return '這可是我親手做的桌子。';
	end,
};

foto = obj {
	nam = '照片',
	dsc = '桌上放著一張表框起來的{照片}。',
	tak = '我拿起了照片。',
	inv = '照片裡是我和我的巴西克。',
};

gun = obj {
	nam = '散彈槍',
	dsc = '在小木屋的右邊角落有把{散彈槍}。',
	tak = '我拿起了散彈槍，並把它掛在背後。',
	inv = function(s)
		local st = '';
		if s._obrez then
			st = ' By the way, now it\'s a sawed-off shotgun.';
			if s._hidden then
				st = st..' It\'s hidden inside my clothes.';
			end
		end
		if s._loaded then
			return 'The shotgun is loaded...'..st;
		else	
			return '這把散彈槍尚未上膛…我很少在森林中使用它。'..st;
		end
	end,
	use = function(s, w)
		if not s._hidden then
			if w == 'mywear' or w == 'alienwear' then
				if not s._obrez then
					return '我試著把槍藏在衣服裡，但這把槍實在太長了。'
				else
					s._hidden = true;
					return 'Now I can hide the sawed-off shotgun in the clothes!';
				end
			end
		end
		if not s._loaded then
			return '這把槍尚未上膛…', false;
		end
		if w == 'guard' then
			return 'Yes, they are scoundrels, but firstly they are humans too, and secondly it wouldn\'t help...', false;
		end
		if w == 'wire' then
			return 'Too close... I need something like wire cutters...', false;
		end
		if w == 'cam' and not cam._broken then
			cam._broken = true;
			s._loaded = false;
			return 'I aimed at the camera and fired both barrels... The dull gunshot was drowned by gusts of the snowstorm...';
		end
		if w == 'mycat' or w == 'shopman' or w == 'guy' then
			return 'This isn\'t my thought...', false;
		end
	end
};

fireplace = obj {
	nam = '壁爐',	
	dsc = '牆邊有個{壁爐}，火焰不規律地照亮著小木屋。',
	act = '我喜歡偎著壁爐，度過長長冬夜。',
};

mycat = obj {
	nam = '巴西克',
	_lflast = 0,
	lf = {
		[1] = 'Barsik is moving in my bosom.',
		[2] = 'Barsik peers out of my bosom.',
		[3] = 'Barsik purrs in my bosom.',
		[4] = 'Barsik shivers in my bosom.',
		[5] = 'I feel Barsik\'s warmth in my bosom.',
		[6] = 'Barsik leans out of my bosom and looks around.',
	},
	life = function(s)
		local r = rnd(6);
		if r > 2 then
			return;
		end 
		r = rnd(6);
		while (s._lflast == r) do
			r = rnd(6);
		end
		s._lflast = r;
		return s.lf[r];
	end,
	desc = { [1] = '我的貓 {巴西克}(“小雪豹”)正舒適地捲曲成一顆球，在壁爐旁睡覺。',
		 [2] = '{巴西克} 掃瞄了一下小木屋四週的地形。',
		 [3] = '{Barsik} is sitting on the front passenger seat.',
		 [4] = '{Barsik} is studying something by the trash bins...',
		 [5] = '{Barsik} snuggles up at my feet.',
	},
	inv = 'Barsik is in my bosom... My poor tomkitty... I\'ll save you!!! And the whole world...',
	dsc = function(s)
		local state
		if here() == home then
			state = 1;
		elseif here() == forest then
			state = 2;
		elseif here() == inmycar then
			state = 3;
		elseif here() == village then
			state = 4;
		elseif here() == escape3 then
			state = 5;
		end
		return s.desc[state];
	end,
	act = function(s)
		if here() == escape3 then
			take('mycat');
			lifeon('mycat');
			return 'I put Barsik in my bosom.';
		end
		return '我搔了一下巴西克的耳後…';
	end,
};

inmycar = room {
	nam = 'in the car',
	dsc = 'I\'m in my car... My workhorse...',
	pic = 'gfx/incar.png',
	way = {'forest', 'village'},
	enter = function(s, f)
		local s = 'I open the car door.';
		if have('mybox') then
			return 'I can\'t get into the car with this box...', false;
		end
		if seen('mycat') then
			s = s..' Barsik jumps into the car.'
			move('mycat','inmycar');
		elseif not me()._know_where then
			return 'No... First I have to find Barsik!', false
		end
		if f == 'guarddlg' then
			return 'Hmm... I\'ll have to come up with something...';
		end
		return cat(s, ' Well, time to go...');
	end,
	exit = function(s, t)
		local s=''
		if seen('mycat') then
			s = ' Barsik is the first to jump out of the car.';
			move('mycat',t);
		end
		if ref(t) ~= from() then
			from().obj:del('mycar');
			move('mycar', t);
			return [[
The car starts reluctantly... After a long road I finally kill the engine and open the door...]]..s;
		end
		return 'No... I think, I forgot something...'..s;
	end
};

mycar = obj {
	nam = 'my car',
	desc = {
	[1] = '在小木屋的前方停著我的舊豐田{小貨車}。',
	[2] = 'In the parking lot there is my old {pickup}.',
	[3] = 'Near the checkpoint stands my {pickup}.',
	[4] = 'Behind the corner stands my {pickup}.',
	},
	dsc = function(s)
		local state
		if here() == forest then
			state = 1;
		elseif here() == village then
			state = 2;
		elseif here() == inst then
			state = 3;
		elseif here() == backwall then
			state = 4;
		end
		return s.desc[state];
	end,
	act = function(s)
		return walk('inmycar');
	end
};

iso = obj {
	nam = 'insulating tape',
	inv = 'A roll of insulating tape. Blue...',
	use = function(s, o)
		if o == 'trap' and not trap._iso then
			trap._iso = true;
			return 'I insulated the trap with the tape.';
		end
		if o == 'wire' then
			return 'What for? I wouldn\'t go through the barbed wire. Besides, I can\'t insulate it — I\'d be struck by electricity!';
		end
	end
};

trap = obj {
	nam = '陷井',
	dsc = '在雪地裡有個{鋼製陷井}。', -- !!!!
	tak = '該死的盜獵者! 我要把這個陷井帶走。',
	inv = function(s)
		if s._salo then
			return 'Big mousetrap! Insulated too.';
		end
		if s._iso then
			return 'Steel. Very sharp. Insulated with the tape.';
		else
			return '鋼製而成的，非常銳利。';
		end
	end,
	use = function(s, o)
		if o == 'wire' and not wire._broken then 
			if not s._iso then
				return 'The trap is metallic... I\'d be knocked by  electricity and that\'s all...';
			end
			wire._broken = true;
			onwall.way:add('eside');
			return 'I bring the primed trap to the wire... As I thought the trap breaks the wire!';
		end
	end
};

deepforest = room {
	i = 0,
	nam = '密林深處',
	pic = 'gfx/deepforest.png',
	dsc = function(s)
		local st = '我正處於森林的深處…';
		if s._i == 1 then
			return st..'松樹和冷杉…沒別的了…';
		elseif s._i == 2 then
			return st..'漂亮的樺樹…我試著不要迷路…';
		elseif s._i == 3 then
			return st..'無法穿越的灌木叢…無法理解…我迷路了嗎?';
		elseif s._i == 4 then
			return st..'啊…美麗的湖…我該回頭嗎?';
		elseif s._i == 5 then
			s._trap = true;
			return st..'一些草叢…到處都是早叢。';
		else
			return st..'樹樁…真是的美麗的樹樁。';
		end
	end, 
	enter = function(s,f)
		if f == 'forest' then
			s._trap = false;
		end
		s._lasti = s._i;
		while (s._i == s._lasti) do
			s._i = rnd(6);
		end
		s.obj:del('trap');
		s.way:del('forest');
		if s._i == 5 and not inv():srch('trap') then
			s.obj:add('trap');
		end
		if s._i == 3 and s._trap then
			s.way:add('forest');
		end
		if f == 'forest' and inv():srch('trap') then
			return [[多謝了…我已經在森林裡走了好一陣子。]], false;
		end
		if f == 'deepforest' then
			return '嗯…來瞧瞧…';
		end
		return [[徒步走進林中? 嗯…未嘗不可，畢竟那是我的工作，也許這可以趕走一些盜獵者…]], true;
--Я пол часа бродил по лесу, когда наткнулся на капкан...
--Проклятые браконьеры! Я взял капкан с собой.]], false;
	end,
	way = {'deepforest'},
};

road = room {
	nam = '道路',
	enter = function()
		return '用走的? 算了吧…', false;
	end
};

forest = room {
	nam = '小木屋前方',
	pic = 'gfx/forest.png',
	dsc = [[
小木屋前方到處都是溼滑的白雪，密林環繞在小木屋四週，通往鎮上的路也被雪覆蓋。]],
	way = { 'home', 'deepforest', 'road' },
	obj = { 'mycar' },
};

home = room {
	nam = '小木屋',
	pic = function(s)
		if not seen('mycat') then
			return "gfx/house-empty.png"
		end
		return "gfx/house.png";
	end,
	dsc = [[
我在這個小屋住了十年。十年前我親手建造了這個小屋，有點狹窄，但很舒適。]],
	obj = { 'fireplace', 'mytable', 'foto', 'mycat', 'gun', 
	vobj(1,'window', '小木屋裡只有一扇{窗戶}。'), 
	'mybed', 'mywear' },
	way = { 'forest' },
	act = function(s,o)
		if o == 1 then
			return '窗外一片雪白。';
		end
	end,
	exit = function()
		if not have('mywear') then
			return '外面非常的寒冷…光是穿現在身上的衣服是沒有辦法出門的!', false
		end
		if seen(mycat) then
			move('mycat','forest');
			return [[
When I was walking out, Barsik suddenly woke and dashed after me. I petted him behind the ears. “Coming with me?”
]]
		end
	end
};
---------------- here village begins
truck = obj {
	nam = 'black car',
	dsc = 'There\'s a black {car} with tinted windows sy the shop.',
	act = 'Hm... It\'s a van... Armored body, it\'s evident by the wheel load...',
};

guydlg = dlg {
	pic = 'gfx/guy.png',
	nam = 'conversation with a bum',
	dsc = 'I walked to him... He turned back and glanced at me — a shortish man in a worn cap and tattered quilted jacket.',
	obj = {
		[1] = phr('Hi! Cold, isn\'t it?', 'Yes... Somewhat...'),
		[2] = phr('How come you\'ve got to be out in the street?', 
[[I used to work toward getting a Ph.D... I was writing a thesis about the structure of matter... But... Overstrained my brain... I tried to calm down and... Now I'm here...]]),
		[3] = phr('What\'s your name?', 'Eduard...'),
		[4] = _phr('When I left, there was a cat next to you... Where is it?', 'Hm...', 'pon(5)'),
		[5] = _phr('Yes... A tomcat. Ordinary tomcat roaming the snow around the dumpster.', 'So, that was your cat? Emmm...', 'pon(6)');
		[6] = _phr('Yes... That was my Barsik! Tell me!', 
'... Mmm... I think that man took it... Mmm... — a chill ran down my spine...', 'pon(7)'),
		[7] = _phr('Where, where did he go?', 'Sorry, brother, I haven\'t seen...', 'shopdlg:pon(4); pon(8);'),
		[8] = phr('Ok... Doesn\'t matter...', '...', 'pon(8); back()'),
	},
	exit = function()
		pon(1);
		return 'He turned back and continued rummaging in the dumpster bins...';
	end
};

guy = obj {
	nam = 'bum',
	dsc = 'A {bum} is rummaging in the dumpster bins.',
	act = function()
		return walk('guydlg');
	end,
	used = function(s, w)
		if w == 'money' then
			return [[
I approached him and offered some money... “I don't need other people's money...” he said.]];
		else
			return 'What would he need this for?';
		end
	end,
};

nomoney = function()
	pon(1,2,3,4,5);
	shopdlg:pon(2);
	return cat('This is when I remember, that I\'ve got no money... None at all...^',back());
end

ifmoney ='if not have("money") then return nomoney(); end; shopman._wantmoney = true; ';

dshells = obj {
	nam = 'shells',
	dsc = function(s)
		-- Note for translators: 
		-- this block picks the appropriate plural form 
		-- for “shells” for a given numeral. Since English has 
		-- only 1 form, I commented it out. 
		-- Uncomment and use form-number combinations
		-- appropriate for your language 
		-- if here()._dshells > 4 then
			return 'Under my feet there are '..here()._dshells..' empty shotgun {shells}...';
		-- else 
			-- return 'Under my feet there are '..here()._dshells..' empty shotgun {shells}...';
		-- end
	end,
	act = 'Those are my shells... I don\'t need them anymore...';
};

function dropshells()
	if here() == deepforest then
		return;
	end
	if not here()._dshells then
		here()._dshells = 2;
	else
		here()._dshells = here()._dshells + 2;
	end
	here().obj:add('dshells');
end

shells = obj {
	nam = 'cartridges',
	inv = 'Shotgun cartridges. I rarely use those, mostly against poachers.',
	use = function(s, on)
		if on == 'gun' then
			if gun._loaded then
				return 'Already loaded...';
			end
			if gun._loaded == false then
				gun._loaded = true;
				dropshells();
				return 'I open the shotgun, drop two shells and reload the shotgun.';
			end
			gun._loaded = true;
			return 'I take two cartridges and load them into the twin barrels of the shotgun...';
		end
	end
};

news = obj {
	nam = 'newspaper',
	inv = [[
Fresh newspaper... <<quantum mechanics institute recently built in taiga vigorously refutes its connection with any anomalous events>>.. Hm...]],
	used = function(s, w)
		if w == 'poroh' then
			if have('trut') then
				return 'I\'ve already got a tinder.';
			end
			inv():add('trut');
			inv():del('poroh');
			return 'I pour gunpowder on the piece of the newspaper, I\'ve torn off...';
		end
	end,
};

hamb = obj {
	nam = 'hamburger',
	inv = function()
		inv():del('hamb');
		return 'I\'ve had a snack. Junk food...';
	end
};

zerno = obj {
	nam = 'groats',
	inv = 'Just a buckwheat. Buckwheat groats...',
};

shop2 = dlg {
	nam = 'buy',
	pic = 'gfx/shopbuy.png',
	obj = { 
	[1] = phr('Shotgun cartridges... I need ammunition...', 'All right... Price as usual', ifmoney..'inv():add("shells")'),
	[2] = phr('Groats...', 'Good... ', ifmoney..'inv():add("zerno")'),
	[3] = phr('And a hamburger...', 'Ok..', ifmoney..'inv():add("hamb")'),
	[4] = phr('Fresh press...', 'Of course...', ifmoney..'inv():add("news")'),
	[5] = phr('A roll of insulating tape...', 'Yes. Here.', ifmoney..'inv():add("iso")'),
	[6] = phr('Nothing else...', 'As you wish.', 'pon(6); back()'),
	[7] = _phr('Also I need a ladder and wire cutters...', 'Sorry, I don\'t have those — Vladimir shakes his head'), 
	},
	exit = function(s)
		if have('news') then
			s.obj[4]:disable();
		end
	end
};

shopdlg = dlg {
	nam = 'conversation with the salesman',
	pic = 'gfx/shopman.png',
	dsc = 'Little eyes drill me with an oily stare.',
	obj = {
	[1] = phr('Hello, Vladimir! How\'s it going?', 'Hello, '..me().nam..'... So-so... - Vladimir smiles slyly.', 'pon(2)'),
	[2] = _phr('I want to make a few purchases.', 'Ok... Let\'s see, what do you need?', 'pon(2); return walk("shop2")'),
	[3] = phr('Bye then!...', 'Yeah... Good luck!', 'pon(3); return back();'),
	[4] = _phr('A man just was here — who is he?', 'Hm? — Vladimir\'s thin eyebrows rise a bit...','pon(5)'),
	[5] = _phr('For some reason he took my cat... Probably thought he\'s homeless... Who\'s that man in a gray coat?',
[[
Actually, he's some boss... - Vladimir scratches his unshaved chin. — In that new institute, which has been built in our backwoods a year ago...
 — Vladimir's pince-nez twitched as he spoke — he often comes to our shop, 
doesn't like crowds — those physicists — you know... Odd bunch, — Vladimir shrugged...]],'pon(6)'),
	[6] = _phr('Where is this institute located?', 
'Kilometer marker 127... But well, you know — Vladimir lowered his voice — there are rumours about his institute...', 'me()._know_where = true; inmycar.way:add("inst");pon(7)'),
	[7] = _phr('I\'m just going to get back my cat...', 'Take care... If I was in you shoes... — Vladimir shakes his head. — By the way, I think his name is Belin. I\'ve seen his credit card... Even though, as you know, I don\'t accept them — Vladimir moved his lips, his monocle stirred slyly'),
	},
};

shopman = obj {
	nam = 'salesman',
	dsc = 'There\'s a {salesman} behind the counter. His wide face with stubble is complemented by a monocle.',
	act = function()
		return walk('shopdlg');
	end
};

shop = room {
	nam = 'shop',
	pic = 'gfx/inshop.png',
	enter = function(s, f)
		if village.obj:look('truck') then
			village.obj:del('truck');
			village.obj:del('mycat');
			return [[
When I entered the shop, I almost ran into an unpleasant man in a grey coat and broad-brimmed hat... He apologized in a sort of hissing voice and feighned raising his hat... White teeth flashed from under the brim... When I reached the counter, I heard the engine starting.]];
		end
	end, 
	act = function(s,w)
		if w == 1 then
			return 'There\'s only my car left in the parking lot.';
		end
	end,
	dsc = [[
The store is somewhat unusual... Here you can find ironware, food, even ammunition... No wonder, since it's the only store in a 100 km area...]],
	way = { 'village' },
	obj = {'shopman',vobj(1, 'окно', 'Through the {window} the parking lot is visible.') },
	exit = function(s, t)
		if t ~= 'village' then
			return;
		end
		if shopman._wantmoney then
			return 'I was going to step outside, when I was stopped by Vlsdimir\'s quiet semicough... Of course, I forgot to pay...', false;
		end
		if not have('news') then
			shop2.obj[4]:disable();
			inv():add('news');
			return 'I was going to leave, when Vladimir\'s voice stopped me. — Take the fresh newspaper — it\'s free for you. I walk back, take the paper and leave.';
		end
	end
};

carbox = obj {
	_num = 0,
	nam = function(s)
		if s._num > 1 then
			return 'boxes in the car';
		else
			return 'a box in the car';
		end
	end,
	act = function(s)
		if inv():srch('mybox') then
			return 'I\'ve already got a box in my hands...';
		end
		s._num = s._num - 1;
		if s._num == 0 then
			mycar.obj:del('carbox');
		end
		take('mybox');
		return 'I took a box from the car.';
	end,
	dsc = function(s)
		if s._num == 0 then
			return;
		elseif s._num == 1 then
			return 'There is one {box} in the cargo body of my car.';
		-- Again not needed, since "boxes" stays the same for all numerals
		-- elseif s._num < 5 then
		--	return 'There are '..tostring(s._num)..' {boxes} in the cargo body of my car.';
		else	
			return 'There are '..tostring(s._num)..' {boxes} in the cargo body of my car..';
		end
	end,
};

mybox = obj {
	nam = 'a box',
	inv = 'I am holding a wooden box... A soundly built thing! Might come in handy.',
	use = function(s, o)
		if o == 'boxes' then
			inv():del('mybox');
			return 'I put the box back...';
		end
		if o == 'mycar' then
			inv():del('mybox');
			mycar.obj:add('carbox');
			carbox._num = carbox._num + 1;
			return 'I put the box in the cargo body of my car...';
		end
		if o == 'ewall' or o == 'wboxes' then
			if not cam._broken then
				return 'The camera won\'t let me...';
			end
			if wboxes._num > 7 then
				return "It's enough I think..."
			end
			inv():del('mybox');
			ewall.obj:add('wboxes');
			wboxes._num = wboxes._num + 1;
			if wboxes._num > 1 then
				return 'I put another box on top of the previous one...';
			end
			return 'I put the box next to the wall...';
		end
	end
};

boxes = obj {
	nam = 'ящики',
	desc = {
		[1] = 'Near the parking lot there are many empty wooden {boxes} that once held tins.',
	},
	dsc = function(s)
		local state = 1;
		return s.desc[state];
	end,
	act = function(s, t)
		if carbox._num >= 5 then
			return 'Maybe I\'ve got enough boxes already?...';
		end
		if inv():srch('mybox') then
			return 'I\'m holding one box already...';
		end
		take('mybox');
		return 'I took a box.';
	end,
};

village = room {
	nam = 'parking lot in front of the store',
	dsc = 'A familiar place in front of the store. The parking lot. All covered with snow...',
	pic = 'gfx/shop.png',
	act = function(s, w)
		if w == 1 then
			return 'Ordinary bins... White snow covers the garbage...';
		end	
	end,
	exit = function(s, t)
		if t == 'shop' and seen('mycat') then
			return 'I called Barsik, but he was too busy with the dumpster... OK, it won\'t take long...';
		end
	end,
	enter = function(s, f)
		if ewall:srch('wboxes') and wboxes._num == 1 then
			ewall.obj:del('wboxes');
			ewall._stolen = true;
			wboxes._num = 0;
		end
		if f == 'shop' and not s._ogh then
			s._ogh = true;
			set_music("mus/revel.s3m");
			guydlg:pon(4);
			guydlg:poff(8);
			return 'I glanced over the parking lot and called — Barsik! Barsik! — Where did my cat disappear?';
		end
	end,
	way = { 'road', 'shop' },
	obj = { 'truck', vobj(1,'bins', 'Rusty dumpster {bins} are covered with snow.'), 'guy','boxes' },
};
----------- trying to go over wall
function guardreact()
	pon(7);
	if inst:srch('mycar') then
		inst.obj:del('mycar');
		inmycar.way:add('backwall');
		inst.way:add('backwall');
		return cat([[Four people with submachine guns escorted me to my car. I had to start the engine and drive away from the institute. I drove a dozen kilometers before the military jeep with the seeing-off guards disappeared from the rear-view mirror... ]], walk('inmycar'));
	end
	return cat([[Four armed people throw me out of the check-point.^^]], walk('inst'));
end

guarddlg = dlg {
	nam = 'guard',
	pic = 'gfx/guard.png',
	dsc = [[I can see the angular face of the guard. His eyes look archly, but corners of his mouth are turned down, discouraging any conversation...]],
	obj = {
	[1] = phr('One of the institute staff took my cat by mistake — I need to get in.','— Show the pass...', 'poff(2); pon(3);'),
	[2] = phr('I forgot my pass — may I come in?','— No...', 'poff(1); pon(3);'),
	[3] = _phr('Do you know Belin? He\'s got my cat — I need to take it...', '— No pass?', 'pon(4)'),
	[4] = _phr('I just came to get back my cat! Give me Belin\'s number.', 
[[The guard's eyes change their color. The corners of his lips move up. — Mister, as I understand you have no pass. Walk out of here while you still can...]], 'pon(5, 6)'),
	[5] = _phr('I\'m gonna hit your face...', 'The guard\'s hand moves to his submachine gun. ', 'poff(6); return guardreact();'), 
	[6] = _phr('OK, I\'m leaving...', '— Don\'t hurry, — the guard no longer hides his smile — I don\'t like you...','poff(5); return guardreact()'),
	[7] = _phr('Now I\'m gonna shotgun you all...', 'This time the guard doesn\'t even answer. His bloodshot eyes speak louder than any words.','return guardreact()'),
	},
};
guard = obj {
	nam = 'guards',
	dsc = [[
There are {guards} in the kiosk. Looks like they are armed with Kalashnikov submachine guns.
]],
	act = function(s)
		return walk('guarddlg');
	end,
};
kpp = room {
	nam = 'checkpoint',
	pic = 'gfx/kpp.png',
	dsc = [[The checkpoint leaves no doubt that strangers are not welcome in the institute. Lift gate. Latticed kiosk. And silence.
]],
	obj = { 'guard' },
	way = { 'inst' }
};
inst = room {
	nam = 'institute',
	pic = 'gfx/inst.png',
	dsc = [[
The building rises over the empty field of snow. Its sinister outline looks more like a jail rather than a research institute. There are railways  behind the building. ]],
	act = function(s, w)
		if w == 1 then  
			return 'The wall is 5 meters high. Moreover, there is barbed wire on its top, and I suppose it\'s alive...';
		end
		if w == 2 then
			return 'Yes, Vladimir was right... It\'s some sort of a military headquaters...';
		end
		if w == 3 then	
			return 'Yes — this looks like the van in which the man in gray coat took away my Barsik.';
		end
	end,
	used = function(s, w, b)
		if b == 'mybox' and w == 1 then
			return 'I think the guards will notice me at once.';
		end
		if w == 2 and b == 'gun' and gun._loaded then
			return 'I\'d get canned for that... Or just beaten... The guards are quite near.';
		end
		if w == 3 and b == 'gun' and gun._loaded then
			return 'I need the cat, not destruction...';
		end
	end,
	obj = {vobj(1, 'wall', 'The institute building is surrounded by a heavy concrete {wall}. There\'s a checkpoint at the centre.'),
		vobj(2, 'cameras', 'Survelliance {cameras} watch the area from the towers.'),
		vobj(3, 'van', 'Behind the gate I can see the black {van}.')},
	way = { 'road', 'kpp' },
	exit = function(s, t)
		if have('mybox') and t ~= 'inmycar' then
			return 'I won\'t walk around with the box...', false;
		end
	end,
};

cam = obj {
	nam = 'surveillance camera',
	dsc = function(s)
		if not s._broken then
			return 'One of the surveillance {cameras} isn\'t far from here. I press myself to the wall to stay unnoticed.';
		end
		return 'The shards of the surveillance {camera} are lying around. They\'re already dusted by snow.';
	end,
	act = function(s)
		if not s._broken then
			return 'Damned camera...';
		end
		return 'Ha... You\'ve had it coming, damned mechanism, hadn\'t you? I wonder when will the guards come...';
	end,
};

wire = obj {
	nam = 'barbed wire',
	dsc = function(s)
		if s._broken then
			return 'I can see the shreds of barbed {wire}.';
		end
		return 'I can see barbed {wire}.';
	end,
	act = function(s)
		if s._broken then
			return 'Now it\'s safe! I can get inside...';
		end
		return 'What if it\'s alive?';
	end,
};

onwall = room {
	pic = 'gfx/onwall.png',
	nam = 'on the wall',
	dsc = 'I am standing atop the boxes, my head is on the wall top level. It\'s cold.',
	enter = function(s)
		if have('mybox') then
			return 'I cannot climb the wall with a box in my hands.', false;
		end
		if wboxes._num < 5 then
			return 'I try to climb the wall... But it\'s still to high...',false;
		end
		return 'I climb the wall over the boxes.';
	end,
	obj = { 'wire' },
	way = { 'backwall' }
};

wboxes = obj {
	_num = 0,
	nam = function(s)
		if (s._num > 1) then
			return 'boxes by the wall';
		end
		return 'a box by the wall';
	end,
	act = function(s)
		return walk('onwall');
	end,
	dsc = function(s)
		if s._num == 0 then
			return;
		elseif s._num == 1 then
			return 'There is one {box} by the wall.';
		-- And again only one plural form
		-- elseif s._num < 5 then
		--	return 'There are '..tostring(s._num)..' {boxes}, stacked by the wall.';
		else	
			return 'There are '..tostring(s._num)..' {boxes}, stacked by the wall.';
		end
	end,
};

ewall = obj {
	nam = 'wall',
	dsc = 'Here {the wall} is 4 meters high. The howling snowdrift tosses snowflakes to its bottom.',
	act = function(s)
		if not s._ladder then
			s._ladder = true;
			shop2:pon(7);
		end
		return 'Too high... I\'ll need a ladder.';
	end
};

backwall = room {
	pic = 'gfx/instback.png',
	enter = function(s, f)
		local st = '';
		if ewall._stolen then
			ewall._stolen = false;
			st = 'Oho!!! Somebody has stolen my box!!!';
		end
		if f == 'inmycar'  then
			return 'Great... Looks like I managed to get here unnoticed...'..' '..st;
		end
		if f == 'onwall' then
			return
		end
		return 'Rambling through the snowfield I got to the back wall.'..' '..st;
	end,
	nam = 'eastern wall of the institute',
	dsc = 'I am at the back side of the institute.',
	obj = { 'ewall', 'cam' },
	way = { 'inst', },
	exit = function(s, t)
		if have('mybox') and t ~= 'inmycar' then
			return 'I won\'t walk around with the box in my hands...', false;
		end
	end,
};
