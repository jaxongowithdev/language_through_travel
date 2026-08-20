// Nội dung chủ đề 11–15: gọi điện và nhắn tin, nhà cửa, sức khoẻ, tiền bạc và
// ngân hàng, công sở. Quy ước bảng xem lib/data/parser.dart.

// --- 11. phone -------------------------------------------------------------

const List<String> phoneLines = <String>[
  "#|Bắt máy và mở đầu|Nghe máy tự tin ngay từ câu đầu tiên",
  "Hello, this is Trang speaking.|Alo, Trang nghe đây ạ.|This is plus tên là chuẩn khi tự xưng qua điện thoại.",
  "Hi, is this a good time to talk?|Chào anh, giờ này nói chuyện có tiện không ạ?|Hỏi trước khi vào việc là phép lịch sự cơ bản.",
  "I'm calling about the invoice from last week.|Tôi gọi về hoá đơn tuần trước ạ.|Call about something nêu ngay lý do gọi.",
  "Sorry, I think you have the wrong number.|Xin lỗi, hình như anh gọi nhầm số rồi.|Have the wrong number là cụm cố định.",
  "Could I speak to someone in accounting?|Cho tôi gặp bộ phận kế toán được không ạ?|Speak to someone in plus phòng ban.",
  "May I ask who's calling?|Cho hỏi ai đang gọi ạ?|Câu chuẩn khi bạn là người nhận cuộc gọi.",
  "Hold on, let me put you through.|Anh giữ máy nhé, tôi nối máy.|Put someone through nghĩa là chuyển máy.",
  "I'm afraid she's in a meeting right now.|Tiếc là chị ấy đang họp ạ.|I'm afraid làm mềm tin không vui.",
  "#|Khi đường truyền tệ|Xử lý lúc nghe không rõ hoặc bị ngắt",
  "Sorry, you're breaking up.|Xin lỗi, tiếng anh bị ngắt quãng.|Break up cho tín hiệu chập chờn.",
  "Could you speak up a little?|Anh nói to hơn chút được không ạ?|Speak up nghĩa là nói to lên.",
  "I lost you for a second there.|Vừa nãy tôi mất tiếng anh một lúc.|Lose someone nghĩa là mất kết nối với ai.",
  "Let me call you back on a better line.|Để tôi gọi lại bằng đường khác tốt hơn.|Call someone back nghĩa là gọi lại.",
  "Can you hear me now?|Giờ anh nghe rõ chưa ạ?|Câu kiểm tra kết nối quen thuộc.",
  "Sorry, could you repeat the last part?|Xin lỗi, anh nhắc lại đoạn cuối được không?|The last part nghĩa là phần vừa nói.",
  "I'll text you the address instead.|Tôi nhắn tin địa chỉ cho anh vậy.|Text someone something là nhắn tin.",
  "The signal is terrible in this building.|Trong toà nhà này sóng tệ lắm.|Signal là sóng, reception cũng dùng được.",
  "#|Nhắn tin và để lại lời nhắn|Viết tin ngắn gọn và lịch sự",
  "Just checking in about tomorrow.|Nhắn hỏi thăm chút về ngày mai thôi.|Check in about something nghĩa là hỏi thăm tiến độ.",
  "Sorry for the slow reply.|Xin lỗi vì trả lời chậm.|Slow reply tự nhiên hơn late reply trong tin nhắn.",
  "Could you leave her a message?|Anh nhắn lại giúp chị ấy được không ạ?|Leave someone a message.",
  "I'll be there in five.|Năm phút nữa mình tới.|In five là cách rút gọn của in five minutes.",
  "Can we take this offline?|Chuyện này mình nói riêng sau nhé?|Take something offline nghĩa là bàn riêng ngoài nhóm.",
  "Sending you the file now.|Gửi bạn file ngay đây.|Bỏ chủ ngữ I là cách viết tin nhắn tự nhiên.",
  "No rush, whenever you have a minute.|Không gấp đâu, lúc nào bạn rảnh cũng được.|No rush là câu giảm áp lực rất hay dùng.",
  "Got it, thanks for the heads-up.|Rõ rồi, cảm ơn bạn đã báo trước.|Heads-up là lời báo trước.",
];

const List<String> phoneWords = <String>[
  "voicemail|/ˈvɔɪsmeɪl/|n|hộp thư thoại|Leave a voicemail if I miss you.|Nếu mình lỡ máy thì để lại lời nhắn nhé.",
  "hang up|/hæŋ ʌp/|phr|cúp máy|Don't hang up yet.|Khoan cúp máy đã.",
  "reception|/rɪˈsepʃn/|n|sóng, tín hiệu|The reception is poor here.|Ở đây sóng yếu.",
  "extension|/ɪkˈstenʃn/|n|số máy lẻ|My extension is two two four.|Máy lẻ của tôi là hai hai bốn.",
  "urgent|/ˈɜːrdʒənt/|adj|khẩn|It is not urgent at all.|Chuyện này không gấp đâu.",
  "available|/əˈveɪləbl/|adj|rảnh, sẵn sàng|She is not available right now.|Chị ấy hiện không tiện nghe máy.",
  "forward|/ˈfɔːrwərd/|v|chuyển tiếp|I forwarded the email to you.|Mình đã chuyển tiếp email cho bạn.",
  "typo|/ˈtaɪpoʊ/|n|lỗi đánh máy|Sorry, that was a typo.|Xin lỗi, mình gõ nhầm.",
  "notification|/ˌnoʊtɪfɪˈkeɪʃn/|n|thông báo|I turned off notifications.|Mình tắt thông báo rồi.",
  "reply|/rɪˈplaɪ/|n, v|trả lời|I will reply by tonight.|Tối nay mình sẽ trả lời.",
];

const List<String> phoneTalk = <String>[
  "#|Gọi tới nhà cung cấp|Cuộc gọi công việc về một đơn hàng bị chậm",
  "Tổng đài|Good morning, Bright Supplies. How may I help?|Chào buổi sáng, Bright Supplies xin nghe.",
  ">Bạn|Hello, I'm calling about order four one two.|Chào chị, tôi gọi về đơn hàng bốn một hai.",
  "Tổng đài|Of course. May I ask who's calling?|Vâng ạ. Cho hỏi ai đang gọi ạ?",
  ">Bạn|This is Trang from Lam Vien Company.|Tôi là Trang, công ty Lâm Viên.",
  "Tổng đài|Thank you. The order shipped this morning.|Cảm ơn chị. Đơn hàng đã gửi sáng nay.",
  ">Bạn|Great. Could you send me the tracking number?|Tốt quá. Chị gửi giúp tôi mã vận đơn nhé?",
  "Tổng đài|I'll email it right away.|Em gửi email ngay ạ.",
  ">Bạn|Perfect. Thanks for your help.|Tuyệt. Cảm ơn chị nhiều.",
];

// --- 12. home --------------------------------------------------------------

const List<String> homeLines = <String>[
  "#|Tìm và thuê nhà|Hỏi giá, hỏi điều kiện, xem phòng",
  "Is the apartment still available?|Căn hộ còn trống không ạ?|Available dùng cho cả nhà lẫn phòng.",
  "How much is the rent per month?|Tiền thuê một tháng bao nhiêu ạ?|Rent là tiền thuê, deposit là tiền cọc.",
  "Are utilities included?|Đã bao gồm điện nước chưa ạ?|Utilities là điện, nước, rác.",
  "Is it furnished?|Nhà có sẵn nội thất không ạ?|Furnished là có nội thất, unfurnished là nhà trống.",
  "Could I come and see it tomorrow?|Mai tôi tới xem được không ạ?|Come and see là cụm rất thông dụng.",
  "How long is the lease?|Hợp đồng thuê bao lâu ạ?|Lease là hợp đồng thuê nhà.",
  "Is there a lift in the building?|Toà nhà có thang máy không ạ?|Lift kiểu Anh, elevator kiểu Mỹ.",
  "The deposit is one month, right?|Tiền cọc là một tháng đúng không ạ?|Thêm right ở cuối để xác nhận.",
  "#|Sửa chữa và sự cố|Báo hỏng và hẹn thợ",
  "The kitchen tap is leaking.|Vòi bếp bị rỉ nước.|Tap kiểu Anh, faucet kiểu Mỹ.",
  "The air conditioner isn't cooling properly.|Điều hoà không mát như bình thường.|Properly nghĩa là đúng cách, đúng mức.",
  "There's no hot water this morning.|Sáng nay không có nước nóng.|There is no plus danh từ không đếm được.",
  "Could you send someone to take a look?|Anh cho người tới xem giúp được không ạ?|Take a look nghĩa là ngó qua, kiểm tra.",
  "The light in the hallway keeps flickering.|Đèn hành lang cứ chớp tắt liên tục.|Keep doing something nghĩa là cứ lặp đi lặp lại.",
  "A pipe burst under the sink.|Ống nước dưới bồn rửa bị vỡ.|Burst là động từ bất quy tắc, ba dạng giống nhau.",
  "When would be convenient for you?|Anh thấy lúc nào tiện ạ?|Câu hỏi lịch hẹn rất lịch sự.",
  "It's been like that for a week.|Tình trạng này kéo dài một tuần rồi.|Hiện tại hoàn thành cho việc kéo dài tới hiện tại.",
  "#|Sống cùng người khác|Chia việc nhà và giữ hoà khí",
  "Whose turn is it to take out the rubbish?|Tới lượt ai đổ rác thế?|Whose turn is it to do something.",
  "Could you keep it down a bit after eleven?|Sau mười một giờ bạn nhỏ tiếng chút nhé?|Keep it down nghĩa là giữ yên lặng.",
  "I'll do the dishes if you cook.|Bạn nấu thì mình rửa bát.|Do the dishes là cụm cố định.",
  "We should split the bills evenly.|Mình chia đều các khoản nhé.|Split something evenly nghĩa là chia đều.",
  "Sorry about the mess, I had a long week.|Xin lỗi vì bừa bộn, tuần này mình đuối quá.|Mess là sự bừa bộn.",
  "Do you mind if I use the desk tonight?|Tối nay mình dùng bàn làm việc được không?|Do you mind if là mẫu xin phép lịch sự.",
  "I left you some soup in the fridge.|Mình để phần bạn ít canh trong tủ lạnh.|Leave someone something nghĩa là để dành cho ai.",
  "Let's set some ground rules.|Mình thống nhất vài nguyên tắc chung nhé.|Ground rules là các quy tắc cơ bản.",
];

const List<String> homeWords = <String>[
  "landlord|/ˈlændlɔːrd/|n|chủ nhà|The landlord lives next door.|Chủ nhà ở ngay bên cạnh.",
  "tenant|/ˈtenənt/|n|người thuê nhà|The previous tenant left last week.|Người thuê trước dọn đi tuần trước.",
  "deposit|/dɪˈpɑːzɪt/|n|tiền cọc|The deposit is refundable.|Tiền cọc được hoàn lại.",
  "furnished|/ˈfɜːrnɪʃt/|adj|có sẵn nội thất|We want a furnished flat.|Bọn mình muốn thuê nhà có nội thất.",
  "leak|/liːk/|n, v|rò rỉ|There is a leak in the ceiling.|Trần nhà bị dột.",
  "mortgage|/ˈmɔːrɡɪdʒ/|n|khoản vay mua nhà|We are still paying the mortgage.|Bọn mình vẫn đang trả nợ mua nhà.",
  "neighbourhood|/ˈneɪbərhʊd/|n|khu dân cư|It is a quiet neighbourhood.|Đây là khu dân cư yên tĩnh.",
  "spacious|/ˈspeɪʃəs/|adj|rộng rãi|The living room is spacious.|Phòng khách rộng rãi.",
  "tidy|/ˈtaɪdi/|adj, v|gọn gàng, dọn dẹp|Please tidy up before you go.|Dọn dẹp trước khi đi nhé.",
  "utilities|/juːˈtɪlətiz/|n|tiền điện nước|Utilities are about six hundred thousand.|Điện nước chừng sáu trăm nghìn.",
];

const List<String> homeTalk = <String>[
  "#|Gọi báo chủ nhà|Người thuê gọi cho chủ nhà về sự cố nước nóng",
  "Chủ nhà|Hello?|Alo?",
  ">Bạn|Hi, it's Trang from the third floor.|Chào cô, cháu Trang tầng ba đây ạ.",
  "Chủ nhà|Hi Trang. Is everything alright?|Chào Trang. Có chuyện gì không cháu?",
  ">Bạn|The water heater stopped working last night.|Bình nóng lạnh hỏng từ tối qua ạ.",
  "Chủ nhà|Oh dear. Is it the whole unit or just the shower?|Ôi chao. Hỏng cả bình hay chỉ vòi sen thôi?",
  ">Bạn|The whole thing. There is no hot water at all.|Cả bình ạ. Không có tí nước nóng nào.",
  "Chủ nhà|I'll send someone tomorrow morning.|Sáng mai cô cho thợ tới.",
  ">Bạn|Thank you. I'll be home until noon.|Cháu cảm ơn cô. Cháu ở nhà tới trưa ạ.",
];

// --- 13. health ------------------------------------------------------------

const List<String> healthLines = <String>[
  "#|Ở phòng khám|Mô tả triệu chứng cho nhân viên y tế",
  "I'd like to make an appointment, please.|Tôi muốn đặt lịch khám ạ.|Make an appointment là cụm cố định.",
  "I've had a sore throat for three days.|Tôi đau họng ba ngày nay rồi.|Have a sore throat, have a headache, have a cough.",
  "It hurts when I breathe in.|Tôi hít vào là thấy đau.|Hurt dùng như động từ thường: it hurts.",
  "The pain comes and goes.|Cơn đau lúc có lúc không.|Come and go là cụm cố định cho triệu chứng ngắt quãng.",
  "I'm allergic to penicillin.|Tôi dị ứng với penicillin.|Câu bắt buộc phải nói được ở nước ngoài.",
  "I haven't been sleeping well lately.|Dạo này tôi ngủ không ngon.|Lately đi với hiện tại hoàn thành.",
  "Do I need a prescription for this?|Thuốc này có cần đơn không ạ?|Prescription là đơn thuốc.",
  "How often should I take it?|Tôi uống mấy lần một ngày ạ?|Take medicine chứ không dùng drink hay eat.",
  "#|Ở hiệu thuốc|Mua thuốc và hỏi cách dùng",
  "Do you have anything for a blocked nose?|Có thuốc gì cho ngạt mũi không ạ?|Something for plus triệu chứng.",
  "Is this safe to take with food?|Thuốc này uống cùng đồ ăn được không ạ?|Safe to do something.",
  "Are there any side effects?|Có tác dụng phụ gì không ạ?|Side effect là tác dụng phụ.",
  "I need something that won't make me drowsy.|Tôi cần loại không gây buồn ngủ.|Drowsy nghĩa là buồn ngủ lơ mơ.",
  "Could I have a smaller pack?|Cho tôi hộp nhỏ hơn được không ạ?|Pack là hộp, vỉ thuốc là blister.",
  "Take one tablet twice a day.|Uống một viên, ngày hai lần.|Twice a day, three times a day.",
  "Finish the whole course.|Uống hết liệu trình nhé.|Course ở đây nghĩa là liệu trình thuốc.",
  "Keep it out of reach of children.|Để xa tầm tay trẻ em.|Out of reach of children là câu cảnh báo chuẩn.",
  "#|Giữ sức khoẻ|Nói về thói quen vận động và nghỉ ngơi",
  "I try to walk ten thousand steps a day.|Mình cố đi mười nghìn bước mỗi ngày.|Steps a day là cách nói tần suất.",
  "I've cut down on sugar.|Mình giảm đường lại rồi.|Cut down on something nghĩa là giảm bớt.",
  "I stretch for five minutes before bed.|Trước khi ngủ mình giãn cơ năm phút.|Stretch là giãn cơ.",
  "Sitting all day is bad for my back.|Ngồi cả ngày hại lưng lắm.|Be bad for something.",
  "I feel much better after a swim.|Bơi xong mình thấy khoẻ hơn hẳn.|Much better nhấn mức độ cải thiện.",
  "I should drink more water.|Mình nên uống nhiều nước hơn.|Should cho lời tự nhắc nhở.",
  "Rest is part of the training.|Nghỉ ngơi cũng là một phần của tập luyện.|Be part of something.",
  "I'm taking it easy this week.|Tuần này mình làm nhẹ nhàng thôi.|Take it easy nghĩa là thư giãn, đừng gắng sức.",
];

const List<String> healthWords = <String>[
  "symptom|/ˈsɪmptəm/|n|triệu chứng|The symptoms started on Monday.|Triệu chứng bắt đầu từ thứ Hai.",
  "appointment|/əˈpɔɪntmənt/|n|lịch hẹn|I have an appointment at four.|Mình có hẹn lúc bốn giờ.",
  "prescription|/prɪˈskrɪpʃn/|n|đơn thuốc|You need a prescription for that.|Thuốc đó cần có đơn.",
  "pharmacy|/ˈfɑːrməsi/|n|hiệu thuốc|There is a pharmacy on the corner.|Có hiệu thuốc ở góc phố.",
  "dose|/doʊs/|n|liều|Do not double the dose.|Đừng uống gấp đôi liều.",
  "recover|/rɪˈkʌvər/|v|hồi phục|He recovered in a few days.|Anh ấy khỏi sau vài ngày.",
  "sore|/sɔːr/|adj|đau nhức|My legs are sore from running.|Chân mình mỏi vì chạy bộ.",
  "checkup|/ˈtʃekʌp/|n|khám tổng quát|I go for a checkup every year.|Năm nào mình cũng đi khám tổng quát.",
  "exhausting|/ɪɡˈzɔːstɪŋ/|adj|làm kiệt sức|That shift was exhausting.|Ca làm đó mệt phờ.",
  "hydrated|/ˈhaɪdreɪtɪd/|adj|đủ nước|Stay hydrated in this heat.|Trời nóng nhớ uống đủ nước.",
];

const List<String> healthTalk = <String>[
  "#|Ở quầy thuốc|Người mua thuốc mô tả triệu chứng cho dược sĩ",
  "Dược sĩ|Hi, what can I get for you?|Chào anh chị, em lấy gì ạ?",
  ">Bạn|I have a sore throat and a mild cough.|Tôi đau họng và ho nhẹ.",
  "Dược sĩ|How long have you had it?|Anh chị bị mấy hôm rồi ạ?",
  ">Bạn|Since Sunday. No fever though.|Từ Chủ nhật. Nhưng không sốt.",
  "Dược sĩ|Are you taking any other medication?|Anh chị có đang uống thuốc gì khác không?",
  ">Bạn|No, but I'm allergic to penicillin.|Không, nhưng tôi dị ứng penicillin.",
  "Dược sĩ|Good to know. Try these lozenges twice a day.|May là anh chị nói. Ngậm viên này ngày hai lần nhé.",
  ">Bạn|Thank you. Any side effects?|Cảm ơn bạn. Có tác dụng phụ gì không?",
];

// --- 14. money -------------------------------------------------------------

const List<String> moneyLines = <String>[
  "#|Ở ngân hàng|Mở tài khoản, rút tiền, hỏi phí",
  "I'd like to open a savings account.|Tôi muốn mở tài khoản tiết kiệm ạ.|Savings account là tài khoản tiết kiệm.",
  "What documents do I need?|Tôi cần giấy tờ gì ạ?|Documents ở đây là giấy tờ tuỳ thân.",
  "Is there a monthly fee?|Có phí duy trì hằng tháng không ạ?|Fee là phí dịch vụ, charge cũng dùng được.",
  "The card machine says my card was declined.|Máy báo thẻ của tôi bị từ chối.|Be declined nghĩa là bị từ chối giao dịch.",
  "Could you check my balance, please?|Chị kiểm tra số dư giúp tôi với ạ.|Balance là số dư tài khoản.",
  "I need to transfer money abroad.|Tôi cần chuyển tiền ra nước ngoài.|Transfer money to somewhere.",
  "How long does the transfer take?|Chuyển khoản mất bao lâu ạ?|Take ở đây nghĩa là mất bao nhiêu thời gian.",
  "I lost my card, could you block it?|Tôi mất thẻ, chị khoá giúp tôi với ạ.|Block a card nghĩa là khoá thẻ.",
  "#|Chi tiêu hằng ngày|Nói về giá cả và thói quen tiêu tiền",
  "That's a bit steep for what it is.|So với chất lượng thì hơi đắt.|Steep dùng cho giá cao quá mức.",
  "I'm on a tight budget this month.|Tháng này mình eo hẹp lắm.|On a tight budget nghĩa là ngân sách hạn hẹp.",
  "It's worth every penny.|Đáng từng đồng.|Câu khen món đồ đáng tiền.",
  "I set aside a bit every payday.|Cứ tới ngày lương mình để riêng một ít.|Set aside nghĩa là để dành riêng.",
  "We split it three ways.|Bọn mình chia ba.|Split something three ways nghĩa là chia làm ba phần.",
  "I got it half price in the sale.|Mình mua được nửa giá đợt khuyến mại.|Half price là nửa giá.",
  "I try not to buy things on impulse.|Mình cố không mua theo cảm hứng.|On impulse nghĩa là bốc đồng.",
  "Money is tight, but we manage.|Cũng chật vật, nhưng bọn mình xoay được.|Manage ở đây nghĩa là xoay xở được.",
  "#|Kế hoạch tài chính|Nói về tiết kiệm, vay mượn và mục tiêu",
  "We're saving up for a deposit.|Bọn mình đang tích cóp tiền đặt cọc.|Save up for something.",
  "I pay off my card in full every month.|Tháng nào mình cũng trả hết dư nợ thẻ.|Pay off nghĩa là trả hết nợ.",
  "I'd rather not borrow from family.|Mình không muốn vay người nhà lắm.|Would rather not do something.",
  "The interest rate went up again.|Lãi suất lại tăng nữa.|Interest rate là lãi suất.",
  "I keep an emergency fund.|Mình luôn có một khoản dự phòng.|Emergency fund là quỹ khẩn cấp.",
  "Let's look at the numbers together.|Mình cùng ngồi xem con số nhé.|Look at the numbers nghĩa là xem lại các khoản.",
  "It'll pay for itself within a year.|Trong một năm là hoàn vốn.|Pay for itself nghĩa là tự bù lại chi phí.",
  "I don't want to be in debt again.|Mình không muốn lại mắc nợ.|Be in debt là đang nợ.",
];

const List<String> moneyWords = <String>[
  "budget|/ˈbʌdʒɪt/|n, v|ngân sách, lập ngân sách|We set a monthly budget.|Bọn mình đặt ngân sách hằng tháng.",
  "expense|/ɪkˈspens/|n|khoản chi|Rent is our biggest expense.|Tiền nhà là khoản chi lớn nhất.",
  "income|/ˈɪnkʌm/|n|thu nhập|Our income is stable now.|Giờ thu nhập nhà mình ổn định.",
  "invoice|/ˈɪnvɔɪs/|n|hoá đơn thanh toán|Please send the invoice by Friday.|Gửi hoá đơn trước thứ Sáu nhé.",
  "installment|/ɪnˈstɔːlmənt/|n|khoản trả góp|We pay in twelve installments.|Bọn mình trả góp mười hai kỳ.",
  "withdraw|/wɪðˈdrɔː/|v|rút tiền|I need to withdraw some cash.|Mình cần rút ít tiền mặt.",
  "transfer|/ˈtrænsfɜːr/|n, v|chuyển khoản|The transfer went through.|Giao dịch chuyển khoản thành công.",
  "affordable|/əˈfɔːrdəbl/|adj|vừa túi tiền|We found an affordable option.|Bọn mình tìm được lựa chọn vừa tiền.",
  "savings|/ˈseɪvɪŋz/|n|tiền tiết kiệm|I used my savings for the course.|Mình dùng tiền tiết kiệm để học khoá đó.",
  "overcharge|/ˌoʊvərˈtʃɑːrdʒ/|v|tính quá tiền|I think they overcharged me.|Mình nghĩ họ tính dư tiền.",
];

const List<String> moneyTalk = <String>[
  "#|Mở tài khoản ở ngân hàng|Quầy giao dịch, buổi sáng đầu tuần",
  "Giao dịch viên|Good morning. How can I help you today?|Chào anh chị. Hôm nay em giúp gì ạ?",
  ">Bạn|I'd like to open a savings account.|Tôi muốn mở tài khoản tiết kiệm.",
  "Giao dịch viên|Certainly. Do you have your ID with you?|Vâng ạ. Anh chị có mang giấy tờ tuỳ thân không?",
  ">Bạn|Yes, here it is. Is there a monthly fee?|Có đây ạ. Có phí duy trì hằng tháng không?",
  "Giao dịch viên|No fee if the balance stays above one million.|Không, nếu số dư trên một triệu ạ.",
  ">Bạn|That works for me. How long will it take?|Vậy hợp với tôi. Mất bao lâu ạ?",
  "Giao dịch viên|About fifteen minutes. Please take a seat.|Chừng mười lăm phút. Mời anh chị ngồi.",
  ">Bạn|Thank you very much.|Cảm ơn bạn nhiều.",
];

// --- 15. work --------------------------------------------------------------

const List<String> workLines = <String>[
  "#|Ngày làm việc|Nói về công việc đang làm và tiến độ",
  "I'm working on the quarterly report.|Mình đang làm báo cáo quý.|Work on something nghĩa là đang làm việc gì.",
  "I'm about halfway through.|Mình xong được nửa rồi.|Halfway through nghĩa là được nửa chặng.",
  "Could you take a look when you have time?|Lúc nào rảnh bạn xem giúp mình nhé?|Take a look at something nghĩa là xem qua.",
  "I'll get back to you by the end of the day.|Cuối ngày mình sẽ phản hồi bạn.|Get back to someone nghĩa là trả lời lại.",
  "This is taking longer than expected.|Việc này lâu hơn dự tính.|Than expected là mẫu so sánh với dự kiến.",
  "I'm a bit swamped this week.|Tuần này mình ngập việc.|Swamped nghĩa là ngập trong công việc.",
  "Let's put that on the back burner.|Việc đó tạm gác lại đã.|Put something on the back burner nghĩa là để sau.",
  "I could use a hand with this.|Việc này mình cần người phụ.|Could use a hand là cách xin giúp đỡ khéo léo.",
  "#|Làm việc với đồng nghiệp|Nhờ vả, cảm ơn, phản hồi",
  "Would you mind covering for me on Friday?|Thứ Sáu bạn trực thay mình được không?|Cover for someone nghĩa là làm thay.",
  "Thanks for jumping in yesterday.|Cảm ơn bạn hôm qua đã nhảy vào giúp.|Jump in nghĩa là tham gia hỗ trợ ngay.",
  "I owe you one.|Mình nợ bạn một lần.|Câu cảm ơn thân mật nhưng rất chân thành.",
  "Just so you know, the client replied.|Nói bạn biết là khách đã trả lời rồi.|Just so you know mở đầu tin cần thông báo.",
  "I see it differently, and here's why.|Mình nghĩ khác, và đây là lý do.|Cách bất đồng ý kiến mà không gây căng.",
  "That's a fair point.|Ý đó cũng hợp lý.|Fair point là công nhận ý người khác.",
  "Let's loop in the design team.|Mình kéo nhóm thiết kế vào luôn nhé.|Loop someone in nghĩa là cho ai vào cuộc trao đổi.",
  "Can we sync up tomorrow morning?|Sáng mai mình trao đổi nhanh nhé?|Sync up nghĩa là đồng bộ thông tin.",
  "#|Nghỉ phép và ranh giới|Xin nghỉ và giữ cân bằng",
  "I'd like to take Friday off.|Mình muốn xin nghỉ thứ Sáu.|Take a day off nghĩa là nghỉ một ngày.",
  "I'm off next week, back on the twelfth.|Tuần sau mình nghỉ, ngày mười hai đi làm lại.|Be off nghĩa là đang nghỉ.",
  "I won't be checking email while I'm away.|Lúc nghỉ mình sẽ không kiểm tra email.|While I'm away nghĩa là trong lúc mình vắng.",
  "Can this wait until Monday?|Việc này để tới thứ Hai được không?|Wait until là mẫu hỏi hoãn việc.",
  "I try to log off by seven.|Mình cố tắt máy trước bảy giờ.|Log off nghĩa là thoát, ngừng làm việc.",
  "I'm not available on weekends, sorry.|Cuối tuần mình không nhận việc, xin lỗi nhé.|Câu đặt ranh giới rõ ràng mà vẫn lịch sự.",
  "Thanks for understanding.|Cảm ơn bạn đã thông cảm.|Câu chốt sau khi từ chối hoặc xin nghỉ.",
  "I'll hand over my tasks before I go.|Trước khi nghỉ mình sẽ bàn giao việc.|Hand over nghĩa là bàn giao.",
];

const List<String> workWords = <String>[
  "deadline|/ˈdedlaɪn/|n|hạn chót|We moved the deadline to Monday.|Bọn mình dời hạn chót sang thứ Hai.",
  "workload|/ˈwɜːrkloʊd/|n|khối lượng công việc|My workload doubled this quarter.|Khối lượng việc của mình tăng gấp đôi quý này.",
  "overtime|/ˈoʊvərtaɪm/|n|làm thêm giờ|I did overtime three nights.|Mình làm thêm ba tối.",
  "colleague|/ˈkɑːliːɡ/|n|đồng nghiệp|My colleague covered my shift.|Đồng nghiệp trực thay ca mình.",
  "feedback|/ˈfiːdbæk/|n|góp ý|Thanks for the honest feedback.|Cảm ơn góp ý thẳng thắn.",
  "promotion|/prəˈmoʊʃn/|n|thăng chức|She got a promotion last month.|Tháng trước cô ấy được thăng chức.",
  "shift|/ʃɪft/|n|ca làm|I work the early shift.|Mình làm ca sớm.",
  "handover|/ˈhændoʊvər/|n|việc bàn giao|The handover took two days.|Việc bàn giao mất hai ngày.",
  "burnout|/ˈbɜːrnaʊt/|n|kiệt sức vì công việc|Burnout is common in this job.|Nghề này hay bị kiệt sức.",
  "delegate|/ˈdelɪɡeɪt/|v|giao việc cho người khác|Learn to delegate more.|Học cách giao bớt việc đi.",
];

const List<String> workTalk = <String>[
  "#|Xin nghỉ một ngày|Trao đổi ngắn với quản lý trực tiếp",
  ">Bạn|Do you have a minute?|Chị có một phút không ạ?",
  "Quản lý|Sure, what's up?|Có chứ, có việc gì thế?",
  ">Bạn|I'd like to take Friday off if that's alright.|Em muốn xin nghỉ thứ Sáu nếu được ạ.",
  "Quản lý|Any deadlines that week?|Tuần đó có hạn chót nào không?",
  ">Bạn|Only the report, and I'll finish it Thursday.|Chỉ có báo cáo, em xong trong thứ Năm ạ.",
  "Quản lý|Then it's fine. Put it in the calendar.|Vậy được. Em cho vào lịch nhé.",
  ">Bạn|Will do. I'll hand over the inbox to Quân.|Vâng ạ. Em bàn giao hộp thư cho Quân.",
  "Quản lý|Perfect. Enjoy your long weekend.|Tốt. Chúc em cuối tuần dài vui vẻ.",
];
