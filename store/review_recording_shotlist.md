# Screen recording for App Review — shot list

Apple asked for a recording made **on a physical device running the latest iOS**,
starting from app launch and covering the core flows. Simulator recordings get
rejected for this guideline.

Target length: **2–3 minutes**. Do not rush; the reviewer needs to read the
screen. Record in portrait, sound on.

## Before you press record

1. **Delete the app from the device first.** The recording must show a genuine
   first launch, including the language picker. If the app is already onboarded
   the picker never appears and the reviewer cannot see the entry point.
2. **Install a Thai and Korean voice** under Settings → Accessibility → Spoken
   Content → Voices, or plan to demonstrate pronunciation in English only. A
   silent speaker button on camera looks like a bug even though it is not.
3. **Turn the ringer on and volume up** so the text-to-speech is audible in the
   file.
4. Turn on Do Not Disturb so no notification banner covers the screen.
5. Start recording from Control Centre, then go to the Home Screen and tap the
   app icon — the recording must open with the launch, not with the app already
   running.

## Shot list

| # | Screen | What to do | Why it matters |
|---|---|---|---|
| 1 | Home Screen | Tap the app icon, wait through the splash | Apple requires the recording to begin with launch |
| 2 | Onboarding | Pick a language, **choose English** | Shows the entry point; English guarantees an audible voice |
| 3 | Hành trình | Scroll the whole tab slowly | Shows daily goal, streak, and the four stages |
| 4 | Hành trình | **Tap the locked "Khách sạn" stage** and let the message show | Proves the lock is intentional and explained, not a dead button |
| 5 | Sân bay | Open it, scroll the phrase list, **tap a speaker icon** twice | Core value; audible proof the TTS works |
| 6 | Sân bay | Open a dialogue, play a line | Shows situational content |
| 7 | Sân bay | Open Flashcard, flip 3–4 cards, rate each | Shows the spaced-repetition loop, the heart of the app |
| 8 | Sổ tay | Type a search term, then tap a filter chip, then star a phrase | Shows search, filter and favourites |
| 9 | Sổ tay | Tap a phrase to open the detail sheet | Shows culture notes and review status |
| 10 | Luyện tập | Play one full round of **Nối cặp** to the result screen | Shows a complete game with its scoring |
| 11 | Luyện tập | Start **Nghe đoán**, answer 2 questions with sound on | Shows the audio game working on device |
| 12 | Cẩm nang | Open "Khẩn cấp & an toàn", scroll it | Shows the reference content |
| 13 | Tiến độ | Scroll the whole tab | Shows badges, activity map, per-stage stats |
| 14 | Tiến độ | Open "Mục tiêu mỗi ngày" and change it | Shows settings are functional |
| 15 | Control Centre | **Turn on Airplane Mode, return to the app, tap a speaker icon and open a stage** | Proves the app is genuinely offline — this directly answers question 5 about external services |

Shot 15 is worth the extra 15 seconds. It converts the claim "no network
requests" into something the reviewer watched happen.

## What NOT to record

There is nothing to show for these, and the reply says so explicitly:

- Account registration, login, deletion — the app has none
- Purchase or subscription flows — the app has none
- User-generated content, reporting, blocking — the app has none
- Permission prompts, App Tracking Transparency — the app requests nothing

## After recording

- Trim the start and end so the file opens on the Home Screen tap.
- Export as `.mp4` or `.mov`. Keep it under 500 MB.
- Attach it in App Store Connect → Resolution Center, in the same reply that
  contains `app_review_reply.txt`.
- Also paste `app_review_notes.txt` into App Store Connect → your version →
  **App Review Information → Notes**, so future submissions carry it
  automatically. This is what Apple asked for in their closing line, and
  skipping it invites the same rejection next time.

## Also worth fixing before you resubmit

Apple's "How to Prevent Common Issues" section flags screenshots under
Guideline 2.3.3. Store screenshots must show the app **in use**, not the splash
or onboarding screen. Use the five tab screens from shots 3, 8, 10, 12 and 13.
