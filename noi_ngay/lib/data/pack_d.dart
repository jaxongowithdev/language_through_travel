// Nội dung chủ đề 16–20: họp hành, email công việc, phỏng vấn xin việc, cảm
// xúc và động viên, xin lỗi và từ chối. Quy ước bảng xem lib/data/parser.dart.

// --- 16. meeting -----------------------------------------------------------

const List<String> meetingLines = <String>[
  "#|Mở đầu buổi họp|Chào, nêu mục tiêu và giữ nhịp",
  "Thanks everyone for joining.|Cảm ơn mọi người đã tham gia.|Câu mở đầu chuẩn cho họp trực tuyến.",
  "Shall we get started?|Mình bắt đầu nhé?|Shall we là cách rủ lịch sự trong họp.",
  "The goal today is to decide on the launch date.|Mục tiêu hôm nay là chốt ngày ra mắt.|Nêu mục tiêu ngay đầu giúp họp ngắn lại.",
  "I'll keep this to twenty minutes.|Mình sẽ giữ trong hai mươi phút.|Keep something to plus thời lượng.",
  "Feel free to jump in at any point.|Mọi người cứ chen vào bất cứ lúc nào nhé.|Feel free to do something.",
  "Can everyone hear me okay?|Mọi người nghe rõ chứ ạ?|Câu kiểm tra âm thanh đầu buổi họp.",
  "Let's park that and come back to it.|Mình gác ý đó lại rồi quay lại sau nhé.|Park something nghĩa là tạm gác lại.",
  "We're a bit over time, so let's wrap up.|Hơi quá giờ rồi, mình chốt lại nhé.|Wrap up nghĩa là kết thúc, tổng kết.",
  "#|Nêu ý kiến|Đồng ý, phản đối và đề xuất một cách khéo léo",
  "From my point of view, the timing is risky.|Theo góc nhìn của mình, thời điểm hơi rủi ro.|From my point of view mềm hơn I think.",
  "I agree with Mai on this one.|Về việc này mình đồng ý với Mai.|Agree with someone on something.",
  "I see what you mean, but there's another angle.|Mình hiểu ý bạn, nhưng còn một góc khác.|Công nhận trước rồi mới phản biện.",
  "Could I add something to that?|Mình bổ sung một ý được không?|Add something to something.",
  "What if we tried a smaller pilot first?|Hay mình thử làm nhỏ trước xem sao?|What if plus quá khứ đơn cho đề xuất giả định.",
  "I'm not convinced yet, to be honest.|Nói thật là mình chưa bị thuyết phục.|Be convinced nghĩa là được thuyết phục.",
  "Can we look at the data before deciding?|Mình xem số liệu rồi hãy quyết định nhé?|Before plus danh động từ.",
  "That's outside my area, but I can find out.|Cái đó ngoài chuyên môn của mình, nhưng mình hỏi giúp được.|Cách nói không biết mà vẫn chuyên nghiệp.",
  "#|Chốt việc|Ghi nhận quyết định và phân công",
  "So, to summarise, we're going with option B.|Vậy tóm lại, mình chọn phương án B.|To summarise mở đầu phần tổng kết.",
  "Who's taking the lead on this?|Ai sẽ đứng chính việc này?|Take the lead on something.",
  "I'll own the timeline.|Mình nhận phần tiến độ.|Own something ở đây nghĩa là chịu trách nhiệm chính.",
  "Let's set a deadline for Thursday.|Mình đặt hạn chót là thứ Năm nhé.|Set a deadline for plus thời điểm.",
  "I'll send the notes after this call.|Họp xong mình gửi biên bản.|Notes ở đây là biên bản họp.",
  "Are we all clear on the next steps?|Mọi người rõ các bước tiếp theo chưa ạ?|Be clear on something.",
  "Let's follow up next Tuesday.|Thứ Ba tuần sau mình theo dõi tiếp nhé.|Follow up nghĩa là theo dõi, làm tiếp.",
  "Thanks, that was a productive session.|Cảm ơn mọi người, buổi họp hiệu quả.|Productive session là buổi làm việc hiệu quả.",
];

const List<String> meetingWords = <String>[
  "agenda|/əˈdʒendə/|n|chương trình họp|The agenda has four items.|Chương trình họp có bốn mục.",
  "minutes|/ˈmɪnɪts/|n|biên bản họp|I'll write up the minutes.|Mình sẽ soạn biên bản.",
  "stakeholder|/ˈsteɪkhoʊldər/|n|bên liên quan|We need buy-in from stakeholders.|Cần các bên liên quan đồng thuận.",
  "brainstorm|/ˈbreɪnstɔːrm/|v, n|động não tìm ý|Let's brainstorm for ten minutes.|Mình động não mười phút nhé.",
  "consensus|/kənˈsensəs/|n|sự đồng thuận|We reached a consensus quickly.|Bọn mình nhanh chóng đồng thuận.",
  "clarify|/ˈklærɪfaɪ/|v|làm rõ|Could you clarify that point?|Bạn làm rõ ý đó được không?",
  "postpone|/poʊˈspoʊn/|v|hoãn|We postponed the review.|Bọn mình hoãn buổi rà soát.",
  "priority|/praɪˈɔːrəti/|n|ưu tiên|Safety is our first priority.|An toàn là ưu tiên số một.",
  "milestone|/ˈmaɪlstoʊn/|n|cột mốc|The first milestone is in June.|Cột mốc đầu tiên vào tháng Sáu.",
  "recap|/ˈriːkæp/|n, v|tóm tắt lại|Quick recap before we finish.|Tóm tắt nhanh trước khi kết thúc.",
];

const List<String> meetingTalk = <String>[
  "#|Chốt ngày ra mắt|Cuộc họp trực tuyến ngắn của nhóm dự án",
  "Trưởng nhóm|Right, we need a launch date today.|Rồi, hôm nay mình phải chốt ngày ra mắt.",
  ">Bạn|Can I share a concern before we decide?|Trước khi quyết em nêu một lo ngại được không ạ?",
  "Trưởng nhóm|Please do.|Em cứ nói.",
  ">Bạn|Testing finishes on the tenth. That leaves no buffer.|Kiểm thử xong ngày mười. Vậy là không còn thời gian dự phòng.",
  "Trưởng nhóm|Fair point. What would you suggest?|Ý hay. Vậy em đề xuất thế nào?",
  ">Bạn|Launch on the seventeenth, with a soft release first.|Ra mắt ngày mười bảy, mở nhỏ trước đã ạ.",
  "Trưởng nhóm|I like that. Everyone okay with the seventeenth?|Chị thích ý đó. Cả nhóm thấy ngày mười bảy ổn chứ?",
  ">Bạn|I'll update the timeline and send it round.|Em cập nhật tiến độ rồi gửi mọi người ạ.",
];

// --- 17. email -------------------------------------------------------------

const List<String> emailLines = <String>[
  "#|Mở đầu email|Chào hỏi và nêu lý do viết",
  "I hope you're doing well.|Chúc anh chị mọi việc suôn sẻ.|Câu chào mở đầu an toàn nhất trong email công việc.",
  "I'm writing to follow up on our call.|Tôi viết thư để tiếp nối cuộc gọi hôm trước.|Write to do something nêu mục đích thư.",
  "Thanks for getting back to me so quickly.|Cảm ơn anh chị đã phản hồi nhanh.|Get back to someone nghĩa là hồi âm.",
  "Apologies for the delay in replying.|Xin lỗi vì hồi âm muộn.|Apologies for something là cách xin lỗi trang trọng.",
  "I was given your contact by Ms Lan.|Chị Lan cho tôi thông tin liên hệ của anh.|Câu giới thiệu nguồn liên hệ.",
  "Just a quick note about tomorrow.|Xin phép nhắn ngắn về ngày mai.|Just a quick note mở đầu thư ngắn.",
  "Following our conversation on Monday.|Tiếp nối trao đổi hôm thứ Hai.|Following plus danh từ, giọng trang trọng.",
  "I'd like to introduce my colleague, Quan.|Tôi xin giới thiệu đồng nghiệp của tôi, anh Quân.|Introduce someone khi kết nối hai bên.",
  "#|Nội dung chính|Đề nghị, hỏi thông tin và gửi tệp",
  "Could you please confirm the quantity?|Anh chị xác nhận giúp số lượng ạ.|Could you please plus động từ là lời đề nghị chuẩn.",
  "Please find the invoice attached.|Hoá đơn được đính kèm ạ.|Please find attached là mẫu cố định.",
  "Let me know if you need anything else.|Nếu cần gì thêm anh chị cứ báo ạ.|Câu chốt mở, rất thông dụng.",
  "We would appreciate a reply by Friday.|Chúng tôi mong nhận phản hồi trước thứ Sáu.|Would appreciate something lịch sự hơn want.",
  "Unfortunately, we cannot meet that deadline.|Rất tiếc, chúng tôi không kịp hạn đó.|Unfortunately mở đầu tin không vui.",
  "As discussed, here is the revised quote.|Như đã trao đổi, đây là báo giá đã sửa.|As discussed nhắc lại thoả thuận trước.",
  "Please disregard my previous email.|Xin bỏ qua email trước của tôi.|Disregard nghĩa là bỏ qua, không tính.",
  "I've copied Mai in on this thread.|Tôi có cc chị Mai vào thư này.|Copy someone in nghĩa là cc thêm ai.",
  "#|Kết thư|Chốt lại và ký tên đúng mực",
  "Looking forward to hearing from you.|Mong sớm nhận hồi âm của anh chị.|Look forward to plus danh động từ.",
  "Thanks in advance for your help.|Cảm ơn anh chị trước vì đã giúp đỡ.|In advance nghĩa là trước.",
  "Please don't hesitate to contact me.|Anh chị cứ liên hệ tôi bất cứ lúc nào.|Don't hesitate to do something.",
  "Best regards, Trang.|Trân trọng, Trang.|Best regards trung tính, hợp mọi hoàn cảnh.",
  "Have a good weekend.|Chúc anh chị cuối tuần vui vẻ.|Câu chốt thân thiện cho thư gửi thứ Sáu.",
  "I'll keep you posted.|Tôi sẽ cập nhật cho anh chị.|Keep someone posted nghĩa là báo tin liên tục.",
  "Thanks again for your patience.|Một lần nữa cảm ơn anh chị đã kiên nhẫn.|Câu chốt sau khi khách phải chờ lâu.",
  "Let me know a time that suits you.|Anh chị báo giúp giờ nào tiện ạ.|Suit someone nghĩa là hợp với ai.",
];

const List<String> emailWords = <String>[
  "attachment|/əˈtætʃmənt/|n|tệp đính kèm|The attachment did not open.|Tệp đính kèm không mở được.",
  "recipient|/rɪˈsɪpiənt/|n|người nhận|Check the recipient before sending.|Kiểm tra người nhận trước khi gửi.",
  "subject line|/ˈsʌbdʒɪkt laɪn/|n|dòng tiêu đề|Keep the subject line short.|Để dòng tiêu đề ngắn thôi.",
  "thread|/θred/|n|chuỗi thư|Let's keep it in one thread.|Mình giữ trong một chuỗi thư thôi.",
  "forward|/ˈfɔːrwərd/|v|chuyển tiếp|I forwarded it to finance.|Mình chuyển tiếp cho phòng tài chính.",
  "draft|/dræft/|n, v|bản nháp, soạn nháp|I saved it as a draft.|Mình lưu ở dạng nháp.",
  "concise|/kənˈsaɪs/|adj|súc tích|Be concise and specific.|Hãy súc tích và cụ thể.",
  "confidential|/ˌkɑːnfɪˈdenʃl/|adj|bảo mật|This report is confidential.|Báo cáo này là tài liệu mật.",
  "acknowledge|/əkˈnɑːlɪdʒ/|v|xác nhận đã nhận|Please acknowledge receipt.|Vui lòng xác nhận đã nhận.",
  "signature|/ˈsɪɡnətʃər/|n|chữ ký cuối thư|Add your title to the signature.|Thêm chức danh vào chữ ký nhé.",
];

const List<String> emailTalk = <String>[
  "#|Đọc to một email trả lời khách|Nhân viên đọc lại thư trước khi bấm gửi",
  "Đồng nghiệp|Can you read it to me before you send?|Gửi thì đọc cho mình nghe trước nhé?",
  ">Bạn|Sure. Dear Mr Tran, I hope you are doing well.|Được. Kính gửi anh Trần, chúc anh mọi việc suôn sẻ.",
  "Đồng nghiệp|Good start. Keep going.|Mở đầu ổn. Đọc tiếp đi.",
  ">Bạn|Thank you for your patience while we checked stock.|Cảm ơn anh đã kiên nhẫn trong lúc chúng tôi kiểm tra hàng.",
  "Đồng nghiệp|Nice. Did you give him a date?|Hay đấy. Bạn có nêu ngày cụ thể chưa?",
  ">Bạn|Yes. We can deliver on the ninth at the latest.|Rồi. Chậm nhất ngày mùng chín chúng tôi giao được.",
  "Đồng nghiệp|Add that the invoice is attached.|Thêm câu là hoá đơn đính kèm nữa.",
  ">Bạn|Good catch. Please find the invoice attached.|Bạn nhắc chuẩn. Hoá đơn được đính kèm ạ.",
];

// --- 18. interview ---------------------------------------------------------

const List<String> interviewLines = <String>[
  "#|Mở đầu phỏng vấn|Tạo ấn tượng trong ba phút đầu",
  "Thank you for making the time to meet me.|Cảm ơn anh chị đã dành thời gian gặp tôi.|Make the time nhấn ý sắp xếp thời gian.",
  "I've been in customer service for four years.|Tôi làm dịch vụ khách hàng được bốn năm.|Have been in plus lĩnh vực.",
  "I came across the role on your careers page.|Tôi thấy vị trí này trên trang tuyển dụng của công ty.|Come across something nghĩa là tình cờ thấy.",
  "What drew me here is the training programme.|Điều thu hút tôi là chương trình đào tạo.|What drew me here là mẫu câu nêu lý do ứng tuyển.",
  "I'm looking for more responsibility.|Tôi muốn nhận thêm trách nhiệm.|Lý do đổi việc an toàn và tích cực.",
  "My current contract ends next month.|Hợp đồng hiện tại của tôi hết vào tháng sau.|Contract ends là cách nói trung tính.",
  "I've read a lot about your new product.|Tôi đã tìm hiểu nhiều về sản phẩm mới của công ty.|Cho thấy bạn có chuẩn bị.",
  "Please stop me if I go on too long.|Nếu tôi nói dài quá anh chị cứ ngắt ạ.|Go on too long nghĩa là nói lan man.",
  "#|Trả lời câu khó|Điểm yếu, khoảng trống và thất bại",
  "My biggest weakness is saying yes too often.|Điểm yếu lớn nhất của tôi là hay nhận lời quá nhiều.|Nêu điểm yếu thật rồi kèm cách khắc phục.",
  "I've learned to ask for help earlier.|Tôi học được cách nhờ giúp sớm hơn.|Learn to do something.",
  "I took a year off to care for my family.|Tôi nghỉ một năm để chăm sóc gia đình.|Take time off là cách nói khoảng trống nghề nghiệp.",
  "That project failed, and here is what I changed.|Dự án đó thất bại, và đây là điều tôi thay đổi.|Trả lời thất bại nên kết bằng bài học.",
  "I don't have that certificate yet, but I'm studying for it.|Tôi chưa có chứng chỉ đó, nhưng đang học.|Thừa nhận thiếu sót rồi nêu hành động.",
  "I work best with clear priorities.|Tôi làm tốt nhất khi ưu tiên rõ ràng.|Work best with something.",
  "I'd rather ask a question than guess.|Tôi thà hỏi còn hơn đoán mò.|Would rather A than B.",
  "Could you tell me more about the team?|Anh chị nói thêm về đội ngũ được không ạ?|Đặt câu hỏi ngược cho thấy sự quan tâm.",
  "#|Lương và chốt|Thương lượng và kết thúc buổi phỏng vấn",
  "What is the salary range for this role?|Khoảng lương cho vị trí này là bao nhiêu ạ?|Salary range là khoảng lương.",
  "My expectation is in that range.|Mức mong muốn của tôi nằm trong khoảng đó.|Expectation ở đây là mức lương mong muốn.",
  "Is the salary negotiable?|Mức lương có thương lượng được không ạ?|Negotiable nghĩa là có thể thương lượng.",
  "I'd need two weeks to give notice.|Tôi cần hai tuần để báo trước với công ty cũ.|Give notice nghĩa là báo trước khi nghỉ.",
  "What does a typical week look like?|Một tuần làm việc điển hình thế nào ạ?|Look like ở đây nghĩa là trông ra sao.",
  "When can I expect to hear back?|Khi nào tôi có thể nhận kết quả ạ?|Hear back nghĩa là nhận hồi âm.",
  "Thank you, this was very helpful.|Cảm ơn anh chị, buổi trao đổi rất hữu ích.|Câu chốt lịch sự cuối buổi.",
  "I'm very interested in moving forward.|Tôi rất mong được đi tiếp các vòng sau.|Move forward nghĩa là tiến tiếp.",
];

const List<String> interviewWords = <String>[
  "resume|/ˈrezəmeɪ/|n|hồ sơ xin việc|Please attach your resume.|Vui lòng đính kèm hồ sơ.",
  "candidate|/ˈkændɪdət/|n|ứng viên|They shortlisted five candidates.|Họ chọn ra năm ứng viên.",
  "qualification|/ˌkwɑːlɪfɪˈkeɪʃn/|n|bằng cấp, năng lực|Her qualifications are impressive.|Bằng cấp của cô ấy rất ấn tượng.",
  "probation|/proʊˈbeɪʃn/|n|thời gian thử việc|Probation is two months.|Thử việc hai tháng.",
  "benefits|/ˈbenɪfɪts/|n|phúc lợi|The benefits include health insurance.|Phúc lợi có bảo hiểm y tế.",
  "notice period|/ˈnoʊtɪs ˈpɪriəd/|n|thời gian báo trước|My notice period is one month.|Thời gian báo trước của mình là một tháng.",
  "negotiate|/nɪˈɡoʊʃieɪt/|v|thương lượng|We negotiated the start date.|Bọn mình thương lượng ngày bắt đầu.",
  "reference|/ˈrefrəns/|n|người giới thiệu|I can provide two references.|Tôi cung cấp được hai người giới thiệu.",
  "strength|/streŋθ/|n|điểm mạnh|Patience is one of my strengths.|Kiên nhẫn là một điểm mạnh của tôi.",
  "opportunity|/ˌɑːpərˈtuːnəti/|n|cơ hội|This is a great opportunity.|Đây là cơ hội tốt.",
];

const List<String> interviewTalk = <String>[
  "#|Vòng phỏng vấn thứ hai|Phòng họp nhỏ, hai người phỏng vấn",
  "Nhà tuyển dụng|Tell me about a time something went wrong.|Kể cho tôi một lần mọi việc hỏng bét.",
  ">Bạn|We shipped an order to the wrong city.|Bọn tôi gửi đơn hàng sai thành phố.",
  "Nhà tuyển dụng|What did you do?|Bạn xử lý thế nào?",
  ">Bạn|I called the client before they noticed.|Tôi gọi cho khách trước khi họ phát hiện.",
  "Nhà tuyển dụng|And after that?|Rồi sau đó?",
  ">Bạn|We added a second check to the process.|Bọn tôi thêm một bước kiểm tra vào quy trình.",
  "Nhà tuyển dụng|Did it happen again?|Chuyện đó có lặp lại không?",
  ">Bạn|Not once in two years.|Hai năm không lần nào ạ.",
];

// --- 19. feelings ----------------------------------------------------------

const List<String> feelingsLines = <String>[
  "#|Nói về cảm xúc của mình|Diễn đạt chính xác hơn là chỉ good hay bad",
  "I'm a bit overwhelmed, honestly.|Nói thật là mình hơi quá tải.|Overwhelmed nghĩa là bị áp đảo, quá tải.",
  "I'm really proud of how that turned out.|Mình tự hào về kết quả đó lắm.|Be proud of something.",
  "I felt left out at the party.|Mình thấy lạc lõng ở buổi tiệc.|Feel left out nghĩa là thấy bị bỏ ngoài.",
  "I'm relieved that it's over.|Mình nhẹ cả người vì xong rồi.|Relieved nghĩa là nhẹ nhõm.",
  "I'm nervous, but in a good way.|Mình hồi hộp, nhưng theo kiểu tích cực.|In a good way làm mềm ý.",
  "That really got to me.|Chuyện đó làm mình xúc động thật.|Get to someone nghĩa là chạm tới cảm xúc ai.",
  "I need a bit of space today.|Hôm nay mình cần chút không gian riêng.|Need space là cách xin ở một mình.",
  "I'm okay, just tired.|Mình ổn, chỉ mệt thôi.|Câu trả lời thật lòng mà không nặng nề.",
  "#|Lắng nghe người khác|Đáp lại khi ai đó đang buồn hoặc căng thẳng",
  "That sounds really hard.|Nghe khó khăn thật đấy.|Câu đồng cảm an toàn nhất.",
  "Do you want advice or do you just want to vent?|Bạn muốn nghe lời khuyên hay chỉ muốn xả thôi?|Vent nghĩa là trút bầu tâm sự.",
  "I'm here if you need anything.|Cần gì cứ gọi mình nhé.|Câu ngỏ lời giúp không gây áp lực.",
  "Take your time, there's no rush.|Bạn cứ từ từ, không vội đâu.|Take your time là câu trấn an rất hay dùng.",
  "It makes sense that you feel that way.|Bạn thấy vậy là bình thường thôi.|Công nhận cảm xúc thay vì phán xét.",
  "You handled that better than you think.|Bạn xử lý tốt hơn bạn nghĩ đấy.|Câu động viên cụ thể, không sáo rỗng.",
  "Would it help to talk it through?|Nói ra có đỡ hơn không?|Talk something through nghĩa là bàn cho ra nhẽ.",
  "I don't have the answer, but I'm listening.|Mình không có câu trả lời, nhưng mình đang nghe.|Câu chân thành khi không biết nói gì.",
  "#|Động viên và chúc mừng|Khen ngợi, cổ vũ và chia vui",
  "Congratulations, you earned this.|Chúc mừng bạn, xứng đáng lắm.|Earn something nhấn ý xứng đáng nhờ nỗ lực.",
  "You've come a long way.|Bạn tiến bộ nhiều lắm rồi.|Come a long way là cụm cố định.",
  "Good luck tomorrow, you've got this.|Chúc may mắn ngày mai, bạn làm được mà.|You've got this là câu cổ vũ rất phổ biến.",
  "I'm so happy for you.|Mình mừng cho bạn lắm.|Be happy for someone.",
  "Don't be so hard on yourself.|Đừng khắt khe với bản thân quá.|Be hard on someone nghĩa là khắt khe với ai.",
  "One step at a time.|Từng bước một thôi.|Câu ngắn, dùng khi ai đó thấy quá tải.",
  "That took real courage.|Việc đó cần dũng khí thật sự đấy.|Take courage nghĩa là cần lòng can đảm.",
  "Whatever happens, I'm glad you tried.|Dù kết quả thế nào, mình mừng vì bạn đã thử.|Whatever happens mở đầu câu an ủi.",
];

const List<String> feelingsWords = <String>[
  "overwhelmed|/ˌoʊvərˈwelmd/|adj|quá tải|I felt overwhelmed by the list.|Mình thấy quá tải vì cái danh sách đó.",
  "grateful|/ˈɡreɪtfl/|adj|biết ơn|I'm grateful for your patience.|Mình biết ơn sự kiên nhẫn của bạn.",
  "frustrated|/ˈfrʌstreɪtɪd/|adj|bực bội, bất lực|He was frustrated with the delay.|Anh ấy bực vì bị chậm trễ.",
  "encourage|/ɪnˈkɜːrɪdʒ/|v|động viên|She encouraged me to apply.|Cô ấy động viên mình nộp đơn.",
  "relieved|/rɪˈliːvd/|adj|nhẹ nhõm|I was relieved to hear that.|Nghe vậy mình nhẹ cả người.",
  "supportive|/səˈpɔːrtɪv/|adj|hay nâng đỡ|My friends were very supportive.|Bạn bè mình rất nâng đỡ.",
  "confident|/ˈkɑːnfɪdənt/|adj|tự tin|I feel more confident now.|Giờ mình tự tin hơn.",
  "disappointed|/ˌdɪsəˈpɔɪntɪd/|adj|thất vọng|I was disappointed but not surprised.|Mình thất vọng nhưng không bất ngờ.",
  "cheer up|/tʃɪr ʌp/|phr|làm ai vui lên|That song always cheers me up.|Bài hát đó luôn làm mình vui lên.",
  "empathy|/ˈempəθi/|n|sự thấu cảm|She listens with real empathy.|Cô ấy lắng nghe rất thấu cảm.",
];

const List<String> feelingsTalk = <String>[
  "#|Một người bạn đang căng thẳng|Tin nhắn thoại buổi tối giữa hai người bạn thân",
  "Hà|Sorry for the late message. Rough day.|Xin lỗi nhắn muộn. Hôm nay tệ quá.",
  ">Bạn|No need to apologise. What happened?|Không phải xin lỗi đâu. Chuyện gì thế?",
  "Hà|I lost a client I worked on for months.|Mình mất một khách đã theo mấy tháng trời.",
  ">Bạn|That sounds really hard. I'm sorry.|Nghe nặng nề thật. Mình tiếc quá.",
  "Hà|I keep thinking I could have done more.|Mình cứ nghĩ giá như mình làm nhiều hơn.",
  ">Bạn|Do you want advice, or just to vent?|Bạn muốn nghe lời khuyên hay chỉ muốn xả thôi?",
  "Hà|Just to vent, honestly.|Thật ra chỉ muốn xả thôi.",
  ">Bạn|Then I'm listening. Take your time.|Vậy mình nghe đây. Bạn cứ từ từ.",
];

// --- 20. apology -----------------------------------------------------------

const List<String> apologyLines = <String>[
  "#|Xin lỗi đúng cách|Nhận lỗi rõ ràng thay vì vòng vo",
  "I'm sorry, that was my mistake.|Xin lỗi, đó là lỗi của tôi.|Nhận lỗi thẳng luôn tạo thiện cảm nhất.",
  "I should have told you sooner.|Đáng lẽ tôi phải nói với bạn sớm hơn.|Should have plus quá khứ phân từ cho việc đã không làm.",
  "I take full responsibility.|Tôi hoàn toàn chịu trách nhiệm.|Take responsibility for something.",
  "There's no excuse, and I understand you're upset.|Không có gì để biện minh, và tôi hiểu bạn đang bực.|Không kèm lý do là cách xin lỗi mạnh nhất.",
  "How can I make it right?|Tôi có thể bù đắp thế nào?|Make something right nghĩa là sửa cho đúng.",
  "It won't happen again.|Chuyện này sẽ không tái diễn.|Câu cam kết ngắn gọn.",
  "I'm sorry for the confusion I caused.|Xin lỗi vì tôi đã gây nhầm lẫn.|Sorry for plus danh từ hoặc danh động từ.",
  "Thank you for telling me directly.|Cảm ơn bạn đã nói thẳng với tôi.|Câu ghi nhận khi ai đó góp ý thật.",
  "#|Từ chối mà giữ quan hệ|Nói không một cách rõ ràng và tử tế",
  "I'd love to help, but I can't this time.|Mình rất muốn giúp, nhưng lần này thì không được.|Cấu trúc khen trước, từ chối sau.",
  "That doesn't work for me, sorry.|Cái đó không hợp với mình, xin lỗi nhé.|Work for someone nghĩa là hợp với ai.",
  "I'm going to pass on this one.|Lần này mình xin phép bỏ qua.|Pass on something nghĩa là từ chối tham gia.",
  "Let me be honest about my capacity.|Cho mình nói thật về sức mình.|Capacity ở đây là khả năng nhận việc.",
  "I can do part of it, but not all.|Mình làm được một phần, không làm hết được.|Nêu rõ phần làm được để khỏi cụt.",
  "Could we find another way?|Hay mình tìm cách khác nhé?|Find another way nghĩa là tìm hướng khác.",
  "I need to check before I promise anything.|Mình phải kiểm tra trước khi hứa gì.|Tránh hứa vội mà không giữ được.",
  "No, but thank you for asking.|Không được, nhưng cảm ơn bạn đã hỏi.|Câu từ chối gọn mà vẫn ấm.",
  "#|Xử lý hiểu lầm|Làm rõ và hạ nhiệt tình huống",
  "I think there's been a misunderstanding.|Mình nghĩ có chút hiểu lầm ở đây.|There has been a misunderstanding là mẫu trung tính.",
  "That's not what I meant, let me rephrase.|Ý mình không phải vậy, để mình nói lại.|Rephrase nghĩa là diễn đạt lại.",
  "Can we start over?|Mình bắt đầu lại từ đầu nhé?|Start over nghĩa là làm lại từ đầu.",
  "I hear you, and you're right about that part.|Mình nghe rồi, và phần đó bạn đúng.|I hear you là câu công nhận rất hiệu quả.",
  "Let's take a break and come back to this.|Mình nghỉ chút rồi quay lại chuyện này nhé.|Take a break để hạ nhiệt.",
  "I'd like to clear the air.|Mình muốn nói cho rõ ràng để hết gợn.|Clear the air nghĩa là giải toả hiểu lầm.",
  "I value this more than being right.|Với mình mối quan hệ này quan trọng hơn việc ai đúng.|Value something more than something.",
  "Are we good?|Mình ổn rồi chứ?|Câu hỏi làm lành rất đời thường.",
];

const List<String> apologyWords = <String>[
  "apologise|/əˈpɑːlədʒaɪz/|v|xin lỗi|He apologised right away.|Anh ấy xin lỗi ngay.",
  "misunderstanding|/ˌmɪsʌndərˈstændɪŋ/|n|sự hiểu lầm|It was just a misunderstanding.|Chỉ là hiểu lầm thôi.",
  "blame|/bleɪm/|n, v|đổ lỗi|Nobody is blaming you.|Không ai đổ lỗi cho bạn cả.",
  "excuse|/ɪkˈskjuːs/|n|lý do biện minh|That is not a good excuse.|Đó không phải lý do chính đáng.",
  "reassure|/ˌriːəˈʃʊr/|v|trấn an|She reassured the client.|Cô ấy trấn an khách hàng.",
  "compromise|/ˈkɑːmprəmaɪz/|n, v|thoả hiệp|We reached a compromise.|Bọn mình đạt được thoả hiệp.",
  "regret|/rɪˈɡret/|n, v|hối tiếc|I regret how I said it.|Mình tiếc vì cách mình nói.",
  "forgive|/fərˈɡɪv/|v|tha thứ|She forgave him quickly.|Cô ấy tha thứ cho anh ta nhanh chóng.",
  "boundary|/ˈbaʊndri/|n|ranh giới|Setting boundaries is healthy.|Đặt ranh giới là điều lành mạnh.",
  "resolve|/rɪˈzɑːlv/|v|giải quyết|We resolved it in one call.|Bọn mình giải quyết xong trong một cuộc gọi.",
];

const List<String> apologyTalk = <String>[
  "#|Xin lỗi khách vì giao hàng chậm|Cuộc gọi giữa nhân viên và khách hàng",
  "Khách hàng|The delivery was two days late.|Hàng giao chậm hai ngày.",
  ">Bạn|You're right, and I'm sorry. That was our mistake.|Anh nói đúng, và tôi xin lỗi. Đó là lỗi bên chúng tôi.",
  "Khách hàng|We had to cancel an event because of it.|Vì thế bên tôi phải huỷ một sự kiện.",
  ">Bạn|I understand, and there is no excuse for it.|Tôi hiểu, và chuyện này không có gì biện minh được.",
  "Khách hàng|So what happens now?|Vậy giờ thế nào?",
  ">Bạn|How can I make it right for you?|Tôi có thể bù đắp cho anh thế nào ạ?",
  "Khách hàng|A discount on the next order would help.|Giảm giá đơn sau thì cũng đỡ.",
  ">Bạn|Done. I'll confirm it in writing today.|Vâng ạ. Hôm nay tôi xác nhận bằng văn bản.",
];
