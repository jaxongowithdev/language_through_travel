// Nội dung chủ đề 1–5: chào hỏi, giới thiệu bản thân, ngày thường, số và lịch
// hẹn, thời tiết. Xem quy ước bảng ở lib/data/parser.dart.
//
// Nhắc lại ba luật khi sửa file này:
//   * cột ngăn bằng `|`, nội dung không được chứa `|`;
//   * chuỗi Dart dùng nháy kép nên nội dung không dùng nháy kép và không dùng
//     ký tự đô-la (viết dollars bằng chữ);
//   * dòng `#` mở nhóm mới.

// --- 1. smalltalk ----------------------------------------------------------

const List<String> smalltalkLines = <String>[
  "#|Mở lời|Bắt chuyện với người mới gặp mà không gượng",
  "Hi, I don't think we've met. I'm Minh.|Chào bạn, hình như mình chưa gặp nhau. Mình là Minh.|Câu mở lời an toàn nhất ở tiệc, hội thảo, lớp học mới.",
  "Is this seat taken?|Ghế này có ai ngồi chưa ạ?|Hỏi trước khi ngồi xuống, dùng được ở quán, thư viện, phòng chờ.",
  "How do you know the host?|Bạn quen chủ nhà kiểu gì thế?|Câu kinh điển ở tiệc: ai cũng trả lời được nên không sợ bí.",
  "First time here?|Lần đầu bạn tới đây à?|Ngắn, nhẹ, hợp khi cả hai đang đứng chờ.",
  "That's a great bag. Where did you get it?|Túi đẹp quá. Bạn mua ở đâu vậy?|Khen một món đồ cụ thể an toàn hơn khen ngoại hình.",
  "The line is longer than I expected.|Hàng dài hơn mình tưởng đấy.|Than phiền nhẹ về hoàn cảnh chung là cách bắt chuyện rất tự nhiên.",
  "Sorry, could I squeeze past you?|Xin lỗi, cho mình lách qua một chút nhé?|Squeeze past nghĩa là đi lách qua chỗ hẹp.",
  "Are you here for the workshop too?|Bạn cũng tới dự buổi workshop à?|Dùng too ở cuối để ngụ ý mình cũng vậy.",
  "#|Giữ mạch chuyện|Hỏi tiếp để câu chuyện không bị chết giữa chừng",
  "Oh really? Tell me more about that.|Ồ thật à? Kể thêm cho mình nghe đi.|Câu vạn năng khi bạn chưa biết hỏi gì tiếp.",
  "How did you get into that?|Bạn bén duyên với việc đó thế nào?|Get into something nghĩa là bắt đầu quan tâm hoặc theo đuổi.",
  "That sounds tough. How are you handling it?|Nghe vất vả nhỉ. Bạn xoay xở sao?|Thể hiện đồng cảm rồi mới hỏi tiếp.",
  "Same here, actually.|Mình cũng vậy đấy.|Actually ở cuối làm câu nghe thân mật hơn.",
  "I've never thought about it that way.|Mình chưa bao giờ nghĩ theo hướng đó.|Cách khen ý kiến người khác mà không xu nịnh.",
  "What do you like most about it?|Bạn thích nhất điểm nào ở việc đó?|Câu hỏi mở, người nghe sẽ nói dài.",
  "Sorry, I didn't catch your name.|Xin lỗi, mình chưa nghe rõ tên bạn.|Catch ở đây nghĩa là nghe kịp, không phải bắt lấy.",
  "Wait, so you two work together?|Khoan, vậy hai bạn làm cùng chỗ à?|Kéo người thứ ba vào câu chuyện cho khỏi lạc lõng.",
  "#|Kết thúc đẹp|Rút lui lịch sự và mở đường gặp lại",
  "It was really nice talking to you.|Nói chuyện với bạn vui thật đấy.|Câu chốt chuẩn mực, dùng được trong mọi hoàn cảnh.",
  "I should go say hi to a few people.|Mình phải đi chào vài người nữa.|Lý do rút lui lịch sự, không ai phật lòng.",
  "Let me grab your contact before I forget.|Cho mình xin liên lạc kẻo lát nữa quên.|Grab dùng rất đời thường, nghĩa là lấy nhanh.",
  "Are you on LinkedIn?|Bạn có dùng LinkedIn không?|Hỏi kênh liên lạc chung, tự nhiên hơn xin số điện thoại.",
  "Let's keep in touch.|Giữ liên lạc nhé.|Keep in touch là cụm cố định, không đổi giới từ.",
  "I hope our paths cross again.|Mong là mình còn gặp lại nhau.|Hơi văn vẻ, hợp khi chia tay ở hội thảo.",
  "Enjoy the rest of your evening.|Chúc bạn có buổi tối vui vẻ nốt nhé.|Enjoy the rest of your day hay dùng khi chia tay giữa chừng.",
  "Say hi to your team for me.|Cho mình gửi lời chào tới cả nhóm bạn nhé.|Say hi to someone for me là mẫu câu gửi lời hỏi thăm.",
];

const List<String> smalltalkWords = <String>[
  "acquaintance|/əˈkweɪntəns/|n|người quen, chưa thân|She is just an acquaintance from work.|Cô ấy chỉ là người quen ở chỗ làm.",
  "mingle|/ˈmɪŋɡl/|v|đi lại trò chuyện với nhiều người|Let's mingle a bit before dinner.|Mình giao lưu chút trước bữa tối nhé.",
  "awkward|/ˈɔːkwərd/|adj|ngượng, gượng gạo|There was an awkward silence.|Có một khoảng im lặng ngượng ngùng.",
  "chat|/tʃæt/|v, n|tán gẫu, chuyện phiếm|We had a quick chat in the hallway.|Bọn mình nói chuyện nhanh ở hành lang.",
  "icebreaker|/ˈaɪsbreɪkər/|n|câu hoặc trò phá băng|That question is a good icebreaker.|Câu hỏi đó phá băng rất tốt.",
  "outgoing|/ˈaʊtɡoʊɪŋ/|adj|hoà đồng, hướng ngoại|My sister is far more outgoing than I am.|Chị mình hướng ngoại hơn mình nhiều.",
  "polite|/pəˈlaɪt/|adj|lịch sự|It is polite to let them finish first.|Để họ nói hết là phép lịch sự.",
  "casual|/ˈkæʒuəl/|adj|xuề xoà, thân mật|It was just a casual conversation.|Đó chỉ là cuộc nói chuyện thân mật thôi.",
  "compliment|/ˈkɑːmplɪmənt/|n, v|lời khen, khen|He gave me a nice compliment.|Anh ấy khen mình một câu dễ thương.",
  "acquainted|/əˈkweɪntɪd/|adj|đã làm quen|We got acquainted at a conference.|Bọn mình quen nhau ở một hội thảo.",
];

const List<String> smalltalkTalk = <String>[
  "#|Gặp lại người quen cũ|Trong thang máy toà nhà văn phòng, sáng thứ Hai",
  "Lan|Minh? Is that you?|Minh hả? Có phải bạn không?",
  ">Bạn|Lan! Wow, it's been ages.|Lan! Chà, lâu lắm rồi.",
  "Lan|I know. Do you work in this building now?|Ừ nhỉ. Giờ bạn làm ở toà này à?",
  ">Bạn|Yes, I started last month. Eighth floor.|Ừ, mình mới vào tháng trước. Tầng tám.",
  "Lan|No way, I'm on the tenth. We should grab lunch.|Không thể tin được, mình tầng mười. Hôm nào đi ăn trưa đi.",
  ">Bạn|I'd love that. Are you free on Thursday?|Mình rất muốn. Thứ Năm bạn rảnh không?",
  "Lan|Thursday works. I'll message you.|Thứ Năm được. Mình nhắn cho bạn nhé.",
  ">Bạn|Perfect. Great seeing you, Lan.|Tuyệt. Gặp bạn vui lắm, Lan.",
];

// --- 2. selfintro ----------------------------------------------------------

const List<String> selfintroLines = <String>[
  "#|Ba câu về mình|Tự giới thiệu gọn trong ba mươi giây",
  "I'm Trang, I work in marketing.|Mình là Trang, mình làm marketing.|Tên trước, nghề sau: đúng thứ tự người bản ngữ hay dùng.",
  "I'm originally from Hue, but I live in Da Nang now.|Mình quê ở Huế, giờ sống ở Đà Nẵng.|Originally from dùng cho quê gốc, live in cho nơi ở hiện tại.",
  "I've been doing this for about three years.|Mình làm việc này khoảng ba năm rồi.|Hiện tại hoàn thành tiếp diễn cho việc bắt đầu trong quá khứ và còn tiếp.",
  "I studied economics, but I ended up in design.|Mình học kinh tế, nhưng cuối cùng lại làm thiết kế.|End up doing something nghĩa là rốt cuộc lại làm việc gì.",
  "Outside of work, I run and I cook a lot.|Ngoài giờ làm, mình chạy bộ và nấu ăn nhiều.|Outside of work mở đầu phần sở thích rất tự nhiên.",
  "I'm the middle child of three.|Mình là con giữa trong nhà ba anh chị em.|Middle child, oldest child, youngest child là ba cách nói thứ tự.",
  "People usually call me Trang, no middle name needed.|Mọi người cứ gọi mình là Trang thôi.|Câu hữu ích khi tên tiếng Việt bị đọc sai.",
  "I moved here for the job, and I stayed for the food.|Mình chuyển tới đây vì công việc, rồi ở lại vì đồ ăn.|Câu đùa nhẹ giúp phần giới thiệu đỡ khô.",
  "#|Nói về công việc|Trả lời câu hỏi bạn làm nghề gì mà không nhàm",
  "What do you do for a living?|Bạn làm nghề gì để sống?|For a living là cách hỏi nghề nghiệp thông dụng nhất.",
  "I help small shops sell online.|Mình giúp các cửa hàng nhỏ bán hàng trên mạng.|Nói mình giúp ai làm gì dễ hình dung hơn nêu chức danh.",
  "I'm a nurse at a children's hospital.|Mình là y tá ở bệnh viện nhi.|Nêu nơi làm việc ngay sau chức danh.",
  "I work remotely for a company in Singapore.|Mình làm từ xa cho một công ty ở Singapore.|Work remotely, work from home, work on site là ba kiểu.",
  "I'm between jobs at the moment.|Hiện mình đang trong giai đoạn chuyển việc.|Cách nói lịch sự khi đang thất nghiệp.",
  "I run a small coffee shop with my brother.|Mình mở một quán cà phê nhỏ cùng anh trai.|Run a business nghĩa là điều hành, không phải chạy.",
  "I'm still a student, final year.|Mình vẫn đang là sinh viên, năm cuối.|Final year, freshman year là cách nói năm học.",
  "It's busy, but I like the people I work with.|Cũng bận, nhưng mình quý đồng nghiệp.|Thêm một câu cảm nhận để câu trả lời không cụt lủn.",
  "#|Sở thích và con người bạn|Kể chuyện riêng đủ để người nghe muốn hỏi thêm",
  "I'm learning to swim at thirty. It's humbling.|Ba mươi tuổi mình mới học bơi. Cũng ngượng phết.|Humbling nghĩa là làm mình bớt tự cao, ý khiêm tốn.",
  "I'm a morning person, so I go to bed early.|Mình là người dậy sớm nên ngủ sớm.|Trái nghĩa là night owl, người thức khuya.",
  "I collect fridge magnets from every city I visit.|Mình sưu tầm nam châm tủ lạnh ở mọi thành phố từng đi.|Chi tiết nhỏ và lạ khiến người nghe nhớ bạn.",
  "I can't cook, but I'm very good at ordering.|Mình không biết nấu, nhưng gọi đồ ăn thì rất giỏi.|Cấu trúc be good at doing something.",
  "I speak Vietnamese, English, and a little Japanese.|Mình nói tiếng Việt, tiếng Anh và một chút tiếng Nhật.|A little đứng trước tên ngôn ngữ, không cần mạo từ.",
  "I'd love to learn how to play the guitar.|Mình rất muốn học chơi ghi ta.|Would love to là cách nói mong muốn nhẹ nhàng.",
  "My weekends are pretty quiet, honestly.|Nói thật thì cuối tuần của mình khá yên tĩnh.|Honestly ở cuối câu giữ giọng chân thành.",
  "I'm not great with names, so bear with me.|Mình nhớ tên kém lắm, bạn thông cảm nhé.|Bear with me nghĩa là kiên nhẫn với mình một chút.",
];

const List<String> selfintroWords = <String>[
  "background|/ˈbækɡraʊnd/|n|xuất thân, nền tảng học vấn|My background is in engineering.|Nền tảng của mình là kỹ thuật.",
  "hometown|/ˈhoʊmtaʊn/|n|quê nhà|My hometown is a small coastal town.|Quê mình là một thị trấn ven biển nhỏ.",
  "career|/kəˈrɪr/|n|sự nghiệp|I changed career at thirty-two.|Mình đổi nghề năm ba mươi hai tuổi.",
  "colleague|/ˈkɑːliːɡ/|n|đồng nghiệp|My colleagues are all younger than me.|Đồng nghiệp mình đều trẻ hơn mình.",
  "graduate|/ˈɡrædʒuət/|n, v|người tốt nghiệp, tốt nghiệp|I graduated in 2019.|Mình tốt nghiệp năm 2019.",
  "freelance|/ˈfriːlæns/|adj, v|làm tự do|She works freelance as a translator.|Cô ấy làm biên dịch tự do.",
  "responsible|/rɪˈspɑːnsəbl/|adj|chịu trách nhiệm|I'm responsible for the newsletter.|Mình phụ trách bản tin.",
  "passionate|/ˈpæʃənət/|adj|đam mê|He is passionate about street food.|Anh ấy đam mê đồ ăn đường phố.",
  "introduce|/ˌɪntrəˈduːs/|v|giới thiệu|Let me introduce my teammate.|Để mình giới thiệu đồng đội của mình.",
  "nickname|/ˈnɪkneɪm/|n|biệt danh|Everyone calls me by my nickname.|Ai cũng gọi mình bằng biệt danh.",
];

const List<String> selfintroTalk = <String>[
  "#|Ngày đầu ở lớp học buổi tối|Lớp tiếng Anh buổi tối, giờ giải lao",
  "Giáo viên|Let's go around. Tell us your name and one thing about you.|Mình đi một vòng nhé. Nói tên và một điều về bạn.",
  ">Bạn|Hi everyone, I'm Trang. I work in marketing.|Chào cả lớp, mình là Trang. Mình làm marketing.",
  "Giáo viên|Great. And why are you learning English?|Tốt. Vậy bạn học tiếng Anh để làm gì?",
  ">Bạn|My team is in Singapore, so I need it every day.|Nhóm của mình ở Singapore nên ngày nào mình cũng cần.",
  "Giáo viên|That's a strong reason. What is hardest for you?|Lý do rất chắc. Bạn thấy phần nào khó nhất?",
  ">Bạn|Speaking. I understand a lot, but I freeze up.|Nói ạ. Mình hiểu nhiều, nhưng cứ nói là đơ.",
  "Giáo viên|You are not alone here. That is what this class is for.|Bạn không phải người duy nhất đâu. Lớp này sinh ra vì thế.",
  ">Bạn|Good to hear. Thank you.|Nghe vậy mình yên tâm. Cảm ơn thầy.",
];

// --- 3. daily --------------------------------------------------------------

const List<String> dailyLines = <String>[
  "#|Buổi sáng|Kể lại buổi sáng của bạn bằng thì hiện tại đơn",
  "I usually get up around six thirty.|Mình thường dậy khoảng sáu rưỡi.|Around dùng cho giờ ước chừng, tự nhiên hơn about trong nói.",
  "I hit snooze at least twice.|Mình bấm báo lại ít nhất hai lần.|Hit snooze là cụm cố định cho nút báo lại.",
  "I have coffee before I check my phone.|Mình uống cà phê trước khi xem điện thoại.|Have coffee tự nhiên hơn drink coffee trong sinh hoạt.",
  "I take the bus to work, it takes forty minutes.|Mình đi xe buýt đi làm, mất bốn mươi phút.|Take the bus, take a taxi, nhưng ride a bike.",
  "I skip breakfast on busy days.|Ngày bận thì mình bỏ bữa sáng.|Skip a meal nghĩa là bỏ một bữa.",
  "I get to the office just before nine.|Mình tới văn phòng ngay trước chín giờ.|Get to somewhere nhấn vào việc tới nơi.",
  "My mornings are always a bit rushed.|Buổi sáng của mình lúc nào cũng hơi vội.|Rushed nghĩa là vội vàng, cập rập.",
  "I water the plants while the kettle boils.|Mình tưới cây trong lúc chờ ấm nước sôi.|While cho hai việc xảy ra cùng lúc.",
  "#|Giữa ngày|Nói về giờ làm, giờ nghỉ và những việc lặt vặt",
  "I take a short break every couple of hours.|Cứ vài tiếng mình lại nghỉ một chút.|A couple of hours nghĩa là chừng hai ba tiếng.",
  "I eat lunch at my desk more often than I should.|Mình ăn trưa tại bàn nhiều hơn mức nên có.|More often than I should là cách tự trách nhẹ.",
  "I run errands during my lunch break.|Mình tranh thủ giờ nghỉ trưa chạy việc vặt.|Run errands là cụm cố định cho việc vặt ngoài phố.",
  "The afternoon is when I get the most done.|Buổi chiều là lúc mình làm được nhiều việc nhất.|Get something done nghĩa là hoàn thành việc gì.",
  "I try to leave the office by six.|Mình cố rời văn phòng trước sáu giờ.|By six nghĩa là chậm nhất sáu giờ.",
  "I pick up my son on the way home.|Mình đón con trai trên đường về.|Pick someone up nghĩa là đón ai đó.",
  "Some days just disappear.|Có những ngày trôi qua lúc nào không hay.|Câu than nhẹ rất hay dùng khi kể chuyện.",
  "I do the grocery shopping on Wednesdays.|Mình đi chợ siêu thị vào thứ Tư.|On Wednesdays nghĩa là thứ Tư hằng tuần.",
  "#|Buổi tối|Kể thói quen buổi tối và cuối tuần",
  "I cook dinner three or four nights a week.|Một tuần mình nấu cơm tối ba bốn buổi.|Nights a week là cách đếm tần suất.",
  "After dinner we go for a walk around the block.|Ăn tối xong cả nhà đi bộ quanh khu.|Around the block nghĩa là một vòng quanh khu phố.",
  "I watch one episode and promise myself that's it.|Mình xem một tập rồi tự hứa là dừng.|That's it ở đây nghĩa là chỉ thế thôi.",
  "I'm usually in bed by eleven.|Mình thường lên giường trước mười một giờ.|Be in bed nhấn trạng thái, go to bed nhấn hành động.",
  "I charge my phone in the other room.|Mình sạc điện thoại ở phòng khác.|Mẹo ngủ ngon rất hay được nhắc tới.",
  "Weekends are for laundry and long naps.|Cuối tuần dành cho giặt giũ và ngủ nướng.|Be for something nghĩa là dành cho việc gì.",
  "I try not to work on Sundays.|Mình cố không làm việc vào Chủ nhật.|Try not to do something, không phải try to not.",
  "I sleep in on Saturday if nobody wakes me.|Thứ Bảy mình ngủ nướng nếu không ai gọi dậy.|Sleep in nghĩa là ngủ dậy muộn có chủ ý.",
];

const List<String> dailyWords = <String>[
  "routine|/ruːˈtiːn/|n|thói quen, nếp sinh hoạt|My morning routine takes twenty minutes.|Nếp sáng của mình mất hai mươi phút.",
  "commute|/kəˈmjuːt/|n, v|đường đi làm, đi làm xa|My commute is about an hour.|Đường đi làm của mình khoảng một tiếng.",
  "errand|/ˈerənd/|n|việc vặt phải chạy ra ngoài|I have two errands to run.|Mình có hai việc vặt phải chạy.",
  "chore|/tʃɔːr/|n|việc nhà|We split the chores evenly.|Bọn mình chia đều việc nhà.",
  "nap|/næp/|n, v|giấc ngủ ngắn|A short nap helps a lot.|Ngủ ngắn giúp ích nhiều lắm.",
  "laundry|/ˈlɔːndri/|n|đồ giặt, việc giặt giũ|The laundry can wait.|Đồ giặt để lát nữa cũng được.",
  "leftovers|/ˈleftoʊvərz/|n|đồ ăn thừa|We had leftovers for lunch.|Bữa trưa bọn mình ăn đồ thừa.",
  "productive|/prəˈdʌktɪv/|adj|hiệu quả, năng suất|That was a productive morning.|Đó là một buổi sáng hiệu quả.",
  "exhausted|/ɪɡˈzɔːstɪd/|adj|kiệt sức|I was exhausted by Friday.|Tới thứ Sáu là mình kiệt sức.",
  "schedule|/ˈskedʒuːl/|n, v|lịch trình, xếp lịch|My schedule is packed today.|Hôm nay lịch mình kín đặc.",
];

const List<String> dailyTalk = <String>[
  "#|Hai đồng nghiệp nói chuyện giờ giấc|Bàn ăn trong bếp văn phòng, giờ nghỉ trưa",
  "Huy|You look tired. Late night?|Trông bạn mệt thế. Thức khuya à?",
  ">Bạn|Sort of. My son woke up twice.|Kiểu vậy. Thằng bé nhà mình dậy hai lần.",
  "Huy|Ouch. How do you still get here on time?|Ôi. Vậy mà bạn vẫn tới đúng giờ được à?",
  ">Bạn|I prepare everything the night before.|Mình chuẩn bị hết từ tối hôm trước.",
  "Huy|Smart. I always run out of time in the morning.|Khôn đấy. Sáng nào mình cũng không kịp giờ.",
  ">Bạn|Try packing your bag before bed. It helps.|Thử soạn cặp trước khi ngủ xem. Hiệu quả lắm.",
  "Huy|I'll give it a go this week.|Tuần này mình thử xem sao.",
  ">Bạn|Let me know if it works for you.|Nếu hợp thì báo mình biết nhé.",
];

// --- 4. numbers ------------------------------------------------------------

const List<String> numbersLines = <String>[
  "#|Đọc số cho đúng|Số lớn, số lẻ và số thứ tự",
  "It costs one hundred and twenty thousand dong.|Cái đó giá một trăm hai mươi nghìn đồng.|Người Anh thêm and, người Mỹ hay bỏ: one hundred twenty.",
  "My number is oh nine one, double four, seven.|Số mình là không chín một, bốn bốn, bảy.|Đọc số điện thoại theo cụm, số 0 đọc là oh.",
  "The room is on the twenty-third floor.|Phòng ở tầng hai mươi ba.|Số thứ tự cần đuôi rd, th, st.",
  "Round it up to fifty.|Làm tròn lên năm mươi đi.|Round up là làm tròn lên, round down là làm tròn xuống.",
  "That's about a third of the total.|Chừng một phần ba tổng số.|Phân số: a third, two thirds, a quarter.",
  "The file is twelve point five megabytes.|File nặng mười hai phẩy năm megabyte.|Dấu phẩy thập phân đọc là point.",
  "There were roughly two hundred people.|Có khoảng hai trăm người.|Roughly, about, around đều nghĩa là khoảng.",
  "Prices went up by fifteen percent.|Giá tăng mười lăm phần trăm.|Go up by, go down by cho mức thay đổi.",
  "#|Giờ giấc|Nói giờ và khoảng thời gian",
  "It's a quarter past seven.|Bảy giờ mười lăm.|Quarter past là hơn mười lăm phút.",
  "Let's meet at half five.|Gặp nhau lúc năm rưỡi nhé.|Half five là cách nói Anh, tức 5:30.",
  "The train leaves at eighteen forty.|Tàu chạy lúc mười tám giờ bốn mươi.|Giờ tàu xe hay đọc kiểu hai bốn tiếng.",
  "I'll be there in ten minutes, tops.|Mười phút nữa mình tới, nhiều nhất là thế.|Tops ở cuối câu nghĩa là tối đa.",
  "We're running about fifteen minutes behind.|Bọn mình đang trễ khoảng mười lăm phút.|Run behind nghĩa là chậm so với lịch.",
  "Can we push it back an hour?|Dời lại muộn hơn một tiếng được không?|Push back là dời muộn, move up là dời sớm.",
  "The shop opens from nine to nine.|Cửa hàng mở từ chín giờ sáng tới chín giờ tối.|From nine to nine là cách nói gọn.",
  "It only takes a couple of minutes.|Chỉ mất vài phút thôi.|A couple of nghĩa là hai hoặc vài.",
  "#|Ngày tháng và hẹn gặp|Chốt lịch mà không hiểu nhầm",
  "How does Tuesday afternoon sound?|Chiều thứ Ba nghe thế nào?|How does something sound là cách đề xuất mềm mỏng.",
  "I'm free any time after four.|Sau bốn giờ lúc nào mình cũng rảnh.|Any time after là mẫu câu nêu khung giờ rảnh.",
  "Let's say the fifth of next month.|Cứ chốt là mùng năm tháng sau nhé.|Let's say dùng khi đề xuất một con số cụ thể.",
  "Does the twelfth work for you?|Ngày mười hai bạn có tiện không?|Work for someone nghĩa là hợp lịch ai đó.",
  "Something came up. Can we reschedule?|Mình có việc đột xuất. Dời lịch được không?|Something came up là lý do lịch sự và phổ biến.",
  "I'll put it in the calendar now.|Mình cho vào lịch luôn đây.|Put it in the calendar hoặc add it to my calendar.",
  "Just to confirm, that's Friday the ninth.|Xác nhận lại nhé, thứ Sáu ngày mùng chín.|Nhắc lại cả thứ và ngày để tránh nhầm.",
  "I'll send a reminder the day before.|Mình sẽ nhắc lại trước một hôm.|The day before nghĩa là hôm trước đó.",
];

const List<String> numbersWords = <String>[
  "approximately|/əˈprɑːksɪmətli/|adv|khoảng chừng|It takes approximately two hours.|Việc đó mất khoảng hai tiếng.",
  "deadline|/ˈdedlaɪn/|n|hạn chót|The deadline is Friday noon.|Hạn chót là trưa thứ Sáu.",
  "fortnight|/ˈfɔːrtnaɪt/|n|hai tuần|We meet once a fortnight.|Hai tuần bọn mình gặp một lần.",
  "decade|/ˈdekeɪd/|n|thập kỷ|She has lived here for a decade.|Cô ấy sống ở đây mười năm rồi.",
  "quarter|/ˈkwɔːrtər/|n|một phần tư, quý|Sales rose in the third quarter.|Doanh số tăng trong quý ba.",
  "estimate|/ˈestɪmət/|n, v|ước tính|That is just a rough estimate.|Đó chỉ là con số ước tính thô.",
  "double|/ˈdʌbl/|v, adj|gấp đôi|The price has doubled since last year.|Giá đã gấp đôi so với năm ngoái.",
  "overdue|/ˌoʊvərˈduː/|adj|quá hạn|The report is two days overdue.|Báo cáo quá hạn hai ngày.",
  "punctual|/ˈpʌŋktʃuəl/|adj|đúng giờ|He is always punctual.|Anh ấy luôn đúng giờ.",
  "postpone|/poʊˈspoʊn/|v|hoãn lại|They postponed the trip.|Họ hoãn chuyến đi.",
];

const List<String> numbersTalk = <String>[
  "#|Chốt lịch họp qua tin nhắn thoại|Hai người đồng nghiệp sắp xếp một buổi gặp",
  "Mai|Are you free this week for a quick call?|Tuần này bạn rảnh gọi nhanh một buổi không?",
  ">Bạn|Sure. Wednesday or Thursday works for me.|Được chứ. Thứ Tư hay thứ Năm đều được.",
  "Mai|Thursday then. Two o'clock?|Vậy thứ Năm nhé. Hai giờ được không?",
  ">Bạn|Could we push it to three? I have a class at two.|Dời sang ba giờ được không? Hai giờ mình có lớp.",
  "Mai|Three is fine. Thirty minutes should be enough.|Ba giờ ổn. Ba mươi phút chắc là đủ.",
  ">Bạn|Perfect. Just to confirm, Thursday the eighth at three.|Chuẩn rồi. Xác nhận lại nhé, thứ Năm mùng tám, ba giờ.",
  "Mai|That's right. I'll send the link tomorrow.|Đúng rồi. Mai mình gửi đường dẫn.",
  ">Bạn|Great, talk then.|Tuyệt, hẹn gặp lúc đó.",
];

// --- 5. weather ------------------------------------------------------------

const List<String> weatherLines = <String>[
  "#|Trời hôm nay|Mô tả thời tiết bằng câu người bản ngữ hay dùng",
  "It's boiling out there.|Ngoài kia nóng như đổ lửa.|Boiling là cách nói cường điệu cho rất nóng.",
  "It's pouring, don't go out yet.|Mưa như trút, khoan ra ngoài đã.|Pour nghĩa là mưa rất to.",
  "It's a bit chilly this morning.|Sáng nay hơi se lạnh.|Chilly nhẹ hơn cold, hợp cho trời mát.",
  "The humidity is unbearable today.|Hôm nay ẩm không chịu nổi.|Humidity là độ ẩm, rất hợp khí hậu Việt Nam.",
  "It's drizzling, you won't need an umbrella.|Mưa lất phất thôi, không cần ô đâu.|Drizzle là mưa phùn.",
  "There's not a cloud in the sky.|Trời không một gợn mây.|Câu cố định, không đổi trật tự.",
  "It's supposed to clear up by noon.|Nghe nói trưa thì trời hửng.|Clear up nghĩa là trời quang trở lại.",
  "The wind is picking up.|Gió đang mạnh dần.|Pick up ở đây nghĩa là tăng dần.",
  "#|Dự báo và kế hoạch|Nói về thời tiết sắp tới và đổi kế hoạch theo trời",
  "They say it'll rain all weekend.|Nghe nói cuối tuần mưa suốt.|They say dùng cho tin đồn hoặc dự báo.",
  "There's a typhoon warning for the coast.|Có cảnh báo bão cho vùng ven biển.|Typhoon dùng ở châu Á, hurricane ở châu Mỹ.",
  "We might have to move the picnic indoors.|Có khi phải chuyển buổi picnic vào trong nhà.|Might have to nghĩa là có thể sẽ phải.",
  "Take a jacket just in case.|Cầm theo áo khoác cho chắc.|Just in case nghĩa là phòng khi.",
  "The forecast looks good for Sunday.|Dự báo Chủ nhật đẹp trời.|Forecast là dự báo thời tiết.",
  "It's cooling down in the evenings now.|Buổi tối giờ mát dần rồi.|Cool down cho trời dịu mát.",
  "Flights are delayed because of the fog.|Các chuyến bay bị hoãn vì sương mù.|Because of đứng trước danh từ, because đứng trước mệnh đề.",
  "I hope it holds off until we get home.|Mong là trời nhịn mưa tới khi bọn mình về nhà.|Hold off nghĩa là chưa xảy ra, còn nén lại.",
  "#|Mùa và khí hậu|So sánh các mùa và nói bạn hợp kiểu thời tiết nào",
  "The rainy season starts around May here.|Ở đây mùa mưa bắt đầu quãng tháng Năm.|Rainy season và dry season là hai mùa chính.",
  "I prefer autumn to summer.|Mình thích mùa thu hơn mùa hè.|Prefer A to B, không dùng than.",
  "Winters here are mild compared to Hanoi.|Mùa đông ở đây nhẹ hơn Hà Nội nhiều.|Compared to là mẫu so sánh thông dụng.",
  "It never snows where I grew up.|Chỗ mình lớn lên chưa bao giờ có tuyết.|Where I grew up là mệnh đề chỉ nơi chốn.",
  "The heat doesn't bother me much.|Nóng thì mình cũng không ngại lắm.|Bother someone nghĩa là làm phiền, khó chịu.",
  "Spring is short but it's my favourite.|Mùa xuân ngắn nhưng mình thích nhất.|Favourite kiểu Anh, favorite kiểu Mỹ.",
  "We get a lot of sunshine in March.|Tháng Ba ở đây nhiều nắng lắm.|Sunshine không đếm được nên dùng a lot of.",
  "It's been unusually warm this year.|Năm nay ấm bất thường.|Unusually đứng trước tính từ để nhấn sự khác lạ.",
];

const List<String> weatherWords = <String>[
  "forecast|/ˈfɔːrkæst/|n, v|dự báo|The forecast says heavy rain.|Dự báo nói mưa to.",
  "humid|/ˈhjuːmɪd/|adj|ẩm ướt|It gets very humid in June.|Tháng Sáu trời rất ẩm.",
  "breeze|/briːz/|n|làn gió nhẹ|There is a nice breeze tonight.|Tối nay có làn gió mát.",
  "drizzle|/ˈdrɪzl/|n, v|mưa phùn|It drizzled all afternoon.|Cả buổi chiều mưa phùn.",
  "downpour|/ˈdaʊnpɔːr/|n|trận mưa như trút|We got caught in a downpour.|Bọn mình bị mắc mưa lớn.",
  "flood|/flʌd/|n, v|lũ, ngập|The street floods every year.|Con phố này năm nào cũng ngập.",
  "overcast|/ˈoʊvərkæst/|adj|u ám, nhiều mây|The sky was overcast all day.|Cả ngày trời u ám.",
  "freezing|/ˈfriːzɪŋ/|adj|lạnh cóng|My hands are freezing.|Tay mình lạnh cóng.",
  "shade|/ʃeɪd/|n|bóng râm|Let's sit in the shade.|Mình ngồi chỗ bóng râm đi.",
  "seasonal|/ˈsiːzənl/|adj|theo mùa|Prices here are seasonal.|Giá ở đây thay đổi theo mùa.",
];

const List<String> weatherTalk = <String>[
  "#|Hai người hàng xóm bàn chuyện trời mưa|Trước sảnh chung cư, chiều muộn",
  "Bác Hòa|Look at that sky. It's going to pour.|Nhìn trời kìa. Sắp mưa như trút đấy.",
  ">Bạn|I know. And I left my windows open.|Vâng ạ. Mà cháu lại quên đóng cửa sổ.",
  "Bác Hòa|Go now, you still have a few minutes.|Chạy lên đi, còn kịp vài phút đấy.",
  ">Bạn|Do you need anything from upstairs?|Bác có cần gì ở trên không ạ?",
  "Bác Hòa|No, thank you. Just don't get soaked.|Không, cảm ơn cháu. Đừng để ướt sũng là được.",
  ">Bạn|Is the forecast bad for tomorrow too?|Mai dự báo cũng xấu hả bác?",
  "Bác Hòa|They say it clears up by lunchtime.|Nghe nói tới trưa thì tạnh.",
  ">Bạn|That's a relief. See you, Bác Hòa.|May quá. Cháu chào bác ạ.",
];
