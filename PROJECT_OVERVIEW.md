# Ibrahim Elnahal - Developer Portfolio

A cinematic, highly-polished web portfolio built with Flutter Web. This project serves as a premium showcase of skills, projects, and professional background, engineered with a "Dark IDE" aesthetic and advanced frontend physics.

## 🚀 Project Vision

The portfolio is designed to mimic the environment of an elite frontend/full-stack developer. It avoids standard Material Design defaults and generic templates, opting instead for:
- **Minimalist Dark Mode**: A sleek, dark workspace-inspired interface.
- **Advanced Motion Physics**: Subtle floating ambient motion, mouse-reactive depth, and staggering scroll reveals.
- **Cinematic Atmosphere**: Moving radial lighting, a breathing background grid, and noise textures.
- **Technical Authenticity**: Code cards mimicking real IDE environments and content directly reflecting the developer's actual CV.

---

## 🛠️ Tech Stack

- **Framework**: Flutter (optimized for Web)
- **Language**: Dart
- **Design Pattern**: Feature-First / Modular Architecture
- **State & Animation**: `StatefulWidget`, `AnimationController`, `Tween`, `AnimatedBuilder` (No heavy external animation packages used to ensure maximum performance).

---

## 📁 Folder Structure

The project follows a clean, feature-first modular architecture to ensure scalability and maintainability:

```text
lib/
├── app.dart                   # Main application shell and scroll view configuration
├── main.dart                  # Entry point
│
├── core/                      # Application-wide configurations and utilities
│   ├── animations/            # Global animation controllers (e.g., RevealAnimation)
│   ├── theme/                 # Design system (Colors, Spacing, Typography, Effects)
│   └── utils/                 # Helpers (Responsive design, Section Keys for scrolling)
│
├── data/                      # Static content and models
│   ├── models/                # Data models (ProjectModel, SkillModel)
│   └── portfolio_data.dart    # Hardcoded CV and portfolio data source
│
├── features/                  # Independent, scrollable sections of the app
│   ├── about/                 # Biography and statistics grid
│   ├── contact/               # Contact information and links
│   ├── footer/                # Bottom footer
│   ├── hero/                  # Main landing sequence and cinematic code card
│   ├── navbar/                # Floating top navigation
│   ├── projects/              # Featured projects list
│   └── skills/                # Grid of technical skills and expertise
│
└── shared/                    # Reusable components and visual effects
    ├── effects/               # Shaders and background visuals (GlowBlob, GridBackground)
    └── widgets/               # Reusable UI elements (Badges, Buttons, Cards, Chips, Layout)
```

---

## 🎨 Design System & Visuals

Located in `lib/core/theme/`:
- **AppColors**: Tailored HSL colors, avoiding basic reds/blues. Utilizes rich dark grays for surfaces and vibrant, luminous accents (neon greens/blues).
- **AppTextStyles**: Custom typography system moving away from Material defaults. Utilizes modern Google Fonts (Syne, DM Sans, JetBrains Mono) for a premium tech feel.
- **AppEffects**: Defines global animation curves (`Curves.easeOutCubic`) and hover durations (200ms) to ensure consistency across all interactions.
- **AppSpacing & AppRadius**: Centralized tokens for padding, margins, and border radii.

---

## ✨ Cinematic Motion System

The portfolio heavily relies on a custom-built animation ecosystem:

### 1. Scroll Reveal Diversity (`RevealAnimation`)
Instead of a single repetitive animation, different sections reveal themselves uniquely as the user scrolls:
- **Hero & Skills**: `RevealType.up` (Fast, staggered vertical slide-in).
- **Projects**: `RevealType.left` (Horizontal slide-in from the left).
- **About**: `RevealType.fade` (Soft opacity transition).
- **Contact**: `RevealType.slowUp` (Extended vertical reveal for finality).

### 2. Ambient Floating Motion
Idle elements continuously exhibit subtle motion without impacting performance:
- **Glow Blobs**: Slow, 8-second vertical drifting (±4px offset).
- **Hero Badge**: Infinite, smooth 2px vertical float.
- **Featured Project Cards**: Gentle 3px vertical floating to draw attention to key work.

### 3. Mouse-Reactive Depth & Hover Physics
- **Code Card**: Reads cursor coordinates to apply 3D `rotateX` and `rotateY` parallax effects.
- **Project & Skill Cards**: Utilize `Matrix4` transformations on hover to simulate elevation (`translateY(-4px)`), paired with dynamic border glow and shadow interpolation.
- **Background Grid**: A custom `CustomPaint` grid combined with a `ShaderMask` that infinitely pulses/breathes in opacity, simulating an active workspace.

---

## 📄 Real CV Integration

All information presented in the UI accurately mirrors the real-world experience:
- **About Section**: Accurately reflects studies in Information Systems at ASA Institute, freelance Flutter development, ASP.NET integration, and GetX/Provider state management.
- **Stats**: Honest, impactful metrics (`1+ Years Experience`, `100% ASP.NET Integration`).
- **Code Card**: The hero IDE card runs simulated Dart code specifically defining the `Flutter Developer` role and the `['Flutter', 'Dart', 'ASP.NET', 'SQL Server']` tech stack.

---

## ⚡ Performance Considerations

- **No Heavy Shaders**: Complex visuals like the noise texture and scan-lines are simulated using lightweight gradients and opacity layers.
- **Repaint Boundaries**: Static background elements (like `GridBackground` and static `GlowBlob`s) are separated from scrollable content in the root `Stack` to prevent unnecessary repaints during scrolling.
- **Optimized Assets**: Avoidance of large particle packages in favor of pure Dart `Tween` animations.
