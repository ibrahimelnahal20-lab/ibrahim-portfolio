# Ibrahim Elnahal — Portfolio Design Specification
> ملف المواصفات الكامل للبورتفوليو — استخدمه مع أي AI Agent عشان يبني نفس التصميم

---

## 1. Design Philosophy (فلسفة التصميم)

الـ aesthetic المختار: **Dark Terminal / Developer**
- الفكرة: البورتفوليو نفسه بيثبت إنك developer محترف — كل لون وفونت وتأثير بيقول ده
- مش generic، مش purple gradients على أبيض (ده أكتر حاجة بتبقى AI slop)
- الـ vibe: مطور بيفتح IDE في الليل، professional بس مش corporate

---

## 2. Color Palette (الألوان)

```css
:root {
  --bg:      #09090b;   /* الخلفية الأساسية — أسود مائل للرمادي */
  --bg2:     #111113;   /* خلفية ثانية */
  --bg3:     #18181b;   /* خلفية تالتة */
  --surface: #1c1c1f;   /* خلفية الكروت والعناصر */
  --border:  #2a2a2f;   /* لون الحدود */

  /* Accent Colors — الألوان المميزة */
  --accent:  #4ade80;   /* أخضر — اللون الرئيسي، يُستخدم للعناصر المهمة */
  --accent2: #22d3ee;   /* سيان — ثانوي */
  --accent3: #a78bfa;   /* بنفسجي فاتح — للتفاصيل */

  /* Typography Colors */
  --text:    #f4f4f5;   /* النص الأساسي */
  --muted:   #71717a;   /* نص ثانوي / وصف */
  --muted2:  #52525b;   /* نص خافت جداً */
}
```

**قواعد استخدام الألوان:**
- `--accent` (الأخضر): للعناصر الـ active، الـ badges المهمة، hover states، الأرقام المميزة
- `--accent3` (البنفسجي): للـ hover effects على الكروت، تفاصيل خفيفة
- `--muted`: لكل النصوص الوصفية والثانوية
- **ممنوع** استخدام أبيض خالص `#ffffff` أو أسود خالص `#000000`
- كل نص على خلفية ملونة يكون من نفس الـ color family بس أغمق

---

## 3. Typography (الخطوط)

### الخطوط المستخدمة (Google Fonts)
```html
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Mono:wght@300;400;500&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
```

| الخط | الاستخدام | الوزن |
|------|-----------|-------|
| **Syne** | عناوين رئيسية (h1, h2, h3)، اسم الشخص | 700–800 |
| **DM Mono** | كود، eyebrows، badges، nav links، footer | 400–500 |
| **Inter** | النص العادي، الوصف، الجسم | 300–500 |

### مقاسات العناوين
```css
h1 { font-size: clamp(2.8rem, 5vw, 4.5rem); font-weight: 800; letter-spacing: -0.03em; line-height: 1.0; }
h2 { font-size: clamp(1.8rem, 3vw, 2.6rem); font-weight: 700; letter-spacing: -0.025em; }
body { font-size: 15px; line-height: 1.6; }
.small { font-size: 0.83rem; }
.mono-small { font-family: 'DM Mono'; font-size: 0.72rem; letter-spacing: 0.05–0.12em; }
```

**قواعد Typography:**
- `letter-spacing: -0.02em` إلى `-0.03em` على العناوين الكبيرة (بيخليها تبدو احترافية)
- النص الوصفي `line-height: 1.7–1.8` عشان يكون مريح للقراءة
- الـ eyebrows (النص الصغير فوق العنوان): DM Mono + uppercase + letter-spacing كبير + لون الـ accent

---

## 4. Layout & Spacing (التخطيط والمسافات)

### الـ Container
```css
max-width: 1100px;
margin: 0 auto;
padding: 0 2.5rem;
```

### الـ Sections
```css
/* كل section بيأخد */
padding: 5rem 2.5rem; /* top/bottom 5rem */
```

### الـ Grid الرئيسي (Hero)
```css
display: grid;
grid-template-columns: 1fr 420px; /* نص على اليسار، كارت على اليمين */
gap: 4rem;
align-items: center;
```

### الـ Grid للكروت (Skills)
```css
display: grid;
grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
gap: 1.25rem;
```

---

## 5. Navigation (شريط التنقل)

```
التصميم:
- Fixed في الأعلى (position: fixed)
- خلفية: rgba(9,9,11,0.8) مع backdrop-filter: blur(20px)
- حدود سفلية: 1px solid var(--border)
- اليسار: الـ logo "IE/" بالأخضر وخط Syne
- اليمين: Links بـ DM Mono uppercase صغير
- اللون الافتراضي للـ links: --muted
- عند hover: --text
```

---

## 6. Sections — تفاصيل كل قسم

---

### Section 1: Hero

**التقسيم:** Grid عمودين — نص (يسار) + كارت كود (يمين)

**الجانب الأيسر (النص):**
```
1. Hero Tag (badge صغير):
   - شكل: pill (border-radius: 100px)
   - لون: border أخضر شفاف + نص أخضر
   - يحتوي على: نقطة خضرا متحركة (animation: pulse) + نص "Available for work"
   - الخط: DM Mono صغير

2. الاسم (h1):
   - ٣ سطور: "Ibrahim" / "Elnahal" / "Developer"
   - كلمة "Developer" تكون outline فقط (transparent fill + border text)
   - CSS: color: transparent; -webkit-text-stroke: 1px rgba(244,244,245,0.25);

3. الوصف:
   - خط Inter، لون --muted
   - max-width: 500px

4. أزرار CTA:
   - زر أول (Primary): خلفية --accent، نص أسود، border-radius: 8px
   - زر تاني (Outline): border فقط، لون --muted، عند hover يبقى --text
```

**الجانب الأيمن (كارت الكود):**
```
- خلفية: --surface
- Border: 1px solid --border
- border-radius: 16px
- خط ملون في الأعلى (border-top): gradient من الأخضر للسيان للبنفسجي
- Header الكارت: نقط macOS (أحمر/أصفر/أخضر) + اسم الملف "main.dart"
- المحتوى: كود Dart حقيقي بتاع Ibrahim مع syntax highlighting:
  * keywords (class, final, extends): لون بنفسجي #c084fc
  * strings: لون أخضر #4ade80
  * classes/types: لون سيان #67e8f9
  * numbers: لون برتقالي #fb923c
  * comments: لون --muted2
```

---

### Section 2: Skills (Tech Stack)

**العنوان:**
```
- Eyebrow: "What I work with" — DM Mono + --accent
- Title: "Tech Stack" — Syne bold
- Subtitle: وصف قصير — --muted
```

**الكروت (4 كروت في grid):**
```
كل كارت يحتوي على:
1. Icon container: مربع 40x40 border-radius: 10px
   - اللون بيختلف حسب التخصص:
     * Flutter: خلفية خضرا شفافة (rgba(74,222,128,0.1))
     * State: خلفية بنفسجية
     * ASP.NET: خلفية سيان
     * Architecture: بنفسجية
2. اسم الـ skill: Syne bold
3. وصف: Inter --muted صغير
4. Tags: chips صغيرة بـ DM Mono
   - خلفية: rgba(255,255,255,0.05)
   - border: 1px solid --border
   - border-radius: 4px (مش مدور كتير)

Hover effect على الكارت:
- border-color تتغير لـ --muted2
- transform: translateY(-2px)
- خط ضوئي في الأسفل (pseudo-element) يظهر
```

**الكروت الأربعة:**
1. Flutter & Dart — tags: Flutter Web, Animations, Widgets, Responsive
2. State Management — tags: GetX, Provider, Reactive, MVVM
3. ASP.NET Backend — tags: ASP.NET, REST API, SQL Server, DB Design
4. Clean Architecture — tags: MVVM, Clean Code, Git, Figma

---

### Section 3: Projects

**العنوان:**
```
- Eyebrow: "What I've built"
- Title: "Projects"
```

**كروت المشاريع (layout مختلف — أفقي):**
```
كل كارت:
- display: grid; grid-template-columns: 1fr auto;
- الـ auto: سهم صغير في الركن (36x36 بـ border)
- عند hover: السهم يتلون بالأخضر + الكارت يتحرك يمين (translateX: 4px)

المشروع الأول (OCL):
- Badge: "✦ Live & Deployed" — أخضر
- border الكارت: أخضر شفاف (featured style)
- خلفية: rgba(74,222,128,0.04) — أخضر خفيف جداً

المشروع التاني:
- Badge: "⟳ In Progress" — برتقالي
- بدون featured style

داخل كل كارت:
1. Badge (pill صغير)
2. اسم المشروع: Syne bold كبير
3. وصف: Inter --muted
4. Tech chips: مشابهة لـ tags بس أكبر شوية
```

---

### Section 4: About

**Layout:** Grid عمودين — نص يسار + stats يمين

**النص:**
```
- ٣ paragraphs
- النص العادي: --muted
- الكلمات المهمة: <strong> بلون --text وزن 500
- font-size: 0.93rem
- line-height: 1.8
```

**Stats Grid (2x2):**
```
كل stat item:
- خلفية: --surface
- border: 1px solid --border
- border-radius: 10px
- الرقم: Syne font-size: 2rem font-weight: 800 لون --accent
- التسمية: 0.78rem --muted

الأرقام الأربعة:
1. "1+" — Year Experience
2. "2" — Web Projects
3. "Full" — Stack Coverage
4. "B1" — English Level
```

---

### Section 5: Contact

**Layout:** وسط الصفحة، كارت كبير

**الكارت:**
```
- background: --surface
- border: 1px solid --border
- border-radius: 20px
- padding: 3.5rem
- فيه glow خفي في الأعلى (radial-gradient أخضر شفاف جداً)

المحتوى:
1. عنوان: "Let's work together" — Syne bold
2. وصف: --muted
3. Links row (flex, وسط):
   - Email link
   - Phone link
   - Location link
   كل link: border + --muted، عند hover يبقى --accent
   الخط: DM Mono
```

---

## 7. Background Effects (تأثيرات الخلفية)

**Grid Pattern:**
```css
background-image:
  linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
  linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
background-size: 64px 64px;
/* مع mask عشان يظهر بس في الأعلى */
mask-image: radial-gradient(ellipse 80% 50% at 50% 0%, black, transparent);
```

**Glow Circles:**
```css
/* دايرتين ضبابيتين في الزوايا */
Glow 1: أخضر — top-left corner — opacity: 0.12
Glow 2: بنفسجي — bottom-right corner — opacity: 0.12
filter: blur(120px);
width: 600px; height: 400px; border-radius: 50%;
```

---

## 8. Animations & Motion (الحركة)

### Scroll Reveal (الظهور عند الـ scroll)
```javascript
/* كل عنصر بيبدأ invisible ويظهر لما يدخل في الـ viewport */
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.6s, transform 0.6s;
}
.reveal.visible {
  opacity: 1;
  transform: none;
}
/* IntersectionObserver بـ threshold: 0.12 */
```

### Staggered Delays (تأخير متدرج)
```
كل element بيأخد delay مختلف:
- العنصر الأول: 0s
- الكارت التاني: transition-delay: 0.05s
- الكارت التالت: transition-delay: 0.1s
- وهكذا بزيادة 0.05s
```

### Pulse Animation (النقطة المتحركة في الـ hero tag)
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.3; }
}
/* animation: pulse 2s infinite */
```

### Hover Rules
```
- كروت Skills: translateY(-2px) + border color change
- كروت Projects: translateX(4px) + arrow color change
- Buttons: translateY(-1px) على الـ primary
- كل transitions: 0.2s–0.25s ease
- لا bounce، لا elastic — ease-out فقط
```

---

## 9. Components Library (مكتبات المكونات)

### Badge / Pill
```css
display: inline-flex; align-items: center; gap: 6–8px;
font-family: 'DM Mono'; font-size: 0.68–0.75rem;
padding: 3–6px 10–14px; border-radius: 100px;
letter-spacing: 0.05em;

/* ألوان حسب النوع */
Green (live):  color: #4ade80; bg: rgba(74,222,128,0.1);  border: rgba(74,222,128,0.2)
Orange (wip):  color: #fb923c; bg: rgba(251,146,60,0.1);  border: rgba(251,146,60,0.2)
```

### Tag / Chip (داخل الكروت)
```css
font-family: 'DM Mono'; font-size: 0.68–0.7rem;
padding: 3–4px 10px; border-radius: 4–6px;
background: rgba(255,255,255,0.05) أو var(--bg3);
border: 1px solid var(--border);
color: var(--muted);
```

### Divider (الفاصل بين الـ sections)
```css
border: none;
border-top: 1px solid var(--border);
max-width: 1100px; margin: 0 auto;
```

### Buttons
```css
/* Primary */
background: var(--accent); color: #09090b;
font-weight: 600; font-size: 0.875rem;
padding: 11px 22px; border-radius: 8px;
transition: all 0.2s;
hover: background: #86efac; transform: translateY(-1px);

/* Outline */
border: 1px solid var(--border); color: var(--muted);
font-size: 0.875rem; font-weight: 500;
padding: 11px 22px; border-radius: 8px;
hover: border-color: --muted; color: --text;
```

---

## 10. Section Pattern (نمط تكرار كل section)

كل section بتبدأ بنفس الـ pattern:

```html
<section id="section-name">
  <div class="reveal">
    <!-- Eyebrow -->
    <div class="section-eyebrow">Short phrase in mono</div>
    <!-- Title -->
    <h2 class="section-title">Main Title</h2>
    <!-- Subtitle -->
    <p class="section-sub">Brief description in --muted color</p>
  </div>
  <!-- Content... -->
</section>
```

```css
.section-eyebrow {
  font-family: 'DM Mono';
  font-size: 0.72rem; color: var(--accent);
  letter-spacing: 0.12em; text-transform: uppercase;
  margin-bottom: 0.75rem;
}
.section-title {
  font-family: 'Syne';
  font-size: clamp(1.8rem, 3vw, 2.6rem);
  font-weight: 700; letter-spacing: -0.025em;
  margin-bottom: 1rem;
}
.section-sub { color: var(--muted); max-width: 520px; line-height: 1.7; }
```

---

## 11. Page Structure (ترتيب الصفحة)

```
┌─────────────────────────────────┐
│  NAV (fixed)                    │  ← IE/ logo + links
├─────────────────────────────────┤
│  HERO                           │  ← اسم + كود كارت
├─────────────────────────────────┤
│  ─── divider ───                │
├─────────────────────────────────┤
│  SKILLS                         │  ← 4 كروت في grid
├─────────────────────────────────┤
│  ─── divider ───                │
├─────────────────────────────────┤
│  PROJECTS                       │  ← كروت أفقية
├─────────────────────────────────┤
│  ─── divider ───                │
├─────────────────────────────────┤
│  ABOUT                          │  ← نص + stats
├─────────────────────────────────┤
│  ─── divider ───                │
├─────────────────────────────────┤
│  CONTACT                        │  ← كارت وسط
├─────────────────────────────────┤
│  FOOTER                         │  ← DM Mono صغير
└─────────────────────────────────┘
```

---

## 12. Rules & Anti-Patterns (القواعد والممنوعات)

### ✅ افعل
- استخدم الـ grid مش flexbox للـ layout الرئيسي
- خلي كل transition بين 0.2–0.6 ثانية
- استخدم `clamp()` للفونت sizes عشان يكون responsive
- حط `scroll-behavior: smooth` على الـ html
- ضيف `transition-delay` متدرج على الكروت المتشابهة
- استخدم `backdrop-filter: blur()` للـ nav

### ❌ ممنوع
- Purple gradient على أبيض (أكتر حاجة generic)
- `border-left` ملون كـ accent على الكروت
- `gradient text` (background-clip: text)
- Glass morphism كـ default style
- نفس الـ cards في grid بدون تنوع في الـ layout
- خطوط Inter أو Roboto أو Arial للعناوين
- Bounce أو elastic animations

---

## 13. Prompt للـ AI Agent

لما تستخدم agent، ابعتله الـ prompt ده مع الملف ده:

```
Build a portfolio website for Ibrahim Elnahal, a Flutter developer.
Follow this design spec exactly:

DESIGN: Dark terminal aesthetic. Colors from the spec file.
FONTS: Syne (headings), DM Mono (mono/badges), Inter (body) — Google Fonts
SECTIONS ORDER: Nav → Hero → Skills → Projects → About → Contact → Footer
ANIMATIONS: Scroll reveal with IntersectionObserver, staggered delays, pulse on hero badge
HERO: Two-column grid — text left, Dart code card right with syntax highlighting
SKILLS: 4 cards in auto-fit grid with icon, name, description, tags
PROJECTS: Horizontal cards with featured/wip badges, arrow icon
ABOUT: Two-column — text paragraphs + 2x2 stats grid
CONTACT: Centered card with glow effect
BACKGROUND: Subtle grid pattern + two blur glow circles (green top-left, purple bottom-right)

Use the exact CSS variables from the spec. Single HTML file with embedded CSS and JS.
```

---

*Ibrahim Elnahal Portfolio Design Spec — v1.0*
