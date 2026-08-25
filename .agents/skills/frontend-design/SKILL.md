---
name: frontend-design
description: Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthetic direction, typography, palette selection, layout composition, and avoiding templated AI-generated defaults.
license: MIT
---

# Frontend Design

Approach this as the design lead at a small studio known for giving every client a visual identity that could not be mistaken for anyone else's. The goal is to make deliberate, opinionated choices about palette, typography, and layout that are specific to the brief, taking calculated aesthetic risks that fit the product.

## 1. Ground It in the Subject

- If the brief does not pin down what the product or subject is, pin it yourself before designing: name one concrete subject, its audience, and the page's single job, and state your choice.
- Draw inspiration from the subject's own world: its materials, instruments, artifacts, and vernacular.
- Build with the brief's real content and subject matter throughout—avoid generic placeholder patterns.

## 2. Design Principles

### Hero as a Thesis
- Open with the most characteristic element of the subject's world: a strong headline, an image, an animation, a live interactive demo, or a key artifact.
- Avoid defaulting to generic SaaS clichés (e.g., massive number with a small label + generic gradient accent) unless specifically appropriate.

### Typography Carries Personality
- Pair display and body fonts deliberately to match the tone of the subject.
- Set a clear type scale with intentional weights, widths, letter-spacing, and line-heights.
- Make typography an active, memorable part of the visual identity rather than an invisible delivery vehicle.

### Structure Is Information
- Structural devices (dividers, labels, eyebrows, numbering) should encode something true about the content, not decorate it.
- Only use numbered markers (`01`, `02`, `03`) if the content is an actual ordered sequence or timeline.

### Leverage Motion Deliberately
- Use orchestrated motion to serve the experience: page-load reveal sequences, scroll-triggered transitions, and tactile hover/focus micro-interactions.
- Avoid scattered, gratuitous animations that contribute to a cheap or robotic feel.

### Match Complexity to Vision
- **Maximalist directions:** Require elaborate execution, rich textures, layered depth, and expressive visuals.
- **Minimalist directions:** Require extreme precision in spacing, hierarchy, proportions, and restraint.

### Intentional Copy & Content
- Craft thoughtful, context-rich microcopy and content that reinforce the product's identity instead of generic filler text ("Lorem ipsum", "Transform your workflow").

---

## 3. Anti-Default Calibration

Be mindful to avoid falling into standard AI-generated aesthetic clichés by default:
1. *Warm cream background (`#F4F1EA`) + high-contrast serif display + terracotta accent*
2. *Near-black background + single acid-green / neon-vermilion accent*
3. *Broadsheet / newspaper layout with hairline rules, zero border-radius, and dense column grids*

Only use these directions when they genuinely align with the project brief and brand identity.

---

## 4. Design Workflow

```
1. Brainstorm & Explore -> 2. Define Tokens (Palette & Typography) -> 3. Plan & Wireframe -> 4. Critique -> 5. Build -> 6. Final Polish
```

1. **Brainstorm & Explore:** Understand the subject, target audience, and key value proposition.
2. **Define Design Tokens:** Select 4–6 cohesive colors (backgrounds, surfaces, text, primary accent, subtle borders) and font pairings.
3. **Plan & Wireframe:** Establish page structure, responsive grid, and one distinctive "signature" visual element.
4. **Critique:** Verify that the layout feels tailored to the subject and is not a templated generic card grid.
5. **Build:** Implement semantic HTML, clean responsive CSS/components, and accessible interactive states (hover, focus, active, disabled).
6. **Final Polish:** Refine spacing, typography contrast, responsive breakpoints, and micro-interactions.
