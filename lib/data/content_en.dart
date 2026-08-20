import '../models/dialogue.dart';
import '../models/phrase.dart';

/// Nội dung tiếng Anh, chia theo mã tình huống.
const Map<String, List<Phrase>> enPhrases = <String, List<Phrase>>{
  'airport': <Phrase>[
    Phrase(
      id: 'en.airport.01',
      target: 'Where is the check-in counter for flight VN310?',
      vietnamese: 'Quầy làm thủ tục cho chuyến VN310 ở đâu ạ?',
      note: 'Đọc số hiệu chuyến bay từng ký tự: "V - N - three - ten".',
    ),
    Phrase(
      id: 'en.airport.02',
      target: 'I would like a window seat, please.',
      vietnamese: 'Cho tôi chỗ ngồi cạnh cửa sổ ạ.',
      note: 'Ghế lối đi là "aisle seat" — đọc là /aɪl/, chữ "s" câm.',
    ),
    Phrase(
      id: 'en.airport.03',
      target: 'I only have carry-on luggage.',
      vietnamese: 'Tôi chỉ có hành lý xách tay thôi.',
    ),
    Phrase(
      id: 'en.airport.04',
      target: 'How much is the excess baggage fee?',
      vietnamese: 'Phí hành lý quá cân là bao nhiêu ạ?',
    ),
    Phrase(
      id: 'en.airport.05',
      target: 'Which gate does the flight depart from?',
      vietnamese: 'Chuyến bay khởi hành ở cổng nào ạ?',
    ),
    Phrase(
      id: 'en.airport.06',
      target: "I'm here for tourism, for two weeks.",
      vietnamese: 'Tôi đến du lịch, trong hai tuần.',
      note: 'Câu trả lời chuẩn ở quầy nhập cảnh (immigration).',
    ),
    Phrase(
      id: 'en.airport.07',
      target: 'Nothing to declare.',
      vietnamese: 'Không có gì phải khai báo.',
      note: 'Dùng ở hải quan; cửa xanh là "nothing to declare".',
    ),
    Phrase(
      id: 'en.airport.08',
      target: 'My flight has been delayed. What are my options?',
      vietnamese: 'Chuyến bay của tôi bị hoãn. Tôi có những lựa chọn nào ạ?',
    ),
    Phrase(
      id: 'en.airport.09',
      target: 'My suitcase did not arrive on the belt.',
      vietnamese: 'Vali của tôi không ra băng chuyền.',
      note: 'Đến quầy "Baggage Claim" hoặc "Lost & Found" để báo.',
    ),
    Phrase(
      id: 'en.airport.10',
      target: 'boarding pass',
      vietnamese: 'thẻ lên máy bay',
      isSentence: false,
    ),
    Phrase(
      id: 'en.airport.11',
      target: 'departure / arrival',
      vietnamese: 'khởi hành / đến nơi',
      isSentence: false,
    ),
    Phrase(
      id: 'en.airport.12',
      target: 'connecting flight',
      vietnamese: 'chuyến bay nối chuyến',
      isSentence: false,
    ),
  ],
  'hotel': <Phrase>[
    Phrase(
      id: 'en.hotel.01',
      target: 'I have a reservation under the name Nam.',
      vietnamese: 'Tôi có đặt phòng dưới tên Nam.',
    ),
    Phrase(
      id: 'en.hotel.02',
      target: 'What time is check-in and check-out?',
      vietnamese: 'Mấy giờ nhận phòng và trả phòng ạ?',
    ),
    Phrase(
      id: 'en.hotel.03',
      target: 'Could I have a room on a higher floor?',
      vietnamese: 'Tôi xin phòng ở tầng cao hơn được không ạ?',
    ),
    Phrase(
      id: 'en.hotel.04',
      target: 'Is breakfast included in the rate?',
      vietnamese: 'Giá phòng đã bao gồm bữa sáng chưa ạ?',
    ),
    Phrase(
      id: 'en.hotel.05',
      target: 'What is the Wi-Fi password?',
      vietnamese: 'Mật khẩu Wi-Fi là gì ạ?',
    ),
    Phrase(
      id: 'en.hotel.06',
      target: 'The air conditioning is not working.',
      vietnamese: 'Điều hoà không hoạt động.',
      note: 'Thay "air conditioning" bằng "hot water", "TV", "shower"…',
    ),
    Phrase(
      id: 'en.hotel.07',
      target: 'Could you store my luggage until 6 p.m.?',
      vietnamese: 'Anh/chị giữ hành lý giúp tôi đến 6 giờ chiều được không?',
    ),
    Phrase(
      id: 'en.hotel.08',
      target: 'I would like to extend my stay by one night.',
      vietnamese: 'Tôi muốn ở thêm một đêm nữa.',
    ),
    Phrase(
      id: 'en.hotel.09',
      target: 'Could I have a late check-out?',
      vietnamese: 'Tôi trả phòng muộn được không ạ?',
    ),
    Phrase(
      id: 'en.hotel.10',
      target: 'front desk / reception',
      vietnamese: 'quầy lễ tân',
      isSentence: false,
    ),
    Phrase(
      id: 'en.hotel.11',
      target: 'deposit',
      vietnamese: 'tiền đặt cọc',
      isSentence: false,
    ),
    Phrase(
      id: 'en.hotel.12',
      target: 'housekeeping',
      vietnamese: 'bộ phận dọn phòng',
      isSentence: false,
    ),
  ],
  'restaurant': <Phrase>[
    Phrase(
      id: 'en.restaurant.01',
      target: 'A table for two, please.',
      vietnamese: 'Cho tôi bàn hai người ạ.',
    ),
    Phrase(
      id: 'en.restaurant.02',
      target: 'Could we see the menu, please?',
      vietnamese: 'Cho chúng tôi xem thực đơn với ạ.',
    ),
    Phrase(
      id: 'en.restaurant.03',
      target: 'What do you recommend?',
      vietnamese: 'Anh/chị gợi ý món nào ạ?',
    ),
    Phrase(
      id: 'en.restaurant.04',
      target: "I'm allergic to peanuts.",
      vietnamese: 'Tôi bị dị ứng đậu phộng.',
      note: 'Câu quan trọng nhất trong nhóm này — học thuộc trước tiên.',
    ),
    Phrase(
      id: 'en.restaurant.05',
      target: "I'm vegetarian. Does this contain meat?",
      vietnamese: 'Tôi ăn chay. Món này có thịt không ạ?',
    ),
    Phrase(
      id: 'en.restaurant.06',
      target: 'Not too spicy, please.',
      vietnamese: 'Cho ít cay thôi ạ.',
    ),
    Phrase(
      id: 'en.restaurant.07',
      target: 'Could I have some water, please?',
      vietnamese: 'Cho tôi xin ít nước ạ.',
    ),
    Phrase(
      id: 'en.restaurant.08',
      target: 'Could we get the bill, please?',
      vietnamese: 'Cho chúng tôi thanh toán ạ.',
      note: 'Ở Mỹ nói "check" thay cho "bill".',
    ),
    Phrase(
      id: 'en.restaurant.09',
      target: 'Can I pay by card?',
      vietnamese: 'Tôi trả bằng thẻ được không ạ?',
    ),
    Phrase(
      id: 'en.restaurant.10',
      target: 'Could I get this to go?',
      vietnamese: 'Cho tôi mang về được không ạ?',
    ),
    Phrase(
      id: 'en.restaurant.11',
      target: 'appetizer / main course / dessert',
      vietnamese: 'khai vị / món chính / tráng miệng',
      isSentence: false,
    ),
    Phrase(
      id: 'en.restaurant.12',
      target: 'tip',
      vietnamese: 'tiền boa',
      isSentence: false,
    ),
  ],
  'taxi': <Phrase>[
    Phrase(
      id: 'en.taxi.01',
      target: 'Could you take me to this address, please?',
      vietnamese: 'Anh/chị chở tôi đến địa chỉ này được không ạ?',
      note: 'Đưa màn hình điện thoại kèm địa chỉ là cách an toàn nhất.',
    ),
    Phrase(
      id: 'en.taxi.02',
      target: 'How much is it to the city centre?',
      vietnamese: 'Đi vào trung tâm hết bao nhiêu ạ?',
    ),
    Phrase(
      id: 'en.taxi.03',
      target: 'Please use the meter.',
      vietnamese: 'Anh/chị bật đồng hồ giúp tôi.',
    ),
    Phrase(
      id: 'en.taxi.04',
      target: 'How long does it take?',
      vietnamese: 'Đi mất bao lâu ạ?',
    ),
    Phrase(
      id: 'en.taxi.05',
      target: 'Could you stop here, please?',
      vietnamese: 'Anh/chị dừng ở đây giúp tôi.',
    ),
    Phrase(
      id: 'en.taxi.06',
      target: 'Please turn left at the next corner.',
      vietnamese: 'Rẽ trái ở góc phố tiếp theo ạ.',
    ),
    Phrase(
      id: 'en.taxi.07',
      target: "I'm in a hurry — I have a flight at six.",
      vietnamese: 'Tôi đang vội — tôi có chuyến bay lúc 6 giờ.',
    ),
    Phrase(
      id: 'en.taxi.08',
      target: 'Keep the change.',
      vietnamese: 'Khỏi thối lại ạ.',
    ),
    Phrase(
      id: 'en.taxi.09',
      target: 'Could I have a receipt?',
      vietnamese: 'Cho tôi xin hoá đơn ạ.',
    ),
    Phrase(
      id: 'en.taxi.10',
      target: 'Which platform for the airport train?',
      vietnamese: 'Tàu ra sân bay ở sân ga nào ạ?',
    ),
    Phrase(
      id: 'en.taxi.11',
      target: 'straight / left / right',
      vietnamese: 'thẳng / trái / phải',
      isSentence: false,
    ),
    Phrase(
      id: 'en.taxi.12',
      target: 'fare',
      vietnamese: 'tiền cước',
      isSentence: false,
    ),
  ],
};

const Map<String, List<Dialogue>> enDialogues = <String, List<Dialogue>>{
  'airport': <Dialogue>[
    Dialogue(
      id: 'en.airport.d1',
      title: 'Làm thủ tục bay',
      subtitle: 'Bạn ↔ nhân viên check-in',
      lines: <DialogueLine>[
        DialogueLine(
          speaker: 'Nhân viên',
          target: 'Good morning. May I see your passport, please?',
          vietnamese: 'Chào buổi sáng. Cho tôi xem hộ chiếu của anh/chị ạ?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Here you are.',
          vietnamese: 'Đây ạ.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Nhân viên',
          target: 'Are you checking any bags today?',
          vietnamese: 'Hôm nay anh/chị có gửi hành lý không ạ?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Just one suitcase. I only have carry-on for the rest.',
          vietnamese: 'Chỉ một vali thôi. Còn lại tôi xách tay.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Nhân viên',
          target: 'Window or aisle?',
          vietnamese: 'Anh/chị muốn ghế cạnh cửa sổ hay lối đi?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'A window seat, please. Which gate does it depart from?',
          vietnamese: 'Cho tôi ghế cạnh cửa sổ ạ. Bay ở cổng nào ạ?',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Nhân viên',
          target: 'Gate 24. Boarding starts at 9:40.',
          vietnamese: 'Cổng 24. Bắt đầu lên máy bay lúc 9 giờ 40.',
        ),
      ],
    ),
  ],
  'hotel': <Dialogue>[
    Dialogue(
      id: 'en.hotel.d1',
      title: 'Nhận phòng khách sạn',
      subtitle: 'Bạn ↔ lễ tân',
      lines: <DialogueLine>[
        DialogueLine(
          speaker: 'Lễ tân',
          target: 'Good evening! Do you have a reservation?',
          vietnamese: 'Chào buổi tối! Anh/chị có đặt phòng trước không ạ?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Yes, I have a reservation under the name Nam, for three nights.',
          vietnamese: 'Có ạ, tôi đặt dưới tên Nam, ba đêm.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Lễ tân',
          target: 'Found it. I just need a card for the deposit.',
          vietnamese: 'Tôi tìm thấy rồi. Cho tôi xin thẻ để đặt cọc ạ.',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Here you go. Is breakfast included?',
          vietnamese: 'Thẻ đây ạ. Bữa sáng có bao gồm không ạ?',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Lễ tân',
          target: 'It is, from 6:30 to 10 on the second floor.',
          vietnamese: 'Có ạ, từ 6 giờ rưỡi đến 10 giờ ở tầng hai.',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Great. And what is the Wi-Fi password?',
          vietnamese: 'Tuyệt. Mật khẩu Wi-Fi là gì ạ?',
          isUser: true,
        ),
      ],
    ),
  ],
  'restaurant': <Dialogue>[
    Dialogue(
      id: 'en.restaurant.d1',
      title: 'Gọi món',
      subtitle: 'Bạn ↔ phục vụ',
      lines: <DialogueLine>[
        DialogueLine(
          speaker: 'Phục vụ',
          target: 'Hi! Table for how many?',
          vietnamese: 'Xin chào! Bàn cho mấy người ạ?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'A table for two, please.',
          vietnamese: 'Cho tôi bàn hai người ạ.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Phục vụ',
          target: 'Right this way. Are you ready to order?',
          vietnamese: 'Mời đi lối này. Anh/chị gọi món chưa ạ?',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: "What do you recommend? I'm allergic to peanuts.",
          vietnamese: 'Anh/chị gợi ý món nào ạ? Tôi bị dị ứng đậu phộng.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Phục vụ',
          target: 'The grilled fish is peanut-free and very popular.',
          vietnamese: 'Món cá nướng không có đậu phộng và rất được ưa chuộng.',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: "Perfect, two of those. Not too spicy, please.",
          vietnamese: 'Tuyệt, cho hai phần. Cho ít cay thôi ạ.',
          isUser: true,
        ),
      ],
    ),
  ],
  'taxi': <Dialogue>[
    Dialogue(
      id: 'en.taxi.d1',
      title: 'Bắt taxi về khách sạn',
      subtitle: 'Bạn ↔ tài xế',
      lines: <DialogueLine>[
        DialogueLine(
          speaker: 'Bạn',
          target: 'Hi, could you take me to this address, please?',
          vietnamese: 'Chào anh, anh chở tôi đến địa chỉ này được không ạ?',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Tài xế',
          target: 'Sure, hop in. That is about twenty minutes.',
          vietnamese: 'Được, lên xe đi. Khoảng hai mươi phút.',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'How much will it be? Please use the meter.',
          vietnamese: 'Hết bao nhiêu ạ? Anh bật đồng hồ giúp tôi.',
          isUser: true,
        ),
        DialogueLine(
          speaker: 'Tài xế',
          target: 'Of course. Around 250 with the meter.',
          vietnamese: 'Tất nhiên rồi. Khoảng 250 theo đồng hồ.',
        ),
        DialogueLine(
          speaker: 'Bạn',
          target: 'Could you stop here, please? And can I have a receipt?',
          vietnamese: 'Anh dừng ở đây giúp tôi. Cho tôi xin hoá đơn nữa ạ?',
          isUser: true,
        ),
      ],
    ),
  ],
};
