# AutoSecLearn

## Table of Contents

1. [Overview](#overview)
2. [Product Spec](#product-spec)
3. [Wireframes](#wireframes)
4. [Schema](#schema)
5. [Milestones](#milestones)

## Overview

### Description

AutoSecLearn is an iOS educational app that teaches network infrastructure and cybersecurity concepts through interactive lessons, quizzes, flashcards, and certification guidance. Users learn topics like Python network automation, switches, routers, firewalls, and more through a modular, tab-based interface where each section is independently developed by a team member.

### App Evaluation

- **Category:** Education
- **Mobile:** Provides users the flexibility to learn anytime and anywhere, making educational content easily accessible on the go. Interactive quizzes and flashcards use touch-based gestures that work best on mobile.
- **Story:** Network security is a critical and growing field, but most learning resources are dry textbooks or expensive courses. AutoSecLearn makes cybersecurity education accessible and engaging through interactive lessons and quizzes that students actually want to use.
- **Market:** Specifically for IT professionals and cybersecurity students, but realistically anyone with a basic interest in network configurations and security. Students preparing for certifications like CompTIA Network+, Security+, and Cisco CCNA would find this especially valuable.
- **Habit:** This could be used every day and incorporated into a daily study routine. Users both consume content (lessons) and actively participate (quizzes, flashcards, interactive exercises).
- **Scope:** This app can realistically be developed in one semester. The modular tab-based architecture lets each team member own and build their section independently, reducing conflicts and allowing parallel development.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can navigate between sections using a tab bar
- [x] User can view a home screen with app info, features, and team details
- [x] User can browse learning modules organized by topic
- [x] User can read detailed lessons with section-by-section content
- [x] User can interact with in-lesson exercises (multiple choice, true/false, fill-in-the-blank, drag-and-drop)
- [x] User can view flashcards for reviewing key concepts
- [x] User can browse certification recommendations with details (exam format, cost, prerequisites)

**Optional Nice-to-have Stories**

- [ ] User can take quizzes to test their understanding after completing modules
- [ ] User can track their progress across modules
- [ ] User can earn XP or badges for completing content
- [ ] User can bookmark lessons to review later

### 2. Screen Archetypes

- **Home Screen (Tab 1 — Bryan)**
  - User views app info, feature overview, and team member listing

- **Giovanna's Section (Tab 2 — Giovanna)**
  - User reviews Module 1 concepts through interactive flashcards

- **Module List Screen (Tab 3 — Remberto)**
  - User browses Python Network Automation modules
  - User sees module titles, descriptions, and lesson/question counts

- **Module Detail Screen (Tab 3 — Remberto)**
  - User views the list of lessons within a module
  - User navigates to individual lessons

- **Lesson Screen (Tab 3 — Remberto)**
  - User reads lesson content section by section
  - User interacts with embedded exercises with feedback and explanations
  - User tracks progress through a visual progress bar

- **Meagan's Section (Tab 4 — Meagan)**
  - User takes Module 1 quiz to test understanding

- **Certification List Screen (Tab 5 — Alec)**
  - User browses recommended IT certifications (CompTIA Network+, Security+, Cisco CCNA, CyberOps)

- **Certification Detail Screen (Tab 5 — Alec)**
  - User views exam format, cost, passing score, prerequisites, and description for each certification

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- Home
- Giovanna's Section (Flashcards)
- Remberto's Section (Modules)
- Meagan's Section (Quiz)
- Alec's Section (Certifications)

**Flow Navigation** (Screen to Screen)

- **Home Screen**
  - Standalone — no sub-navigation

- **Giovanna's Section**
  - Flashcard view with flip interaction

- **Remberto's Section**
  - Module List → Module Detail → Lesson View

- **Meagan's Section**
  - Quiz view with questions and answers

- **Alec's Section**
  - Certification List → Certification Detail

## Wireframes

<img src="Wireframes_autoSec.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema

### Models

**LearningModule**

| Property | Type | Description |
|----------|------|-------------|
| id | String | Unique module identifier |
| title | String | Module title |
| description | String | Brief module description |
| icon | String | SF Symbol name for module icon |
| color | String | Theme color for the module |
| lessons | [Lesson] | Array of lessons in the module |
| quiz | Quiz | End-of-module quiz |

**Lesson**

| Property | Type | Description |
|----------|------|-------------|
| id | String | Unique lesson identifier |
| title | String | Lesson title |
| sections | [LessonSection] | Content sections within the lesson |

**QuizQuestion**

| Property | Type | Description |
|----------|------|-------------|
| id | String | Unique question identifier |
| question | String | The question text |
| options | [String] | Array of answer choices |
| correctAnswerIndex | Int | Index of the correct answer |
| explanation | String | Explanation shown after answering |
| difficulty | Difficulty | beginner, intermediate, or advanced |

**Certification**

| Property | Type | Description |
|----------|------|-------------|
| id | String | Unique certification identifier |
| name | String | Certification name (e.g., CompTIA Network+) |
| vendor | String | Issuing organization |
| examCode | String | Exam code (e.g., N10-009) |
| numberOfQuestions | Int | Number of exam questions |
| timeLimit | String | Exam time limit |
| passingScore | String | Score required to pass |
| cost | String | Exam cost |
| prerequisites | [String] | Required prerequisites |

### Networking

- This app uses local data only — no network requests. All module content, quiz questions, and certification data are bundled within the app.

## Milestones

### Milestone 1 — Project Planning (Unit 7)

- [x] Creation of GitHub Organization and Group Project Repo
- [x] `brainstorm.md` with initial ideas (6+)
- [x] Evaluation of top 3 ideas
- [x] Final app idea chosen
- [x] App Overview: Description and evaluation
- [x] App Spec: User features, screens, and navigation flows
- [x] Wireframe images

### Milestone 2 — Sprint Planning & Build Sprint 1 (Unit 8)

**Sprint Planning**
- [x] GitHub Project Board created
- [x] GitHub Milestones created
- [x] GitHub Issues created from user features
- [x] Issues assigned to team members and added to project board

**Completed User Stories**
- [x] Bryan — Home tab displays app info, features, and team listing
- [x] Giovanna — Module 1 flashcards
- [x] Remberto — First module with interactive lessons
- [x] Meagan — Module 1 quiz
- [x] Alec — Certification recommendations page

**Build Progress**

[![Watch the Video](https://img.youtube.com/vi/h44xCoc0MSE/0.jpg)](https://youtube.com/shorts/h44xCoc0MSE)

### Milestone 3 — Build Sprint 2 & Demo Prep (Unit 9)

**Completed User Stories**
- [x] Remberto — Expanded to 5 Python Network Automation modules with full lesson content and interactive exercises
- [x] Alec — Certification detail views with exam info for CompTIA and Cisco certs

**Build Progress**

[![Watch the Video](https://img.youtube.com/vi/GVFwa13pEXA/0.jpg)](https://youtube.com/shorts/GVFwa13pEXA)

**Demo Video**

> **[REPLACE THIS]** — Add your 2-4 minute demo video link here (YouTube or Vimeo). Delete this text after adding it.

---

## Team

| Name | GitHub | Role |
|------|--------|------|
| Bryan Puckett | BryanPuckettGH | Home tab / App structure / Theme |
| Giovanna Curry | gcurr011 | Flashcards |
| Remberto Silva | rembertoS | Learning Modules |
| Meagan Alfaro | meaganalfaro | Quiz |
| Alec Rivera | Alec-Rivera | Certifications |

## License

This project was developed as part of the COP4655 course at Florida International University, Spring 2026.
