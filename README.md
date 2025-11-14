# Carbon Quest: From Sunlight to Life

<div align="center">

**An Educational Game About Photosynthesis, Cellular Respiration, and the Carbon Cycle**

🌱 Built with Godot 4.5 | 🎮 Playable in Web Browsers | 🏫 Designed for Middle School Students

[Play Game](#) | [Documentation](docs/) | [Teacher Guide](#) | [Development](#development)

</div>

---

## 📖 Overview

**Carbon Quest** is a three-stage educational game that teaches students about matter and energy flow in ecosystems through interactive molecular manipulation and ecosystem simulation. Students progress from building glucose molecules (Stage 1: Photosynthesis) to breaking them down for energy (Stage 2: Cellular Respiration) to observing how these processes create a balanced carbon cycle (Stage 3: Ecosystem).

### Target Audience
- **Grade Level**: Middle school (6th-8th grade, ages 11-14)
- **Reading Level**: Designed for K-5 reading ability with visual-first learning
- **Platform**: Web browsers on Chromebooks and standard computers
- **Session Length**: 20-30 minutes for complete playthrough

### Educational Standards
Aligned with:
- **NGSS MS-LS1-6**: Construct a scientific explanation for the role of photosynthesis in cycling of matter and flow of energy
- **NGSS MS-LS1-7**: Develop a model to describe how food is rearranged through chemical reactions
- **NGSS MS-LS2-3**: Develop a model to describe the cycling of matter and flow of energy among living and nonliving parts of an ecosystem

---

## 🎮 Gameplay

### Stage 1: Photosynthesis Factory
Students drag molecules (CO₂, H₂O, and photons) into a chloroplast workspace. When they collect the correct amounts (6 CO₂ + 6 H₂O + 12 photons), a photosynthesis reaction occurs, producing glucose and releasing oxygen.

**Learning Goal**: Plants BUILD complex molecules from simple ingredients using light energy.

### Stage 2: Cellular Respiration Power Plant
Students drag glucose and oxygen molecules into a mitochondria workspace. When they collect 1 glucose + 6 O₂, the glucose breaks apart, releasing energy (ATP) and producing CO₂ and H₂O as waste products.

**Learning Goal**: Organisms BREAK DOWN complex molecules to release stored energy.

### Stage 3: Carbon Cycle Ecosystem
Students observe and manage a living ecosystem with plants (performing photosynthesis) and animals (performing cellular respiration). They must add or remove organisms to keep atmospheric CO₂ and O₂ levels balanced for 2 minutes.

**Learning Goal**: Photosynthesis and cellular respiration are complementary processes - the outputs of one become the inputs of the other.

---

## ✨ Key Features

### Educational Design
- ✅ **Progressive complexity**: Concrete → Abstract learning progression
- ✅ **Visual-first approach**: Color-coded molecules, minimal text
- ✅ **Immediate feedback**: See reactions happen in real-time
- ✅ **"Show, don't tell" philosophy**: Discovery through interaction

### Accessibility
- ✅ **Colorblind mode**: Pattern encoding (stripes, checkerboard) in addition to colors
- ✅ **Simple language**: Tutorial text at 5th grade reading level or below
- ✅ **Keyboard + mouse**: Multiple input methods supported
- ✅ **Low-spec friendly**: Runs on Intel Celeron N4020 Chromebooks

### Game Mechanics
- ✅ **Drag-and-drop molecules**: Intuitive touch/mouse controls
- ✅ **Chemical reaction animations**: Visual feedback when formulas complete
- ✅ **Atmospheric balance system**: Real-time gas tracking with recovery mechanics
- ✅ **Save system**: Progress persists across sessions via localStorage
- ✅ **Tutorial overlays**: Guided first-time experience for each stage

### Polish
- ✅ **Sound effects**: Audio feedback for pickups, reactions, achievements
- ✅ **Particle effects**: Green sparkles (photosynthesis), orange bursts (respiration)
- ✅ **Stage transitions**: Smooth fades with completion statistics
- ✅ **Pause menu**: Volume controls, restart, settings

---

## 🏫 For Teachers

### Classroom Integration

**Recommended Lesson Structure (45 minutes)**:
1. **Introduction** (5 min): "What do plants need to grow? What do you breathe?"
2. **Gameplay** (25 min): Students play individually or in pairs
3. **Discussion** (10 min): Whole-class discussion using provided prompts
4. **Exit Ticket** (5 min): Draw/label carbon cycle or write reflection

### Assessment Opportunities

**During Gameplay**:
- Are students collecting correct molecules?
- Do they understand when reactions occur?
- Can they balance the ecosystem strategically?

**Post-Game Discussion Prompts**:
1. "What did plants need to make glucose? Where did those things come from?"
2. "What happened to the glucose in Stage 2? What was released?"
3. "Why do you think plants and animals need each other to survive?"
4. "What would happen if all the plants disappeared from the ecosystem?"

**Observable Learning Indicators**:
- Students correctly predict what happens when they add more plants/animals
- Students verbally explain why O₂ goes up when plants are added
- Students recognize the circular flow of carbon

### Differentiation
- **Lower reading ability**: Visual tutorials with arrows and icons
- **Advanced learners**: "Realistic Mode" challenge (100:1 plant:animal ratio teaching energy pyramids) - *coming in future update*
- **Kinesthetic learners**: Act out the cycle with classmates (pass carbon ball)

---

## 🛠️ Technology Stack

- **Engine**: [Godot 4.5](https://godotengine.org/)
- **Language**: GDScript with type hints
- **Platform**: HTML5 (Web export)
- **Save System**: Browser localStorage via JavaScriptBridge
- **Audio Format**: OGG Vorbis (96 kbps)
- **Target Performance**: 60 FPS desktop, 30+ FPS Chromebook

---

## 📁 Project Structure

```
CarbonQuest/
├── scenes/
│   ├── main/              # Main menu and entry point
│   ├── stages/            # Stage 1, 2, 3 scenes
│   ├── molecules/         # Draggable molecule scenes
│   ├── organisms/         # Plant and animal scenes
│   ├── ui/                # HUD, menus, overlays
│   └── effects/           # Particles, animations
├── scripts/
│   ├── autoload/          # GameManager, GameConstants, SaveSystem
│   ├── stages/            # Stage controllers
│   ├── molecules/         # Molecule behavior
│   ├── organisms/         # Plant/animal behavior
│   ├── systems/           # Reaction, atmosphere, balance systems
│   └── ui/                # UI controllers
├── assets/
│   ├── sprites/           # Molecule, organism, environment sprites
│   ├── audio/             # Sound effects and music
│   └── fonts/             # Text fonts
├── data/
│   └── equations.json     # Chemical reaction formulas
└── docs/
	├── GDD_v1.1.md        # Game Design Document
	├── IMPLEMENTATION_PLAN.md
	├── TASKS_PHASE1.md    # Task lists for development
	└── CHANGELOG.md
```

---

## 🚀 Development

### Prerequisites

- [Godot 4.5+](https://godotengine.org/download)
- Git (for version control)
- Modern web browser (Chrome, Firefox, Edge) for testing

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/carbon-quest.git
   cd carbon-quest
   ```

2. **Open in Godot**:
   - Launch Godot 4.5
   - Click "Import"
   - Navigate to project folder
   - Select `project.godot`
   - Click "Import & Edit"

3. **Run the game**:
   - Press `F5` to run in Godot editor
   - OR: Project → Export → HTML5 → Export Project → Open in browser

### Development Workflow

This project follows the **Godot Educational Game Pipeline**:
1. ✅ **Stage 1-2**: Concept → GDD Creation
2. ✅ **Stage 3**: GDD Review
3. ✅ **Stage 4**: Implementation Planning
4. ✅ **Stage 5**: Task List Generation
5. 🔄 **Stage 6**: Code Implementation (IN PROGRESS)

**Current Status**: Phase 1 (Foundation & Architecture) - Ready to begin Task 1.1

### Coding Standards

- **Indentation**: Tabs (NOT spaces)
- **Type hints**: Required for all variables and functions
- **Naming**: `snake_case` for functions/variables, `PascalCase` for classes
- **Comments**: Explain "why", not "what"
- **Signals**: Use for loose coupling between systems

**Example**:
```gdscript
extends Node

signal reaction_occurred(product_type: String)

var glucose_count: int = 0

func increment_glucose() -> void:
	glucose_count += 1
	reaction_occurred.emit("glucose")
```

### Testing

**Manual Testing Checklist**:
- [ ] All three stages completable without errors
- [ ] Save/load persists across browser sessions
- [ ] Runs at 30+ FPS on Chromebook
- [ ] No console errors in browser DevTools
- [ ] Colorblind mode toggles patterns correctly
- [ ] Audio volume controls work

**Performance Targets**:
- Load time: < 5 seconds on standard WiFi
- Frame rate: 60 FPS desktop, 30+ FPS Chromebook
- File size: < 10 MB total

---

## 📚 Documentation

### For Developers
- **[Game Design Document (GDD) v1.1](docs/GDD_v1.1.md)**: Complete game specifications
- **[Implementation Plan](docs/IMPLEMENTATION_PLAN.md)**: 8-phase development roadmap
- **[Phase 1 Tasks](docs/TASKS_PHASE1.md)**: Discrete task list for foundation
- **[GDD Review](docs/GDD_REVIEW.md)**: Quality analysis and improvements

### For Teachers
- **[Teacher Guide](docs/TEACHER_GUIDE.md)**: Lesson plans and discussion prompts *(coming soon)*
- **[Standards Alignment](docs/STANDARDS.md)**: Detailed NGSS mapping *(coming soon)*
- **[Assessment Rubric](docs/ASSESSMENT.md)**: Learning indicators *(coming soon)*

### For Students
- **[How to Play](docs/HOW_TO_PLAY.md)**: Controls and objectives *(coming soon)*
- **[Science Background](docs/SCIENCE.md)**: Real-world connections *(coming soon)*

---

## 🗺️ Roadmap

### Phase 1: Foundation & Architecture ✅ READY
- [x] Project setup and configuration
- [x] AutoLoad singletons (GameManager, GameConstants, SaveSystem)
- [x] Save system with localStorage and versioning
- [ ] **Tasks 1.1-1.10 ready for execution**

### Phase 2: Draggable Molecule System (Weeks 3-5)
- [ ] Base molecule class with drag-and-drop
- [ ] Molecule spawning system with object pooling
- [ ] Workspace area with capacity management
- [ ] Trash zone for molecule disposal
- [ ] Molecule interaction polish (separation, selection)

### Phase 3: Reaction System (Weeks 6-8)
- [ ] Reaction detection for photosynthesis and respiration
- [ ] Reaction animations (swirl, scale, particles)
- [ ] ATP visualization (lightning bolts)
- [ ] Workspace background effects

### Phase 4: Stages 1 & 2 (Weeks 9-11)
- [ ] Stage 1 scene (Photosynthesis Factory)
- [ ] Stage 2 scene (Cellular Respiration Power Plant)
- [ ] HUD implementation with counters
- [ ] Tutorial overlays

### Phase 5: Stage 3 Ecosystem (Weeks 12-15) 🎯 MVP
- [ ] Plant and animal organisms
- [ ] Atmosphere management system
- [ ] Stage 3 scene with balance mechanics
- [ ] Gas flow visualization
- [ ] Stage 3 HUD with net change indicators

### Phase 6: UI/UX Polish (Weeks 16-18)
- [ ] Main menu
- [ ] Pause menu with settings
- [ ] Stage transition screens
- [ ] Visual effects polish

### Phase 7: Audio Integration (Week 19)
- [ ] Sound effects (reactions, pickups, UI)
- [ ] Background music (menu, stages 1-2, stage 3)

### Phase 8: Testing & Deployment (Weeks 20-21)
- [ ] Performance optimization
- [ ] Chromebook compatibility testing
- [ ] Bug fixing
- [ ] Web deployment (GitHub Pages)

### Post-MVP Enhancements (Future)
- [ ] **Carbon Atom Tracker**: Follow one carbon atom through all stages
- [ ] **Realistic Mode**: 100:1 plant:animal ratio teaching energy pyramids
- [ ] **Ecosystem Scenarios**: Forest fire, deforestation, algae bloom challenges
- [ ] **Data Export**: Teacher dashboard with student metrics (CSV)
- [ ] **Spanish Translation**: Full UI and tutorial in Spanish
- [ ] **Level Editor**: Teachers create custom Stage 3 scenarios

---

## 🤝 Contributing

We welcome contributions! This project is designed for:
- **Educators**: Suggest improvements, test in classrooms, provide feedback
- **Developers**: Implement features, fix bugs, optimize performance
- **Artists**: Create sprites, animations, UI elements
- **Sound Designers**: Compose music, create sound effects

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Follow coding standards**: Tabs, type hints, GDScript best practices
4. **Test thoroughly**: Verify no regressions, check performance
5. **Commit with clear messages**: Explain what and why
6. **Submit a pull request**: Reference any related issues

### Development Guidelines

- Defer to the **GDD v1.1** for all design decisions
- Follow the **Implementation Plan** for phased development
- Use **task lists** from Stage 5 for discrete work units
- Test on **Chromebook** or low-spec hardware before submitting
- Maintain **accessibility** features (colorblind mode, simple language)

---

## 📄 License

**Code License**: MIT License

**Educational Content License**: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

**Asset Licenses**:
- Sprites: [To be determined based on source]
- Audio: Pixabay Content License (free for educational use)
- Fonts: SIL Open Font License

See [LICENSE.md](LICENSE.md) for full details.

---

## 👥 Credits

### Development Team
- **Game Designer & Developer**: Sean ([@SFMiner](https://github.com/SFMiner))
- **AI Development Assistant**: Claude (Anthropic Sonnet 4.5)
- **Educational Consultant**: [Your Name Here]

### Special Thanks
- **Students**: Middle school beta testers providing invaluable feedback
- **Teachers**: Classroom integration partners
- **Godot Community**: Engine support and resources
- **Pixabay**: Royalty-free audio assets

### Built With
- **Godot Engine** by Juan Linietsky, Ariel Manzur, and contributors
- **GDScript** language
- **Godot Educational Game Pipeline** methodology

---

## 📞 Contact

- **Issues**: [GitHub Issues](https://github.com/sfminer/carbon-quest/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sfminer/carbon-quest/discussions)
- **Email**: seanmonster@gmail.com

---

## 📈 Project Status

| Phase | Status | Completion | Duration |
|-------|--------|------------|----------|
| 1. Foundation | 🔄 Ready to Start | 0% | 2 weeks |
| 2. Molecules | ⏸️ Not Started | 0% | 2-3 weeks |
| 3. Reactions | ⏸️ Not Started | 0% | 2-3 weeks |
| 4. Stages 1-2 | ⏸️ Not Started | 0% | 2-3 weeks |
| 5. Stage 3 (MVP) | ⏸️ Not Started | 0% | 3-4 weeks |
| 6. UI/UX | ⏸️ Not Started | 0% | 2-3 weeks |
| 7. Audio | ⏸️ Not Started | 0% | 1 week |
| 8. Testing | ⏸️ Not Started | 0% | 1-2 weeks |
| **Overall** | 🚀 **Planning Complete** | **5%** | **14-23 weeks** |

**Last Updated**: November 13, 2025

---

## 🌟 Why This Project Matters

Climate literacy and understanding ecosystems are critical for the next generation. **Carbon Quest** makes complex scientific concepts tangible and engaging through gameplay. Students don't just memorize photosynthesis equations - they *build* glucose molecules themselves. They don't just read about the carbon cycle - they *watch* carbon atoms flow between organisms in real-time.

By making science interactive and visual, we help students who struggle with traditional text-heavy instruction. By making it fun, we create positive associations with scientific learning. By making it free and web-based, we ensure every student with a Chromebook can access it.

**Every middle schooler deserves to understand how life on Earth works. This game is our contribution to making that happen.**

---

<div align="center">

**Built with 🌱 for curious minds**

[⬆ Back to Top](#carbon-quest-from-sunlight-to-life)

</div>