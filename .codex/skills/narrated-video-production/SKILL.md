---
name: narrated-video-production
description: Use this skill when the user needs a narrated product demo, tutorial,
  launch video, training video, or informational video that combines voice-over with
  slides, text, images, screen recordings, or clips. Trigger on any request to plan
  or produce a video with a speech narrative.
metadata:
  oasr:
    hash: sha256:85f0a28927ef5d92a48c2b55934a2c88f5a3d26831353ced33b55f16a21e5f38
    source: skills/narrated-video-production
    synced: 'generated'
---

# Produce an approval-gated narrated video

The approved narration and its rendered speech audio are the source of truth. Do **not** start speech synthesis or final video assembly until the human has explicitly approved the complete narration.

## Visual-storytelling standard

Every scene must communicate an idea visually, not merely swap a headline on an otherwise empty slide. Treat a title card as a deliberate, occasional framing device (opening, closing, or chapter break), never as the default scene type.

For every narrated scene, design a **visual payload** with all of the following:

- a primary visual anchor: product screen recording, UI reconstruction, photograph, generated editorial/product illustration, chart, diagram, comparison, or data display;
- supporting information: concise editable on-screen copy, labels, callouts, evidence, or a short caption; and
- an on-screen progression: a reveal, cursor/focus movement, highlighted state, diagram build, chart draw, crop/pan, before/after change, or other meaningful change that follows the spoken point.

Use the medium that best explains the line of narration. Product behavior calls for a real recording or faithful UI sequence; relationships call for a diagram; change over time calls for a chart, timeline, or before/after; a concept or emotional moment calls for an image or illustration. Do not use a generic stock image when the scene needs evidence or product context.

Avoid consecutive scenes with the same composition. Alternate between full-bleed visual, split-screen, annotated product view, diagram/data view, comparison, and restrained editorial layout as the story warrants. A scene should normally show two to four purposeful elements beyond its headline; keep the frame quiet enough to read rather than filling it decoratively.

Keep text brief and legible: one clear idea per scene, a short headline only when helpful, and no paragraph-sized blocks. Put exact or changeable copy in the editable video layout, not baked into a generated image. Maintain strong contrast, safe margins, and a readable mobile-sized preview.

## Brand

Apply the Metrum AI visual system by default. Read [`references/metrum-ai-brand.md`](references/metrum-ai-brand.md) before creating visuals. Use the official logo only (never recreate as text); apply the dark technical-interface composition, approved type roles, and red-to-blue gradient.

## Workflow

### 1. Prepare the approval package

Read the instructions and background material. Identify audience, objective, platform, aspect ratio, target duration, brand constraints, available assets, and claims that need source support. Ask only for missing information that materially affects the video.

Draft a package containing:

- Complete, speakable narration divided into numbered scenes/beats
- A scene-by-scene storyboard, with the visual payload for each beat: primary anchor, supporting elements and editable on-screen wording, composition, and the on-screen progression timed to the narration
- Asset plan per beat: supplied asset, recording to capture, licensed source, data/source required, or generated visual; identify ownership/provenance and gaps
- On-screen wording and source notes for factual claims; do not repeat the narration verbatim unless it is an intentional emphasis
- Metrum-branded visual direction and expected duration including pauses
- Inter-scene pause config (default `0.75s` after every non-final scene; allow `0.0`–`2.0s`)
- Estimated duration and open questions/asset gaps

Present the package and ask for **explicit approval of the full narration**. Comments or a general go-ahead count only when they clearly approve the complete narration. If any word changes after approval, re-present the full narration and obtain approval again.

### 2. Lock narration and generate speech

Save the approved narration as a durable project artifact with stable scene IDs. Record the approved text **verbatim** in the production manifest.

After approval, ask which TTS provider to use and request credentials only for the active run (env vars or provider secure mechanism — never put secrets in source, manifests, logs, or commits).

Generate separate audio clips per scene ID, then concatenate them without rewriting speech. Insert the configured silence between non-final clips; do not append silence to the final clip. Record measured speech durations, pause durations, combined duration, provider, model, voice ID, and non-secret synthesis settings.

Use rendered audio durations (not estimates) to create the timeline. Prefer word-/phrase-level timestamps when available; otherwise mark lower timestamp precision.

If synthesis needs a text change, return to approval — do not patch wording in post.

### 3. Build visual assets and the timeline

After narration approval, build the planned visual payload for each scene. Use supplied assets, real product captures, and licensed material first when they are the most truthful way to make the point. Create diagrams, charts, UI callouts, and text as editable composition layers so they can be timed, revised, and kept crisp.

When an original image or illustration materially improves a scene, use the available `$nabapro` skill (Nano Banana Pro) before falling back to another available image-generation tool. Follow its workflow: write a scene-specific prompt, run its dry run before a paid call, save the output and provenance, and use the approved brand setting. Generate imagery as a visual anchor only; add headlines, labels, metrics, and calls to action in the video layout rather than asking the image model to render them. If generated imagery would make a factual product claim look like evidence, label it appropriately or select a more evidentiary visual.

For each generated or sourced asset, record its file/URL, license or generation provenance, intended scene, crop/focal point, and any required attribution. If an asset is unavailable, revise the visual treatment without changing the approved narration.

Create a timeline artifact with exact start/end/duration, narration text, visual anchor, supporting layers, visual action/progression, asset provenance, on-screen text, pause, and transition for every scene. Fit visuals to audio (extend, trim, freeze, transition) — never speed up, cut, or pad approved speech to fit an asset.

Time the visual progression to the spoken idea. Establish the anchor at scene start, reveal or emphasize supporting information as the relevant phrase is spoken, then hold long enough to read. For scenes longer than roughly six seconds, plan at least one meaningful state change or camera/composition change unless a deliberate static hold is needed for comprehension. Motion must explain, focus, or pace the story; never animate text or decorative shapes solely to create activity.

Default pause split: hold outgoing visual `0.30s`, crossfade remaining `0.45s`; start next narration only after its slide is fully visible. Scale proportionally if the user changes the pause. Never place a transition over spoken words by default.

Use supplied or licensed assets; label generated visuals when provenance matters. Keep on-screen text consistent with the approved narration. Generate captions from the final rendered audio.

### 4. Assemble and verify

Render with the final narration as the primary audio track. Align all clips, images, slides, transitions, captions, and overlays to the measured timeline. Include music/effects only if requested; duck them beneath speech.

Before delivery, verify:

- [ ] Every spoken claim is in the approved narration and source-supported where factual
- [ ] Final audio starts at zero, has no accidental gaps/overlaps, and matches the manifest duration
- [ ] Visual boundaries, captions, and on-screen text match final audio timestamps
- [ ] Every non-title scene has a visible primary anchor, supporting content, and a purposeful visual progression; no run of scenes is only a changing title over the same background
- [ ] Product claims are shown with a real capture, source-backed data, or clearly labeled illustrative treatment; generated and licensed assets have recorded provenance
- [ ] Generated imagery is well-composed at the final crop and contains no required editable copy baked into the image
- [ ] Metrum AI logo, colors, fonts, contrast, and gradient match the brand reference
- [ ] Render has the requested dimensions, frame rate, codec/container, and playable audio

Deliver the final video, approved narration, final audio, captions, and non-secret timeline/manifest. State any approximation or timing limitation plainly.

## Reference

- [`references/metrum-ai-brand.md`](references/metrum-ai-brand.md) — Brand system, palette, type, logo rules
- [`../nabapro/SKILL.md`](../nabapro/SKILL.md) — Preferred workflow for original scene imagery when Nano Banana Pro is available
