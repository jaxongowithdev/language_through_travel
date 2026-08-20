import 'package:flutter/material.dart';

import '../models/guide.dart';

/// Nội dung tab "Cẩm nang": kiến thức nền mà một chuyến đi cần nhưng không
/// nằm gọn trong bốn chặng hành trình — số đếm, tiền bạc, khẩn cấp, văn hoá.
///
/// Tách riêng khỏi `content_*.dart` vì đây là nội dung tra cứu, không đưa vào
/// lịch lặp lại ngắt quãng.
const Map<String, List<GuideTopic>> guideTopicsByLanguage =
    <String, List<GuideTopic>>{
  'en': _enTopics,
  'ja': _jaTopics,
  'ko': _koTopics,
  'th': _thTopics,
};

// Màu và icon dùng chung cho mọi ngôn ngữ để thanh chủ đề trông nhất quán.
const Color _cPronounce = Color(0xFF3B82F6);
const Color _cNumbers = Color(0xFF8B5CF6);
const Color _cMoney = Color(0xFFF59E0B);
const Color _cEmergency = Color(0xFFEF4444);
const Color _cEtiquette = Color(0xFF10B981);
const Color _cDirection = Color(0xFF06B6D4);

// ---------------------------------------------------------------------------
// Tiếng Anh
// ---------------------------------------------------------------------------

const List<GuideTopic> _enTopics = <GuideTopic>[
  GuideTopic(
    id: 'emergency',
    title: 'Khẩn cấp & an toàn',
    subtitle: 'Câu phải thuộc trước khi bay',
    icon: Icons.medical_services_rounded,
    color: _cEmergency,
    cards: <GuideCard>[
      GuideCard(
        title: 'Gọi trợ giúp',
        emoji: '🆘',
        body: 'Số khẩn cấp: 911 (Mỹ, Canada), 999 (Anh), 112 (châu Âu, Úc).',
        entries: <GuideEntry>[
          GuideEntry(target: 'Help!', vietnamese: 'Cứu với!'),
          GuideEntry(
            target: 'Please call the police.',
            vietnamese: 'Làm ơn gọi cảnh sát.',
          ),
          GuideEntry(
            target: 'I need a doctor.',
            vietnamese: 'Tôi cần bác sĩ.',
          ),
          GuideEntry(
            target: 'Call an ambulance, please!',
            vietnamese: 'Làm ơn gọi xe cấp cứu!',
          ),
          GuideEntry(
            target: 'Where is the nearest hospital?',
            vietnamese: 'Bệnh viện gần nhất ở đâu?',
          ),
        ],
      ),
      GuideCard(
        title: 'Mất đồ, lạc đường',
        emoji: '🧳',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'I lost my passport.',
            vietnamese: 'Tôi làm mất hộ chiếu.',
          ),
          GuideEntry(
            target: 'My bag was stolen.',
            vietnamese: 'Túi của tôi bị lấy trộm.',
          ),
          GuideEntry(target: 'I am lost.', vietnamese: 'Tôi bị lạc.'),
          GuideEntry(
            target: 'Can you help me, please?',
            vietnamese: 'Bạn giúp tôi được không?',
          ),
          GuideEntry(
            target: 'Where is the Vietnamese embassy?',
            vietnamese: 'Đại sứ quán Việt Nam ở đâu?',
          ),
        ],
      ),
      GuideCard(
        title: 'Sức khoẻ & dị ứng',
        emoji: '💊',
        body: 'Nói rõ thứ mình dị ứng trước khi gọi món là cách an toàn nhất.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'I am allergic to peanuts.',
            vietnamese: 'Tôi bị dị ứng đậu phộng.',
          ),
          GuideEntry(
            target: 'I do not feel well.',
            vietnamese: 'Tôi thấy không khoẻ.',
          ),
          GuideEntry(
            target: 'Is there a pharmacy nearby?',
            vietnamese: 'Gần đây có hiệu thuốc không?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'numbers',
    title: 'Số đếm & đơn vị',
    subtitle: 'Nghe giá, đọc giờ, nhớ số phòng',
    icon: Icons.tag_rounded,
    color: _cNumbers,
    cards: <GuideCard>[
      GuideCard(
        title: 'Từ 0 đến 10',
        emoji: '🔢',
        entries: <GuideEntry>[
          GuideEntry(target: 'zero', vietnamese: '0'),
          GuideEntry(target: 'one', vietnamese: '1'),
          GuideEntry(target: 'two', vietnamese: '2'),
          GuideEntry(target: 'three', vietnamese: '3'),
          GuideEntry(target: 'four', vietnamese: '4'),
          GuideEntry(target: 'five', vietnamese: '5'),
          GuideEntry(target: 'six', vietnamese: '6'),
          GuideEntry(target: 'seven', vietnamese: '7'),
          GuideEntry(target: 'eight', vietnamese: '8'),
          GuideEntry(target: 'nine', vietnamese: '9'),
          GuideEntry(target: 'ten', vietnamese: '10'),
        ],
      ),
      GuideCard(
        title: 'Chục, trăm, nghìn',
        emoji: '💯',
        body: 'Chú ý cặp dễ nhầm khi nghe giá: thirteen (13) và thirty (30).',
        entries: <GuideEntry>[
          GuideEntry(target: 'twenty', vietnamese: '20'),
          GuideEntry(target: 'thirty', vietnamese: '30'),
          GuideEntry(target: 'fifty', vietnamese: '50'),
          GuideEntry(target: 'one hundred', vietnamese: '100'),
          GuideEntry(target: 'one thousand', vietnamese: '1.000'),
        ],
      ),
      GuideCard(
        title: 'Hỏi số lượng',
        emoji: '🙋',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'How many people?',
            vietnamese: 'Bao nhiêu người?',
          ),
          GuideEntry(
            target: 'Two adults and one child.',
            vietnamese: 'Hai người lớn và một trẻ em.',
          ),
          GuideEntry(
            target: 'For three nights, please.',
            vietnamese: 'Cho tôi ba đêm.',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'money',
    title: 'Tiền bạc & mua sắm',
    subtitle: 'Hỏi giá, trả thẻ, xin hoá đơn',
    icon: Icons.payments_rounded,
    color: _cMoney,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi giá & thanh toán',
        emoji: '💳',
        entries: <GuideEntry>[
          GuideEntry(target: 'How much is this?', vietnamese: 'Cái này bao nhiêu?'),
          GuideEntry(
            target: 'Do you accept credit cards?',
            vietnamese: 'Ở đây có nhận thẻ không?',
          ),
          GuideEntry(target: 'Cash, please.', vietnamese: 'Tôi trả tiền mặt.'),
          GuideEntry(
            target: 'Can I have the receipt?',
            vietnamese: 'Cho tôi xin hoá đơn.',
          ),
          GuideEntry(
            target: 'I think the bill is wrong.',
            vietnamese: 'Tôi nghĩ hoá đơn bị nhầm.',
          ),
        ],
      ),
      GuideCard(
        title: 'Mặc cả nhẹ nhàng',
        emoji: '🏷️',
        body: 'Ở Anh, Mỹ, Úc gần như không mặc cả trong cửa hàng — chỉ chợ trời '
            'và hàng lưu niệm mới thương lượng được.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'That is a bit expensive.',
            vietnamese: 'Hơi đắt một chút.',
          ),
          GuideEntry(
            target: 'Can you give me a discount?',
            vietnamese: 'Giảm giá cho tôi được không?',
          ),
          GuideEntry(
            target: 'I will take it.',
            vietnamese: 'Tôi lấy cái này.',
          ),
        ],
      ),
      GuideCard(
        title: 'Tiền tip',
        emoji: '🪙',
        body: 'Mỹ: 15–20% ở nhà hàng, 1–2 đô cho nhân viên khách sạn. '
            'Anh và Úc: thường đã tính vào hoá đơn, tip là tuỳ tâm.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'Is service included?',
            vietnamese: 'Đã tính phí phục vụ chưa?',
          ),
          GuideEntry(target: 'Keep the change.', vietnamese: 'Khỏi thối lại.'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'directions',
    title: 'Thời gian & phương hướng',
    subtitle: 'Hỏi đường, hỏi giờ, bắt chuyến',
    icon: Icons.explore_rounded,
    color: _cDirection,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi đường',
        emoji: '🧭',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'Excuse me, where is the station?',
            vietnamese: 'Xin lỗi, nhà ga ở đâu?',
          ),
          GuideEntry(target: 'Turn left.', vietnamese: 'Rẽ trái.'),
          GuideEntry(target: 'Turn right.', vietnamese: 'Rẽ phải.'),
          GuideEntry(target: 'Go straight.', vietnamese: 'Đi thẳng.'),
          GuideEntry(
            target: 'Is it far from here?',
            vietnamese: 'Có xa đây không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Giờ giấc',
        emoji: '🕒',
        entries: <GuideEntry>[
          GuideEntry(target: 'What time is it?', vietnamese: 'Mấy giờ rồi?'),
          GuideEntry(
            target: 'What time does it open?',
            vietnamese: 'Mấy giờ mở cửa?',
          ),
          GuideEntry(target: 'today', vietnamese: 'hôm nay'),
          GuideEntry(target: 'tomorrow', vietnamese: 'ngày mai'),
          GuideEntry(target: 'in the morning', vietnamese: 'buổi sáng'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'etiquette',
    title: 'Lịch sự & văn hoá',
    subtitle: 'Nói ít mà không bị hiểu lầm',
    icon: Icons.emoji_people_rounded,
    color: _cEtiquette,
    cards: <GuideCard>[
      GuideCard(
        title: 'Ba câu cứu nguy',
        emoji: '🙏',
        body: 'Ba câu này gắn vào đầu hoặc cuối bất kỳ câu nào cũng thành lịch sự.',
        entries: <GuideEntry>[
          GuideEntry(target: 'Excuse me…', vietnamese: 'Xin lỗi cho hỏi…'),
          GuideEntry(target: 'Thank you so much.', vietnamese: 'Cảm ơn nhiều.'),
          GuideEntry(target: 'Sorry, my English is not good.',
              vietnamese: 'Xin lỗi, tiếng Anh của tôi chưa tốt.'),
        ],
      ),
      GuideCard(
        title: 'Khi chưa nghe kịp',
        emoji: '👂',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'Could you say that again, please?',
            vietnamese: 'Bạn nói lại giúp tôi được không?',
          ),
          GuideEntry(
            target: 'Could you speak more slowly?',
            vietnamese: 'Bạn nói chậm hơn được không?',
          ),
          GuideEntry(
            target: 'Could you write it down?',
            vietnamese: 'Bạn viết ra giúp tôi nhé?',
          ),
        ],
      ),
      GuideCard(
        title: 'Thói quen nên biết',
        emoji: '💡',
        body: 'Xếp hàng là chuyện nghiêm túc ở Anh — chen ngang bị nhắc ngay. '
            'Người Mỹ chào hỏi thân mật nhưng giữ khoảng cách một sải tay. '
            'Nói "please" ở cuối yêu cầu là mặc định, thiếu nó nghe như ra lệnh.',
      ),
    ],
  ),
  GuideTopic(
    id: 'pronunciation',
    title: 'Phát âm dễ sai',
    subtitle: 'Lỗi người Việt hay mắc nhất',
    icon: Icons.record_voice_over_rounded,
    color: _cPronounce,
    cards: <GuideCard>[
      GuideCard(
        title: 'Âm cuối phải bật ra',
        emoji: '🗣️',
        body: 'Tiếng Việt không có phụ âm cuối bật hơi, nên người Việt hay nuốt '
            'mất đuôi từ. Nghe kỹ khác biệt bên dưới.',
        entries: <GuideEntry>[
          GuideEntry(target: 'card', vietnamese: 'thẻ — bật rõ "d" ở cuối'),
          GuideEntry(target: 'bus', vietnamese: 'xe buýt — kéo dài "s"'),
          GuideEntry(target: 'flight', vietnamese: 'chuyến bay — bật "t"'),
        ],
      ),
      GuideCard(
        title: 'Cặp âm dễ lẫn',
        emoji: '👀',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'three',
            vietnamese: 'số 3 — lưỡi chạm răng, đừng đọc thành "tri"',
          ),
          GuideEntry(
            target: 'seat',
            vietnamese: 'chỗ ngồi — khác "sheet" (tấm ga)',
          ),
          GuideEntry(
            target: 'thirty',
            vietnamese: '30 — nhấn đầu; "thirteen" (13) nhấn cuối',
          ),
        ],
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Tiếng Nhật
// ---------------------------------------------------------------------------

const List<GuideTopic> _jaTopics = <GuideTopic>[
  GuideTopic(
    id: 'emergency',
    title: 'Khẩn cấp & an toàn',
    subtitle: 'Câu phải thuộc trước khi bay',
    icon: Icons.medical_services_rounded,
    color: _cEmergency,
    cards: <GuideCard>[
      GuideCard(
        title: 'Gọi trợ giúp',
        emoji: '🆘',
        body: 'Nhật Bản: 110 gọi cảnh sát, 119 gọi cứu hoả và cấp cứu.',
        entries: <GuideEntry>[
          GuideEntry(
            target: '助けて！',
            romanization: 'Tasukete!',
            vietnamese: 'Cứu với!',
          ),
          GuideEntry(
            target: '警察を呼んでください。',
            romanization: 'Keisatsu o yonde kudasai.',
            vietnamese: 'Làm ơn gọi cảnh sát.',
          ),
          GuideEntry(
            target: '救急車をお願いします。',
            romanization: 'Kyūkyūsha o onegai shimasu.',
            vietnamese: 'Làm ơn gọi xe cấp cứu.',
          ),
          GuideEntry(
            target: '病院はどこですか。',
            romanization: 'Byōin wa doko desu ka.',
            vietnamese: 'Bệnh viện ở đâu?',
          ),
        ],
      ),
      GuideCard(
        title: 'Mất đồ, lạc đường',
        emoji: '🧳',
        body: 'Nhật có 交番 (kōban) — chốt cảnh sát nhỏ ở hầu hết ngã tư lớn, '
            'nơi đầu tiên nên tìm khi lạc hoặc mất đồ.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'パスポートをなくしました。',
            romanization: 'Pasupōto o nakushimashita.',
            vietnamese: 'Tôi làm mất hộ chiếu.',
          ),
          GuideEntry(
            target: '道に迷いました。',
            romanization: 'Michi ni mayoimashita.',
            vietnamese: 'Tôi bị lạc đường.',
          ),
          GuideEntry(
            target: '助けてもらえますか。',
            romanization: 'Tasukete moraemasu ka.',
            vietnamese: 'Bạn giúp tôi được không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Sức khoẻ',
        emoji: '💊',
        entries: <GuideEntry>[
          GuideEntry(
            target: '気分が悪いです。',
            romanization: 'Kibun ga warui desu.',
            vietnamese: 'Tôi thấy không khoẻ.',
          ),
          GuideEntry(
            target: '薬局はどこですか。',
            romanization: 'Yakkyoku wa doko desu ka.',
            vietnamese: 'Hiệu thuốc ở đâu?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'numbers',
    title: 'Số đếm & đơn vị',
    subtitle: 'Nghe giá, đếm người, đếm đêm',
    icon: Icons.tag_rounded,
    color: _cNumbers,
    cards: <GuideCard>[
      GuideCard(
        title: 'Từ 1 đến 10',
        emoji: '🔢',
        entries: <GuideEntry>[
          GuideEntry(target: '一', romanization: 'ichi', vietnamese: '1'),
          GuideEntry(target: '二', romanization: 'ni', vietnamese: '2'),
          GuideEntry(target: '三', romanization: 'san', vietnamese: '3'),
          GuideEntry(target: '四', romanization: 'yon / shi', vietnamese: '4'),
          GuideEntry(target: '五', romanization: 'go', vietnamese: '5'),
          GuideEntry(target: '六', romanization: 'roku', vietnamese: '6'),
          GuideEntry(target: '七', romanization: 'nana / shichi', vietnamese: '7'),
          GuideEntry(target: '八', romanization: 'hachi', vietnamese: '8'),
          GuideEntry(target: '九', romanization: 'kyū', vietnamese: '9'),
          GuideEntry(target: '十', romanization: 'jū', vietnamese: '10'),
        ],
      ),
      GuideCard(
        title: 'Trăm, nghìn, vạn',
        emoji: '💯',
        body: 'Giá ở Nhật thường tính bằng nghìn yên, nên 千 và 万 là hai từ '
            'phải nghe được ngay.',
        entries: <GuideEntry>[
          GuideEntry(target: '百', romanization: 'hyaku', vietnamese: '100'),
          GuideEntry(target: '千', romanization: 'sen', vietnamese: '1.000'),
          GuideEntry(target: '一万', romanization: 'ichiman', vietnamese: '10.000'),
          GuideEntry(target: '円', romanization: 'en', vietnamese: 'yên (đơn vị tiền)'),
        ],
      ),
      GuideCard(
        title: 'Đếm người & đêm',
        emoji: '🙋',
        body: 'Tiếng Nhật đổi hậu tố theo thứ được đếm: 人 cho người, 泊 cho '
            'số đêm ở khách sạn.',
        entries: <GuideEntry>[
          GuideEntry(target: '一人', romanization: 'hitori', vietnamese: '1 người'),
          GuideEntry(target: '二人', romanization: 'futari', vietnamese: '2 người'),
          GuideEntry(target: '三人', romanization: 'san-nin', vietnamese: '3 người'),
          GuideEntry(target: '二泊', romanization: 'nihaku', vietnamese: '2 đêm'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'money',
    title: 'Tiền bạc & mua sắm',
    subtitle: 'Hỏi giá, trả thẻ, xin hoá đơn',
    icon: Icons.payments_rounded,
    color: _cMoney,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi giá & thanh toán',
        emoji: '💳',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'いくらですか。',
            romanization: 'Ikura desu ka.',
            vietnamese: 'Bao nhiêu tiền?',
          ),
          GuideEntry(
            target: 'カードで払えますか。',
            romanization: 'Kādo de haraemasu ka.',
            vietnamese: 'Trả thẻ được không?',
          ),
          GuideEntry(
            target: '現金でお願いします。',
            romanization: 'Genkin de onegai shimasu.',
            vietnamese: 'Cho tôi trả tiền mặt.',
          ),
          GuideEntry(
            target: 'レシートをください。',
            romanization: 'Reshīto o kudasai.',
            vietnamese: 'Cho tôi hoá đơn.',
          ),
        ],
      ),
      GuideCard(
        title: 'Không tip, không mặc cả',
        emoji: '🪙',
        body: 'Nhật Bản không có văn hoá tip — đưa thêm tiền có thể khiến nhân '
            'viên lúng túng. Giá niêm yết là giá cuối, gần như không mặc cả. '
            'Tiền được đặt lên khay nhỏ ở quầy chứ không đưa tận tay.',
        entries: <GuideEntry>[
          GuideEntry(
            target: '免税できますか。',
            romanization: 'Menzei dekimasu ka.',
            vietnamese: 'Có được miễn thuế không?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'directions',
    title: 'Thời gian & phương hướng',
    subtitle: 'Hỏi đường, hỏi giờ, bắt tàu',
    icon: Icons.explore_rounded,
    color: _cDirection,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi đường',
        emoji: '🧭',
        entries: <GuideEntry>[
          GuideEntry(
            target: '駅はどこですか。',
            romanization: 'Eki wa doko desu ka.',
            vietnamese: 'Nhà ga ở đâu?',
          ),
          GuideEntry(target: '左', romanization: 'hidari', vietnamese: 'bên trái'),
          GuideEntry(target: '右', romanization: 'migi', vietnamese: 'bên phải'),
          GuideEntry(
            target: 'まっすぐ',
            romanization: 'massugu',
            vietnamese: 'đi thẳng',
          ),
          GuideEntry(
            target: '遠いですか。',
            romanization: 'Tōi desu ka.',
            vietnamese: 'Có xa không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Giờ giấc',
        emoji: '🕒',
        entries: <GuideEntry>[
          GuideEntry(
            target: '今何時ですか。',
            romanization: 'Ima nanji desu ka.',
            vietnamese: 'Bây giờ mấy giờ?',
          ),
          GuideEntry(target: '今日', romanization: 'kyō', vietnamese: 'hôm nay'),
          GuideEntry(target: '明日', romanization: 'ashita', vietnamese: 'ngày mai'),
          GuideEntry(target: '午前', romanization: 'gozen', vietnamese: 'buổi sáng'),
          GuideEntry(target: '午後', romanization: 'gogo', vietnamese: 'buổi chiều'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'etiquette',
    title: 'Lịch sự & văn hoá',
    subtitle: 'Giữ ý tứ kiểu Nhật',
    icon: Icons.emoji_people_rounded,
    color: _cEtiquette,
    cards: <GuideCard>[
      GuideCard(
        title: 'Câu lịch sự cơ bản',
        emoji: '🙏',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'すみません。',
            romanization: 'Sumimasen.',
            vietnamese: 'Xin lỗi / cho hỏi (dùng được cả hai nghĩa)',
          ),
          GuideEntry(
            target: 'ありがとうございます。',
            romanization: 'Arigatō gozaimasu.',
            vietnamese: 'Cảm ơn ạ.',
          ),
          GuideEntry(
            target: 'お願いします。',
            romanization: 'Onegai shimasu.',
            vietnamese: 'Nhờ bạn giúp / làm ơn.',
          ),
          GuideEntry(
            target: '大丈夫です。',
            romanization: 'Daijōbu desu.',
            vietnamese: 'Không sao / tôi ổn.',
          ),
        ],
      ),
      GuideCard(
        title: 'Khi chưa nghe kịp',
        emoji: '👂',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'もう一度お願いします。',
            romanization: 'Mō ichido onegai shimasu.',
            vietnamese: 'Nói lại giúp tôi lần nữa.',
          ),
          GuideEntry(
            target: 'ゆっくり話してください。',
            romanization: 'Yukkuri hanashite kudasai.',
            vietnamese: 'Nói chậm lại giúp tôi.',
          ),
          GuideEntry(
            target: '日本語が下手です。',
            romanization: 'Nihongo ga heta desu.',
            vietnamese: 'Tiếng Nhật của tôi còn kém.',
          ),
        ],
      ),
      GuideCard(
        title: 'Thói quen nên biết',
        emoji: '💡',
        body: 'Không nói chuyện điện thoại trên tàu. Xếp hàng theo vạch kẻ ở ga. '
            'Cởi giày khi vào nhà, ryokan, một số nhà hàng. Không vừa đi vừa ăn '
            'ngoài đường. Cúi đầu nhẹ thay cho bắt tay là đủ lịch sự.',
      ),
    ],
  ),
  GuideTopic(
    id: 'pronunciation',
    title: 'Chữ viết & phát âm',
    subtitle: 'Ba bộ chữ và nhịp đọc',
    icon: Icons.record_voice_over_rounded,
    color: _cPronounce,
    cards: <GuideCard>[
      GuideCard(
        title: 'Ba bộ chữ',
        emoji: '🈶',
        body: 'Hiragana (ひらがな) viết từ thuần Nhật, katakana (カタカナ) viết từ '
            'mượn — biển hiệu du lịch dùng rất nhiều, kanji (漢字) là chữ Hán. '
            'Chỉ cần đọc được katakana là đã hiểu phần lớn thực đơn quốc tế.',
        entries: <GuideEntry>[
          GuideEntry(target: 'ホテル', romanization: 'hoteru', vietnamese: 'hotel'),
          GuideEntry(target: 'タクシー', romanization: 'takushī', vietnamese: 'taxi'),
          GuideEntry(target: 'コーヒー', romanization: 'kōhī', vietnamese: 'cà phê'),
        ],
      ),
      GuideCard(
        title: 'Trường âm đổi nghĩa',
        emoji: '🗣️',
        body: 'Kéo dài nguyên âm là một âm tiết riêng, đọc thiếu sẽ thành từ khác.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'おばさん / おばあさん',
            romanization: 'obasan / obāsan',
            vietnamese: 'cô, dì / bà cụ',
          ),
          GuideEntry(
            target: 'ビル / ビール',
            romanization: 'biru / bīru',
            vietnamese: 'toà nhà / bia',
          ),
        ],
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Tiếng Hàn
// ---------------------------------------------------------------------------

const List<GuideTopic> _koTopics = <GuideTopic>[
  GuideTopic(
    id: 'emergency',
    title: 'Khẩn cấp & an toàn',
    subtitle: 'Câu phải thuộc trước khi bay',
    icon: Icons.medical_services_rounded,
    color: _cEmergency,
    cards: <GuideCard>[
      GuideCard(
        title: 'Gọi trợ giúp',
        emoji: '🆘',
        body: 'Hàn Quốc: 112 gọi cảnh sát, 119 gọi cứu hoả và cấp cứu. '
            'Tổng đài du lịch 1330 có hỗ trợ tiếng Anh 24/7.',
        entries: <GuideEntry>[
          GuideEntry(
            target: '도와주세요!',
            romanization: 'Dowajuseyo!',
            vietnamese: 'Cứu tôi với!',
          ),
          GuideEntry(
            target: '경찰을 불러 주세요.',
            romanization: 'Gyeongchareul bulleo juseyo.',
            vietnamese: 'Làm ơn gọi cảnh sát.',
          ),
          GuideEntry(
            target: '구급차를 불러 주세요.',
            romanization: 'Gugeupchareul bulleo juseyo.',
            vietnamese: 'Làm ơn gọi xe cấp cứu.',
          ),
          GuideEntry(
            target: '병원이 어디예요?',
            romanization: 'Byeongwoni eodiyeyo?',
            vietnamese: 'Bệnh viện ở đâu?',
          ),
        ],
      ),
      GuideCard(
        title: 'Mất đồ, lạc đường',
        emoji: '🧳',
        entries: <GuideEntry>[
          GuideEntry(
            target: '여권을 잃어버렸어요.',
            romanization: 'Yeogwoneul ilheobeoryeosseoyo.',
            vietnamese: 'Tôi làm mất hộ chiếu.',
          ),
          GuideEntry(
            target: '길을 잃었어요.',
            romanization: 'Gireul ilheosseoyo.',
            vietnamese: 'Tôi bị lạc đường.',
          ),
          GuideEntry(
            target: '가방을 도난당했어요.',
            romanization: 'Gabangeul donandanghaesseoyo.',
            vietnamese: 'Túi của tôi bị lấy trộm.',
          ),
        ],
      ),
      GuideCard(
        title: 'Sức khoẻ',
        emoji: '💊',
        entries: <GuideEntry>[
          GuideEntry(
            target: '몸이 안 좋아요.',
            romanization: 'Momi an johayo.',
            vietnamese: 'Tôi thấy không khoẻ.',
          ),
          GuideEntry(
            target: '약국이 어디예요?',
            romanization: 'Yakgugi eodiyeyo?',
            vietnamese: 'Hiệu thuốc ở đâu?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'numbers',
    title: 'Số đếm & đơn vị',
    subtitle: 'Hai hệ số và cách dùng',
    icon: Icons.tag_rounded,
    color: _cNumbers,
    cards: <GuideCard>[
      GuideCard(
        title: 'Số Hán Hàn — dùng cho tiền, phút, ngày',
        emoji: '🔢',
        entries: <GuideEntry>[
          GuideEntry(target: '일', romanization: 'il', vietnamese: '1'),
          GuideEntry(target: '이', romanization: 'i', vietnamese: '2'),
          GuideEntry(target: '삼', romanization: 'sam', vietnamese: '3'),
          GuideEntry(target: '사', romanization: 'sa', vietnamese: '4'),
          GuideEntry(target: '오', romanization: 'o', vietnamese: '5'),
          GuideEntry(target: '육', romanization: 'yuk', vietnamese: '6'),
          GuideEntry(target: '칠', romanization: 'chil', vietnamese: '7'),
          GuideEntry(target: '팔', romanization: 'pal', vietnamese: '8'),
          GuideEntry(target: '구', romanization: 'gu', vietnamese: '9'),
          GuideEntry(target: '십', romanization: 'sip', vietnamese: '10'),
        ],
      ),
      GuideCard(
        title: 'Số thuần Hàn — dùng để đếm đồ, đếm người',
        emoji: '🙋',
        body: 'Gọi hai ly cà phê là 커피 두 잔, không dùng 이 잔.',
        entries: <GuideEntry>[
          GuideEntry(target: '하나', romanization: 'hana', vietnamese: '1 (cái)'),
          GuideEntry(target: '둘', romanization: 'dul', vietnamese: '2 (cái)'),
          GuideEntry(target: '셋', romanization: 'set', vietnamese: '3 (cái)'),
          GuideEntry(target: '넷', romanization: 'net', vietnamese: '4 (cái)'),
          GuideEntry(target: '다섯', romanization: 'daseot', vietnamese: '5 (cái)'),
        ],
      ),
      GuideCard(
        title: 'Trăm, nghìn, vạn',
        emoji: '💯',
        body: 'Giá ở Hàn thường tính theo vạn won (만원), nên nghe được 만 là '
            'nghe được giá.',
        entries: <GuideEntry>[
          GuideEntry(target: '백', romanization: 'baek', vietnamese: '100'),
          GuideEntry(target: '천', romanization: 'cheon', vietnamese: '1.000'),
          GuideEntry(target: '만', romanization: 'man', vietnamese: '10.000'),
          GuideEntry(target: '원', romanization: 'won', vietnamese: 'won (đơn vị tiền)'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'money',
    title: 'Tiền bạc & mua sắm',
    subtitle: 'Hỏi giá, trả thẻ, hoàn thuế',
    icon: Icons.payments_rounded,
    color: _cMoney,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi giá & thanh toán',
        emoji: '💳',
        entries: <GuideEntry>[
          GuideEntry(
            target: '얼마예요?',
            romanization: 'Eolmayeyo?',
            vietnamese: 'Bao nhiêu tiền?',
          ),
          GuideEntry(
            target: '카드 되나요?',
            romanization: 'Kadeu doenayo?',
            vietnamese: 'Có nhận thẻ không?',
          ),
          GuideEntry(
            target: '현금으로 낼게요.',
            romanization: 'Hyeon-geumeuro naelgeyo.',
            vietnamese: 'Tôi trả tiền mặt.',
          ),
          GuideEntry(
            target: '영수증 주세요.',
            romanization: 'Yeongsujeung juseyo.',
            vietnamese: 'Cho tôi hoá đơn.',
          ),
        ],
      ),
      GuideCard(
        title: 'Mặc cả & hoàn thuế',
        emoji: '🏷️',
        body: 'Cửa hàng và siêu thị niêm yết giá cố định. Chợ truyền thống như '
            'Namdaemun, Dongdaemun thì mặc cả nhẹ được. Hàn Quốc không có văn '
            'hoá tip.',
        entries: <GuideEntry>[
          GuideEntry(
            target: '좀 깎아 주세요.',
            romanization: 'Jom kkakka juseyo.',
            vietnamese: 'Giảm giá một chút đi ạ.',
          ),
          GuideEntry(
            target: '택스 리펀 되나요?',
            romanization: 'Tekseu ripeon doenayo?',
            vietnamese: 'Có hoàn thuế không?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'directions',
    title: 'Thời gian & phương hướng',
    subtitle: 'Hỏi đường, hỏi giờ, bắt tàu',
    icon: Icons.explore_rounded,
    color: _cDirection,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi đường',
        emoji: '🧭',
        entries: <GuideEntry>[
          GuideEntry(
            target: '지하철역이 어디예요?',
            romanization: 'Jihacheollyeogi eodiyeyo?',
            vietnamese: 'Ga tàu điện ngầm ở đâu?',
          ),
          GuideEntry(target: '왼쪽', romanization: 'oenjjok', vietnamese: 'bên trái'),
          GuideEntry(target: '오른쪽', romanization: 'oreunjjok', vietnamese: 'bên phải'),
          GuideEntry(target: '직진', romanization: 'jikjin', vietnamese: 'đi thẳng'),
          GuideEntry(
            target: '여기서 멀어요?',
            romanization: 'Yeogiseo meoreoyo?',
            vietnamese: 'Có xa đây không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Giờ giấc',
        emoji: '🕒',
        entries: <GuideEntry>[
          GuideEntry(
            target: '지금 몇 시예요?',
            romanization: 'Jigeum myeot siyeyo?',
            vietnamese: 'Bây giờ mấy giờ?',
          ),
          GuideEntry(target: '오늘', romanization: 'oneul', vietnamese: 'hôm nay'),
          GuideEntry(target: '내일', romanization: 'naeil', vietnamese: 'ngày mai'),
          GuideEntry(target: '오전', romanization: 'ojeon', vietnamese: 'buổi sáng'),
          GuideEntry(target: '오후', romanization: 'ohu', vietnamese: 'buổi chiều'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'etiquette',
    title: 'Lịch sự & văn hoá',
    subtitle: 'Kính ngữ và cách cư xử',
    icon: Icons.emoji_people_rounded,
    color: _cEtiquette,
    cards: <GuideCard>[
      GuideCard(
        title: 'Câu lịch sự cơ bản',
        emoji: '🙏',
        body: 'Đuôi -요 là mức lịch sự an toàn cho khách du lịch trong mọi tình huống.',
        entries: <GuideEntry>[
          GuideEntry(
            target: '안녕하세요.',
            romanization: 'Annyeonghaseyo.',
            vietnamese: 'Xin chào.',
          ),
          GuideEntry(
            target: '감사합니다.',
            romanization: 'Gamsahamnida.',
            vietnamese: 'Cảm ơn ạ.',
          ),
          GuideEntry(
            target: '죄송합니다.',
            romanization: 'Joesonghamnida.',
            vietnamese: 'Tôi xin lỗi.',
          ),
          GuideEntry(
            target: '저기요.',
            romanization: 'Jeogiyo.',
            vietnamese: 'Cho hỏi / gọi nhân viên.',
          ),
        ],
      ),
      GuideCard(
        title: 'Khi chưa nghe kịp',
        emoji: '👂',
        entries: <GuideEntry>[
          GuideEntry(
            target: '다시 말해 주세요.',
            romanization: 'Dasi malhae juseyo.',
            vietnamese: 'Nói lại giúp tôi.',
          ),
          GuideEntry(
            target: '천천히 말해 주세요.',
            romanization: 'Cheoncheonhi malhae juseyo.',
            vietnamese: 'Nói chậm lại giúp tôi.',
          ),
          GuideEntry(
            target: '한국어를 잘 못해요.',
            romanization: 'Hangugeoreul jal mothaeyo.',
            vietnamese: 'Tôi nói tiếng Hàn chưa tốt.',
          ),
        ],
      ),
      GuideCard(
        title: 'Thói quen nên biết',
        emoji: '💡',
        body: 'Nhận và đưa đồ bằng hai tay, nhất là với người lớn tuổi. '
            'Cởi giày khi vào nhà. Trên tàu điện có ghế ưu tiên — nên để trống. '
            'Người trẻ thường rót nước cho người lớn tuổi trước.',
      ),
    ],
  ),
  GuideTopic(
    id: 'pronunciation',
    title: 'Hangul & phát âm',
    subtitle: 'Bảng chữ học được trong một buổi',
    icon: Icons.record_voice_over_rounded,
    color: _cPronounce,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hangul ghép theo khối',
        emoji: '🈚',
        body: 'Mỗi chữ là một khối phụ âm + nguyên âm (+ phụ âm cuối). '
            'Đọc được 24 chữ cái là đọc được mọi biển hiệu, kể cả khi chưa hiểu nghĩa.',
        entries: <GuideEntry>[
          GuideEntry(target: '한', romanization: 'h + a + n = han', vietnamese: 'ví dụ khối chữ'),
          GuideEntry(target: '커피', romanization: 'keopi', vietnamese: 'cà phê'),
          GuideEntry(target: '택시', romanization: 'taeksi', vietnamese: 'taxi'),
        ],
      ),
      GuideCard(
        title: 'Âm dễ nhầm',
        emoji: '🗣️',
        entries: <GuideEntry>[
          GuideEntry(
            target: '불 / 뿔 / 풀',
            romanization: 'bul / ppul / pul',
            vietnamese: 'lửa / sừng / cỏ — khác nhau ở độ bật hơi',
          ),
          GuideEntry(
            target: '어 / 오',
            romanization: 'eo / o',
            vietnamese: 'miệng mở rộng / miệng tròn',
          ),
        ],
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Tiếng Thái
// ---------------------------------------------------------------------------

const List<GuideTopic> _thTopics = <GuideTopic>[
  GuideTopic(
    id: 'emergency',
    title: 'Khẩn cấp & an toàn',
    subtitle: 'Câu phải thuộc trước khi bay',
    icon: Icons.medical_services_rounded,
    color: _cEmergency,
    cards: <GuideCard>[
      GuideCard(
        title: 'Gọi trợ giúp',
        emoji: '🆘',
        body: 'Thái Lan: 191 gọi cảnh sát, 1669 gọi cấp cứu, 1155 là cảnh sát '
            'du lịch có tiếng Anh.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'ช่วยด้วย!',
            romanization: 'chûai dûai!',
            vietnamese: 'Cứu với!',
          ),
          GuideEntry(
            target: 'เรียกตำรวจให้หน่อย',
            romanization: 'rîak tam-rùat hâi nòi',
            vietnamese: 'Làm ơn gọi cảnh sát.',
          ),
          GuideEntry(
            target: 'เรียกรถพยาบาลด้วย',
            romanization: 'rîak rót phá-yaa-baan dûai',
            vietnamese: 'Làm ơn gọi xe cấp cứu.',
          ),
          GuideEntry(
            target: 'โรงพยาบาลอยู่ที่ไหน',
            romanization: 'roong phá-yaa-baan yùu thîi nǎi',
            vietnamese: 'Bệnh viện ở đâu?',
          ),
        ],
      ),
      GuideCard(
        title: 'Mất đồ, lạc đường',
        emoji: '🧳',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'ทำพาสปอร์ตหาย',
            romanization: 'tham pháat-sà-pòot hǎai',
            vietnamese: 'Tôi làm mất hộ chiếu.',
          ),
          GuideEntry(
            target: 'ผม/ดิฉันหลงทาง',
            romanization: 'phǒm / dì-chǎn lǒng thaang',
            vietnamese: 'Tôi bị lạc đường.',
          ),
          GuideEntry(
            target: 'ช่วยหน่อยได้ไหม',
            romanization: 'chûai nòi dâai mǎi',
            vietnamese: 'Bạn giúp tôi được không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Sức khoẻ & đồ ăn',
        emoji: '💊',
        body: 'Đồ ăn Thái cay hơn mong đợi — nhớ câu "ไม่เผ็ด" trước khi gọi món.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'ไม่สบาย',
            romanization: 'mâi sà-baai',
            vietnamese: 'Tôi thấy không khoẻ.',
          ),
          GuideEntry(
            target: 'ไม่เผ็ด',
            romanization: 'mâi phèt',
            vietnamese: 'Không cay.',
          ),
          GuideEntry(
            target: 'ร้านขายยาอยู่ที่ไหน',
            romanization: 'ráan khǎai yaa yùu thîi nǎi',
            vietnamese: 'Hiệu thuốc ở đâu?',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'numbers',
    title: 'Số đếm & đơn vị',
    subtitle: 'Nghe giá ở chợ và trên taxi',
    icon: Icons.tag_rounded,
    color: _cNumbers,
    cards: <GuideCard>[
      GuideCard(
        title: 'Từ 1 đến 10',
        emoji: '🔢',
        entries: <GuideEntry>[
          GuideEntry(target: 'หนึ่ง', romanization: 'nùeng', vietnamese: '1'),
          GuideEntry(target: 'สอง', romanization: 'sǒong', vietnamese: '2'),
          GuideEntry(target: 'สาม', romanization: 'sǎam', vietnamese: '3'),
          GuideEntry(target: 'สี่', romanization: 'sìi', vietnamese: '4'),
          GuideEntry(target: 'ห้า', romanization: 'hâa', vietnamese: '5'),
          GuideEntry(target: 'หก', romanization: 'hòk', vietnamese: '6'),
          GuideEntry(target: 'เจ็ด', romanization: 'jèt', vietnamese: '7'),
          GuideEntry(target: 'แปด', romanization: 'pàet', vietnamese: '8'),
          GuideEntry(target: 'เก้า', romanization: 'kâo', vietnamese: '9'),
          GuideEntry(target: 'สิบ', romanization: 'sìp', vietnamese: '10'),
        ],
      ),
      GuideCard(
        title: 'Chục, trăm, nghìn',
        emoji: '💯',
        body: 'Số 11 là สิบเอ็ด (sìp-èt), 21 là ยี่สิบเอ็ด — số 1 đứng cuối đọc '
            'là "èt" chứ không phải "nùeng".',
        entries: <GuideEntry>[
          GuideEntry(target: 'ยี่สิบ', romanization: 'yîi-sìp', vietnamese: '20'),
          GuideEntry(target: 'ร้อย', romanization: 'rói', vietnamese: '100'),
          GuideEntry(target: 'พัน', romanization: 'phan', vietnamese: '1.000'),
          GuideEntry(target: 'บาท', romanization: 'bàat', vietnamese: 'baht (đơn vị tiền)'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'money',
    title: 'Tiền bạc & mặc cả',
    subtitle: 'Kỹ năng sống ở chợ Thái',
    icon: Icons.payments_rounded,
    color: _cMoney,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi giá & thanh toán',
        emoji: '💳',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'เท่าไหร่',
            romanization: 'thâo-rài',
            vietnamese: 'Bao nhiêu tiền?',
          ),
          GuideEntry(
            target: 'รับบัตรไหม',
            romanization: 'ráp bàt mǎi',
            vietnamese: 'Có nhận thẻ không?',
          ),
          GuideEntry(
            target: 'จ่ายเงินสด',
            romanization: 'jàai ngoen sòt',
            vietnamese: 'Tôi trả tiền mặt.',
          ),
          GuideEntry(
            target: 'ขอใบเสร็จ',
            romanization: 'khǒo bai-sèt',
            vietnamese: 'Cho tôi hoá đơn.',
          ),
        ],
      ),
      GuideCard(
        title: 'Mặc cả',
        emoji: '🏷️',
        body: 'Chợ đêm và hàng lưu niệm mặc cả được, thường trả khoảng 60–70% '
            'giá hô. Cửa hàng trong trung tâm thương mại thì giá cố định. '
            'Luôn cười khi mặc cả — thái độ quan trọng hơn con số.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'แพงไป',
            romanization: 'phaeng pai',
            vietnamese: 'Đắt quá.',
          ),
          GuideEntry(
            target: 'ลดหน่อยได้ไหม',
            romanization: 'lót nòi dâai mǎi',
            vietnamese: 'Giảm chút được không?',
          ),
          GuideEntry(
            target: 'เอาอันนี้',
            romanization: 'ao an níi',
            vietnamese: 'Tôi lấy cái này.',
          ),
        ],
      ),
      GuideCard(
        title: 'Taxi & tuk-tuk',
        emoji: '🛺',
        body: 'Luôn hỏi bật đồng hồ trước khi lên taxi; tuk-tuk thì phải chốt '
            'giá trước vì không có đồng hồ.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'เปิดมิเตอร์ด้วย',
            romanization: 'pòet mí-tôe dûai',
            vietnamese: 'Làm ơn bật đồng hồ.',
          ),
          GuideEntry(
            target: 'ไปที่นี่',
            romanization: 'pai thîi nîi',
            vietnamese: 'Cho tôi tới chỗ này.',
          ),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'directions',
    title: 'Thời gian & phương hướng',
    subtitle: 'Hỏi đường, hỏi giờ',
    icon: Icons.explore_rounded,
    color: _cDirection,
    cards: <GuideCard>[
      GuideCard(
        title: 'Hỏi đường',
        emoji: '🧭',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'สถานีอยู่ที่ไหน',
            romanization: 'sà-thǎa-nii yùu thîi nǎi',
            vietnamese: 'Nhà ga ở đâu?',
          ),
          GuideEntry(target: 'เลี้ยวซ้าย', romanization: 'líao sáai', vietnamese: 'rẽ trái'),
          GuideEntry(target: 'เลี้ยวขวา', romanization: 'líao khwǎa', vietnamese: 'rẽ phải'),
          GuideEntry(target: 'ตรงไป', romanization: 'trong pai', vietnamese: 'đi thẳng'),
          GuideEntry(
            target: 'ไกลไหม',
            romanization: 'klai mǎi',
            vietnamese: 'Có xa không?',
          ),
        ],
      ),
      GuideCard(
        title: 'Giờ giấc',
        emoji: '🕒',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'กี่โมงแล้ว',
            romanization: 'kìi moong láew',
            vietnamese: 'Mấy giờ rồi?',
          ),
          GuideEntry(target: 'วันนี้', romanization: 'wan-níi', vietnamese: 'hôm nay'),
          GuideEntry(target: 'พรุ่งนี้', romanization: 'phrûng-níi', vietnamese: 'ngày mai'),
          GuideEntry(target: 'เช้า', romanization: 'cháo', vietnamese: 'buổi sáng'),
          GuideEntry(target: 'เย็น', romanization: 'yen', vietnamese: 'buổi chiều tối'),
        ],
      ),
    ],
  ),
  GuideTopic(
    id: 'etiquette',
    title: 'Lịch sự & văn hoá',
    subtitle: 'ครับ / ค่ะ và chuyện chắp tay',
    icon: Icons.emoji_people_rounded,
    color: _cEtiquette,
    cards: <GuideCard>[
      GuideCard(
        title: 'Trợ từ lịch sự',
        emoji: '🙏',
        body: 'Nam thêm ครับ (khráp) ở cuối câu, nữ thêm ค่ะ (khâ). Thiếu trợ từ '
            'này câu nghe cộc lốc, thêm vào là lịch sự ngay.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'สวัสดีครับ / ค่ะ',
            romanization: 'sà-wàt-dii khráp / khâ',
            vietnamese: 'Xin chào.',
          ),
          GuideEntry(
            target: 'ขอบคุณครับ / ค่ะ',
            romanization: 'khòop-khun khráp / khâ',
            vietnamese: 'Cảm ơn.',
          ),
          GuideEntry(
            target: 'ขอโทษครับ / ค่ะ',
            romanization: 'khǒo-thôot khráp / khâ',
            vietnamese: 'Xin lỗi.',
          ),
          GuideEntry(
            target: 'ไม่เป็นไร',
            romanization: 'mâi pen rai',
            vietnamese: 'Không sao đâu.',
          ),
        ],
      ),
      GuideCard(
        title: 'Khi chưa nghe kịp',
        emoji: '👂',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'พูดอีกครั้งได้ไหม',
            romanization: 'phûut ìik khráng dâai mǎi',
            vietnamese: 'Nói lại lần nữa được không?',
          ),
          GuideEntry(
            target: 'พูดช้าๆ หน่อย',
            romanization: 'phûut cháa-cháa nòi',
            vietnamese: 'Nói chậm chậm giúp tôi.',
          ),
          GuideEntry(
            target: 'พูดไทยไม่เก่ง',
            romanization: 'phûut thai mâi kèng',
            vietnamese: 'Tôi nói tiếng Thái chưa giỏi.',
          ),
        ],
      ),
      GuideCard(
        title: 'Thói quen nên biết',
        emoji: '💡',
        body: 'Chắp tay chào (ไหว้ wâai) khi được người khác chào trước. '
            'Không chạm đầu người khác, không chĩa chân về phía người hoặc '
            'tượng Phật. Cởi giày khi vào chùa và nhà dân. Hoàng gia là chủ đề '
            'nên tránh bình luận.',
      ),
    ],
  ),
  GuideTopic(
    id: 'pronunciation',
    title: 'Thanh điệu & phát âm',
    subtitle: 'Năm thanh, nghe quen là nói được',
    icon: Icons.record_voice_over_rounded,
    color: _cPronounce,
    cards: <GuideCard>[
      GuideCard(
        title: 'Năm thanh điệu',
        emoji: '🎵',
        body: 'Tiếng Thái có 5 thanh: trung, thấp, xuống, cao, lên. Người Việt '
            'có lợi thế lớn vì tiếng Việt cũng có thanh — chỉ cần đổi hệ quy chiếu.',
        entries: <GuideEntry>[
          GuideEntry(
            target: 'ไม้ / ใหม่ / ไหม้',
            romanization: 'máai / mài / mâi',
            vietnamese: 'gỗ / mới / cháy — cùng âm, khác thanh',
          ),
          GuideEntry(
            target: 'เสือ / เสื้อ',
            romanization: 'sǔea / sûea',
            vietnamese: 'con hổ / cái áo',
          ),
        ],
      ),
      GuideCard(
        title: 'Âm cuối không bật',
        emoji: '🗣️',
        body: 'Phụ âm cuối trong tiếng Thái bị chặn lại giống tiếng Việt, nên '
            'người Việt phát âm gần đúng ngay từ đầu.',
        entries: <GuideEntry>[
          GuideEntry(target: 'ผัด', romanization: 'phàt', vietnamese: 'xào'),
          GuideEntry(target: 'ข้าว', romanization: 'khâao', vietnamese: 'cơm'),
          GuideEntry(target: 'น้ำ', romanization: 'náam', vietnamese: 'nước'),
        ],
      ),
    ],
  ),
];
