---
title: AI for Gravitational-Wave Physics
position: ML Research Intern
group:
    name: Computational Applied Mathematics & AI Lab (CAMAIL)
    link: "https://camail.org"
institution: ELLIS Institute Tübingen and Max Planck Institute for Intelligent Systems
collaboration: LIGO Lab at MIT
supervisor: T. Konstantin Rusch
from: June 2025
to: Summer 2026
# PLACEHOLDER — concrete contributions.
highlights:
    - Designed and trained state-space models for low-latency binary neutron star detection on LIGO strain data.
    - Built the training and evaluation pipeline in PyTorch (Lightning) and JAX/Equinox.
    - Core contributor to [Discretax](https://github.com/camail-official/discretax), the lab's open-source library of state-space models in JAX.
    - Co-developed PhyTS, a benchmark of physics time-series tasks (NeurIPS 2026).
tags: [Python, PyTorch, PyTorch Lightning, JAX, Equinox]
---

<!-- PLACEHOLDER: the short explainer. -->

<!-- When two neutron stars spiral into each other, they send ripples through spacetime that LIGO measures as length changes far smaller than a proton.  -->

Gravitational-wave signals can last minutes and are buried in non-stationary, glitchy detector noise, while astronomers need an alert within seconds to point telescopes at the merger. I worked on Linear Oscillatory State-Space Models (LinOSS): sequence models that handle very long inputs
efficiently and towards making it possible to detect binary neutron star mergers in real time.
