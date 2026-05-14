# Agent Prompt — Ibrahim Elnahal Portfolio
> انسخ الـ prompt ده وحطه في أي coding agent (Cursor, Claude Code, Windsurf, etc.)
> وارفق معاه الملفين: `ibrahim_portfolio_design_system.md` + الـ CV

---

## الـ Prompt

```
You are a senior Flutter Web developer and UI engineer.
Your task is to build a complete, production-ready personal portfolio website
for Ibrahim Elnahal using Flutter Web.

---

## SOURCE FILES (read these first before writing any code)

1. `ibrahim_portfolio_design_system.md` — The complete design system.
   Every color, font, spacing, animation, and component spec is defined here.
   You MUST follow it exactly. Do not invent new styles.

2. `Ibrahim_Ahmed_ELnahal_CV_New.md` — Ibrahim's real data.
   All text content (name, skills, projects, contact info) must come from this file.
   Do not use placeholder text.

---

## TECH STACK

- Flutter Web (latest stable)
- Dart
- No third-party UI packages — build everything from scratch using Flutter widgets
- Lottie package is allowed for animations only
- google_fonts package for: Syne, DM Mono, Inter

---

## WHAT TO BUILD

Build a single-page Flutter Web portfolio with these sections in order:

### 1. NavBar (fixed, top)
- Logo: "IE/" — Syne font, accent green color
- Links: Skills | Projects | About | Contact
- On scroll: semi-transparent background + blur effect
- Smooth scroll to sections on tap

### 2. Hero Section (full viewport height)
- Left column:
  - Status badge: green pulsing dot + "Available for work" text — pill shape
  - Name in 3 lines: Ibrahim / Elnahal / Developer
  - "Developer" line: ghost text style (transparent fill, white outline stroke)
  - Short description paragraph
  - Two buttons: "View Projects →" (primary green) + "Get in touch" (outline)
- Right column (420px wide):
  - Code card styled like a code editor window
  - Three dots header (red, yellow, green) + filename "main.dart"
  - Real Dart code showing Ibrahim as a class with his actual stack
  - Syntax highlighting: keywords purple, strings green, classes cyan, numbers orange

### 3. Skills Section
- Eyebrow label + h2 title + subtitle
- 2×2 responsive grid of skill cards
- Each card: icon box + skill name + description + tags row
- Hover: lift up 2px + subtle bottom glow line
- 4 skills: Flutter & Dart | State Management | ASP.NET Backend | Clean Architecture

### 4. Projects Section
- Eyebrow label + h2 title + subtitle
- Vertical list of project cards (NOT grid)
- Each card: badge + name + description + tech chips + arrow icon
- Card hover: slide right 4px (translateX not translateY)
- OCL project: green "Live & Deployed" badge, featured styling
- Second project: orange "In Progress" badge

### 5. About Section
- Two columns: text left, stats right
- Left: 3 short paragraphs about Ibrahim (from CV data)
- Right: 2×2 stats grid — "1+ Year" / "2 Projects" / "Full Stack" / "B1 English"
- Stats use Syne font, large number in accent green

### 6. Contact Section
- Single centered box
- Title: "Let's work together"
- Subtitle
- Row of contact links: email + phone + location
- Each link: monospace font, border, hover turns green

### 7. Footer
- Centered, small monospace text
- Copyright line only

---

## ANIMATIONS (required)

- Hero pulsing dot: opacity 1 → 0.3 → 1, infinite, 2s
- Scroll reveal: every section fades in + slides up 24px when entering viewport
  - opacity: 0 → 1
  - translateY: 24px → 0
  - duration: 600ms
  - stagger child elements with 50-100ms delay between each
- Hover transitions: 200ms ease on all interactive elements
- Nav background: animate in on first scroll

---

## BACKGROUND

- Dark grid pattern: subtle white lines at 64px intervals, fades at bottom
- Two large blurred glow blobs (fixed position):
  - Blob 1: green (#4ade80), top-left, opacity 0.12
  - Blob 2: purple (#a78bfa), bottom-right, opacity 0.12

---

## STRICT RULES — DO NOT VIOLATE

1. Colors: use ONLY the palette from the design system. No new colors.
2. Fonts: Syne for headings, DM Mono for code/labels/tags, Inter for body text.
3. No gradient text anywhere.
4. No glassmorphism except the nav bar.
5. The "Developer" word in h1 must use outline stroke style, not a gradient.
6. The code in the Hero card must be real Dart syntax, not pseudocode.
7. All text content must come from the CV file — no made-up content.
8. Cards hover: translateY(-2px) for skill cards, translateX(4px) for project cards.
9. Border radius: cards = 12-14px, buttons = 8px, contact box = 20px, tags = 4-6px.
10. Dividers between sections: 1px line, color #2a2a2f, full max-width.
11. English language for all UI text.
12. Make it fully responsive for mobile and desktop.

---

## FILE STRUCTURE

```
lib/
├── main.dart
├── app.dart
├── theme/
│   ├── colors.dart        # all color constants
│   └── text_styles.dart   # all text style constants
├── widgets/
│   ├── nav_bar.dart
│   ├── hero_section.dart
│   ├── skills_section.dart
│   ├── projects_section.dart
│   ├── about_section.dart
│   ├── contact_section.dart
│   └── footer.dart
├── components/
│   ├── skill_card.dart
│   ├── project_card.dart
│   ├── stat_item.dart
│   ├── code_card.dart
│   ├── hero_badge.dart
│   ├── section_header.dart
│   ├── primary_button.dart
│   └── outline_button.dart
└── utils/
    └── scroll_reveal.dart  # scroll animation helper
```

---

## COLORS REFERENCE (copy these as Dart constants)

```dart
// theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const bg       = Color(0xFF09090B);
  static const bg2      = Color(0xFF111113);
  static const bg3      = Color(0xFF18181B);
  static const surface  = Color(0xFF1C1C1F);
  static const border   = Color(0xFF2A2A2F);
  static const accent   = Color(0xFF4ADE80);
  static const accent2  = Color(0xFF22D3EE);
  static const accent3  = Color(0xFFA78BFA);
  static const text     = Color(0xFFF4F4F5);
  static const muted    = Color(0xFF71717A);
  static const muted2   = Color(0xFF52525B);

  // Code syntax
  static const codeKeyword = Color(0xFFC084FC);
  static const codeString  = Color(0xFF4ADE80);
  static const codeClass   = Color(0xFF67E8F9);
  static const codeNumber  = Color(0xFFFB923C);
  static const codeComment = Color(0xFF52525B);
}
```

---

## START HERE

1. Read both source files completely.
2. Create the Flutter project structure above.
3. Define all colors and text styles first.
4. Build each section as a separate widget.
5. Assemble in a SingleChildScrollView in app.dart.
6. Test on Chrome (flutter run -d chrome).

Do not ask for clarification — all decisions are defined in the design system file.
Build it completely and correctly the first time.
```

---

## كيفية الاستخدام

### في Cursor أو Windsurf:
1. افتح مشروع Flutter جديد
2. حط الملفين (`design_system.md` + CV) في root folder المشروع
3. افتح الـ AI chat
4. انسخ الـ prompt ده كاملاً والصقه
5. اضغط Enter

### في Claude Code:
```bash
# في terminal
claude "$(cat ibrahim_portfolio_agent_prompt.md)"
```

### في أي agent تاني:
- ارفع الملفين كـ context
- انسخ الـ prompt من الـ code block فوق

---

## الملفات المطلوبة مع الـ Prompt

| الملف | الهدف |
|-------|-------|
| `ibrahim_portfolio_design_system.md` | كل الـ design decisions |
| `Ibrahim_Ahmed_ELnahal_CV_New.md` | البيانات الحقيقية |
| `ibrahim_portfolio_agent_prompt.md` | هذا الملف — التعليمات |

---

*الـ prompt ده مكتوب عشان الـ agent يبني الـ portfolio بدون أي سؤال أو افتراض.*
*كل قرار موثق — الـ agent بس بينفذ.*
