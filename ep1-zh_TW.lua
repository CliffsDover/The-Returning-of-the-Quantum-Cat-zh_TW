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
				return '我付了錢給弗拉迪米爾。';
			end
			return '我並不想毫無理由的付帳…';
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
		 [3] = '{巴西克} 坐在前座的乘客座位上。',
		 [4] = '{巴西克} 正在垃圾桶旁查看著某些東西…',
		 [5] = '{巴西克} snuggles up at my feet.',
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
	nam = '車子裡',
	dsc = '我在我的車子裡…我的主力戰駒。',
	pic = 'gfx/incar.png',
	way = {'forest', 'village'},
	enter = function(s, f)
		local s = '我打開車門，';
		if have('mybox') then
			return '我無法拿著這個箱子進到車子裡…', false;
		end
		if seen('mycat') then
			s = s..'巴西克跳了上車，'
			move('mycat','inmycar');
		elseif not me()._know_where then
			return '不行…我得先找到巴西克!', false
		end
		if f == 'guarddlg' then
			return 'Hmm... I\'ll have to come up with something...';
		end
		return cat(s, '嗯…該出發囉…');
	end,
	exit = function(s, t)
		local s=''
		if seen('mycat') then
			s = ' 巴西克先跳離了我的車。';
			move('mycat',t);
		end
		if ref(t) ~= from() then
			from().obj:del('mycar');
			move('mycar', t);
			return [[
這車勉強地發動著…經過一段不算短的路程，我終於把引擎關閉，並把門打開…]]..s;
		end
		return '等等…我想我好像忘了什麼東西…'..s;
	end
};

mycar = obj {
	nam = 'my car',
	desc = {
	[1] = '在小木屋的前方停著我的舊豐田{小貨車}。',
	[2] = '在停車位裡的是我的舊{小貨車}。',
	[3] = '我的{小貨車}停在檢查哨的附近。',
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
	nam = '絕緣膠帶',
	inv = '一卷藍色的絕緣膠帶…',
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
	nam = '捕捉器',
	dsc = '在雪地裡有個{鋼製捕捉器}。', -- !!!!
	tak = '該死的盜獵者! 我要把這個捕捉器帶走。',
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
	nam = '黑色車子',
	dsc = '在店旁有輛有著有色玻璃的黑色{汽車}。',
	act = '嗯…這是台廂型車…軍規車體…這可以明顯地從它的輪載看得出來…',
};

guydlg = dlg {
	pic = 'gfx/guy.png',
	nam = '與流浪漢的對話',
	dsc = '我走了過去…他轉過身瞧了我一眼…是一位體型稍矮，戴著一頂破舊帽子，身穿一件破爛棉襖的男性。',
	obj = {
		[1] = phr('嗨! 有夠冷，不是嗎?', '嗯…是有點…'),
		[2] = phr('你怎麼會現在在大街上?', [[我原本在攻讀博士學位…我當時正在寫一篇物質結構的論文…但…過度操勞了我的頭腦…我試著要冷靜下來…然後我現在就在這裡了…]]),
		[3] = phr('你叫什麼名字?', '愛德華…'),
		[4] = _phr('剛剛我離開的時候，在你身旁有隻貓…牠在哪?', '嗯…', 'pon(5)'),
		[5] = _phr('對…是一隻普通的山貓，在雪地裡繞著垃圾桶散步。', '所以，那隻是你的貓? 嗯…', 'pon(6)');
		[6] = _phr('對…他是我的巴西克!多說一些!', 
'…嗯…我想是那個人帶走了牠…嗯… -- 我的背脊一陣發涼…', 'pon(7)'),
		[7] = _phr('哪裡...他去了哪裡?', '抱歉了…兄弟，我沒有看到…', 'shopdlg:pon(4); pon(8);'),
		[8] = phr('好的…沒什麼事了…', '…', 'pon(8); back()'),
	},
	exit = function()
		pon(1);
		return 'He turned back and continued rummaging in the dumpster bins...';
	end
};

guy = obj {
	nam = '流浪漢',
	dsc = '一位{流浪漢}正在垃圾桶中翻找。',
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
	return cat('我這時想起來我沒有帶錢…半點錢都沒有…^',back());
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
	nam = '彈匣',
	inv = '散彈槍彈匣，我很少用這些東西，大多用來對付盜獵者。',
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
	nam = '報紙',
	inv = [[
即時快報…<<近期設立於針葉林中的量子力學研究所，大力駁斥與異常現象有任何關聯>>…嗯…]],
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
	nam = '漢堡',
	inv = function()
		inv():del('hamb');
		return '我吃了點心…垃圾食物…';
	end
};

zerno = obj {
	nam = '穀粒',
	inv = '就只是蕎麥，蕎麥穀粒…',
};

shop2 = dlg {
	nam = '購買',
	pic = 'gfx/shopbuy.png',
	obj = { 
	[1] = phr('散彈槍彈匣…我需要一些彈藥…', '沒問題…老價錢!', ifmoney..'inv():add("shells")'),
	[2] = phr('穀粒…', '好的…', ifmoney..'inv():add("zerno")'),
	[3] = phr('還要一個漢堡…', '好…', ifmoney..'inv():add("hamb")'),
	[4] = phr('新出刊的報紙…', '當然沒問題…', ifmoney..'inv():add("news")'),
	[5] = phr('一卷絕緣膠帶…', '是的，在這兒。', ifmoney..'inv():add("iso")'),
	[6] = phr('沒別的了…', '隨你的便。', 'pon(6); back()'),
	[7] = _phr('Also I need a ladder and wire cutters...', 'Sorry, I don\'t have those — Vladimir shakes his head'), 
	},
	exit = function(s)
		if have('news') then
			s.obj[4]:disable();
		end
	end
};

shopdlg = dlg {
	nam = '和店員的對話',
	pic = 'gfx/shopman.png',
	dsc = '店員的圓溜小眼銳利地直盯著我看著。',
	obj = {
	[1] = phr('哈囉，弗拉迪米爾! 最近還好嗎?', '你好，'..me().nam..'…普普通通… - 弗拉迪米爾狡猾地笑著。', 'pon(2)'),
	[2] = _phr('我想要買一些東西。', '好的…咱們來看看你需要些什麼東西…', 'pon(2); return walk("shop2")'),
	[3] = phr('先掰了!…', '好的…祝你好運!', 'pon(3); return back();'),
	[4] = _phr('剛剛有個男人在這裡，他是誰?', '嗯? — 弗拉迪米爾挑起了一些他的細眉…','pon(5)'),
	[5] = _phr('不知道為什麼他帶走了我的貓…可能以為牠是流浪貓吧…那個穿灰色外套的人是誰?',
[[
事實上，他是某個老闆…弗拉迪米爾抓了一下他未刮鬍鬚的下巴。在一年前，建造在我們後方林中那間新的研究所…
弗拉迪米爾一邊說著，一邊抽動了一下他的夾鼻眼鏡。他常來我的店裡，不喜歡人群…那些物理學家…你知道的…老學究。弗拉迪米爾聳了聳肩…]],'pon(6)'),
	[6] = _phr('這個研究所在哪裡?', 
'路標127公里的地方…但…你知道的… 弗拉迪米爾降低了他的音量。 他的研究所有一些傳言…', 'me()._know_where = true; inmycar.way:add("inst");pon(7)'),
	[7] = _phr('我只想找回我的貓…', '小心一點…如果我是你的話…弗拉迪米爾搖了搖頭。 對了，我想他的名字是貝林，我曾看過他的信用卡…不過即使如此，如你所知，我並不接受使用信用卡。 弗拉迪米爾動了一下嘴唇，他的單片眼鏡也狡猾地動了一下。'),
	},
};

shopman = obj {
	nam = 'salesman',
	dsc = '在櫃檯後方有位{店員}。他留著鬍渣的寬臉，搭配著單片眼鏡。',
	act = function()
		return walk('shopdlg');
	end
};

shop = room {
	nam = '商店',
	pic = 'gfx/inshop.png',
	enter = function(s, f)
		if village.obj:look('truck') then
			village.obj:del('truck');
			village.obj:del('mycat');
			return [[
當我走進商店的時候，我差一點要撞上了一個穿著灰色外套、戴著寬邊帽，且令人不甚喜歡的男人…他發出了一個嘶聲，並作勢舉起帽子道了個歉…在帽緣之下，白色的牙齒閃了一下…當我到達了櫃檯，我聽見了引擎發動的聲音。]];
		end
	end, 
	act = function(s,w)
		if w == 1 then
			return '停車場上只剩下我的車子。';
		end
	end,
	dsc = [[
在某種程度上，這家店有點與眾不同。在這裡你可以找到鐵具、食物、甚至彈藥。這也難怪，畢竟這是方圓100公里內唯一的一家商店…]],
	way = { 'village' },
	obj = {'shopman',vobj(1, 'окно', '透過{窗戶}可以看見停車場。') },
	exit = function(s, t)
		if t ~= 'village' then
			return;
		end
		if shopman._wantmoney then
			return '正當我要踏出店門外時，弗拉迪米爾的輕咳聲讓我停住了腳步…當然啦…我還沒付帳…', false;
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
			return '我的手上已經拿了一個箱子…';
		end
		s._num = s._num - 1;
		if s._num == 0 then
			mycar.obj:del('carbox');
		end
		take('mybox');
		return '我從車上拿了一個箱子。';
	end,
	dsc = function(s)
		if s._num == 0 then
			return;
		elseif s._num == 1 then
			return '在車子貨箱上有一個{箱子}。';
		-- Again not needed, since "boxes" stays the same for all numerals
		-- elseif s._num < 5 then
		--	return 'There are '..tostring(s._num)..' {boxes} in the cargo body of my car.';
		elseif s._num == 2 then
			return '在車子貨箱上有二個{箱子}。';
		elseif s._num == 3 then
			return '在車子貨箱上有三個{箱子}。';
		elseif s._num == 4 then
			return '在車子貨箱上有四個{箱子}。';
		elseif s._num == 5 then
			return '在車子貨箱上有五個{箱子}。';
		end
	end,
};

mybox = obj {
	nam = '箱子',
	inv = '我正拿著個一製作完善的木箱…也許會派上用場。',
	use = function(s, o)
		if o == 'boxes' then
			inv():del('mybox');
			return '我把箱子放了回去…';
		end
		if o == 'mycar' then
			inv():del('mybox');
			mycar.obj:add('carbox');
			carbox._num = carbox._num + 1;
			return '我把箱子放進我的車子的貨箱裡…';
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
	nam = '{木箱}',
	desc = {
		[1] = '在停車位的附近有許多原本用來裝罐頭的空{木箱}。',
	},
	dsc = function(s)
		local state = 1;
		return s.desc[state];
	end,
	act = function(s, t)
		if carbox._num >= 5 then
			return '也許我已經拿了夠多的箱子了…?';
		end
		if inv():srch('mybox') then
			return '我正拿著一個箱子…';
		end
		take('mybox');
		return '我拿了一個箱子。';
	end,
};

village = room {
	nam = '商店前方的停車位',
	dsc = '商店前方是我所熟悉的停車位，已被白雪完全的覆蓋…',
	pic = 'gfx/shop.png',
	act = function(s, w)
		if w == 1 then
			return '普通的桶子…白雪覆蓋住了垃圾。';
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
			return '我匆匆望向停車場，大叫著-- 巴西克! 巴西克! -- 我的貓消失去哪裡了?';
		end
	end,
	way = { 'road', 'shop' },
	obj = { 'truck', vobj(1,'bins', '生鏽的垃圾{桶}被白雪覆蓋。'), 'guy','boxes' },
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
	nam = '檢查哨',
	pic = 'gfx/kpp.png',
	dsc = [[The checkpoint leaves no doubt that strangers are not welcome in the institute. Lift gate. Latticed kiosk. And silence.
]],
	obj = { 'guard' },
	way = { 'inst' }
};
inst = room {
	nam = '研究所',
	pic = 'gfx/inst.png',
	dsc = [[
這棟建築物矗立在覆蓋著白雪的空地上，與其說是一個研究機構，險惡的外觀讓它看起來更像是一座監獄。 在建築物的後面有鐵路。]],
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
	obj = {vobj(1, 'wall', '研究所的建築物被厚重的水泥{牆}所圍繞。有個檢查哨在中央。'),
		vobj(2, 'cameras', '監視{攝影機}從高塔上看著這片區域。'),
		vobj(3, 'van', '在圍欄後面我可以看見黑色{廂型車}。')},
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
