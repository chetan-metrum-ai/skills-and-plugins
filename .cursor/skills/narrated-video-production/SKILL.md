---
name: narrated-video-production
description: Produce demo, explainer, and informational videos from instructions and
  supplied background material, with a human-approved speech narrative and audio-timed
  visuals. Use when Codex must plan or create a narrated product demo, tutorial, launch
  video, training video, or informational video that combines voice-over with slides,
  text, images, screen recordings, or video clips.
metadata:
  oasr:
    hash: sha256:627becfa14dba10772c77eb35eeb271796412aa8f0480cf565c3debbb017d4a6
    source: skills/narrated-video-production
    synced: 'generated'
---

# Produce an approval-gated narrated video

Make the approved narration and its rendered speech audio the source of truth for
the video. Do not start speech synthesis or final video assembly until the human
has explicitly approved the complete narration.

## Apply the Metrum AI visual system

Use the Metrum AI visual system for every video by default and do not substitute
another brand, palette, font system, or logo. Read
[`references/metrum-ai-brand.md`](references/metrum-ai-brand.md) before creating
visuals. Refresh the official sources named there when practical; use the recorded
specification as the fallback if they are unavailable.

Use the official Metrum AI logo only, preserve its proportions and clear space,
and never recreate it as text. Apply the dark technical-interface composition,
approved type roles, neutral text hierarchy, and red-to-blue gradient specified
in the reference. Attribute external visual sources separately; do not confuse
them with Metrum branding.

## 1. Prepare the approval package

Read the instructions and supplied background material. Identify the audience,
objective, platform, aspect ratio, target duration, brand constraints, available
assets, and claims that require source support. Ask only for missing information
that materially affects the video.

Draft a package containing:

- The complete, speakable narration, divided into numbered scenes or beats.
- A concise visual intent for each beat: screen recording, supplied clip, image,
  diagram, slide, text overlay, or generated visual.
- Any on-screen wording and a source note for factual claims.
- Metrum-branded visual direction and an expected duration that includes pauses.
- The inter-scene pause configuration: default `0.75` seconds after every
  non-final scene; allow `0.0` to `2.0` seconds when the user requests a
  different cadence.
- Estimated duration and open questions or asset gaps.

Present the package for review and ask for explicit approval of the narration.
Treat comments or a general go-ahead as approval only when they clearly approve
the full narration. Do not silently edit an approved narration. If any word of it
changes, present the revised complete narration and obtain approval again.

## 2. Lock the approved narration and generate speech

Save the approved narration as a durable project artifact and assign stable scene
IDs. Record the approved text verbatim in the production manifest.

After approval, ask which TTS provider to use. For ElevenLabs, ask for the API
key and chosen voice ID; ask for the equivalent credentials and voice/model
selection for another provider. Request credentials only for the active run; use
environment variables or the provider's secure mechanism, never put secrets in
source files, manifests, logs, or commits.

Generate separate audio clips for the stable scene IDs, then concatenate them
without rewriting their speech. Insert the configured silence between non-final
clips; do not append silence to the final clip. Record each measured speech
duration, every pause duration, the combined duration, provider, model, voice ID,
and non-secret synthesis settings. Normalize format and loudness only when it
does not change speech timing. If synthesis, pronunciation, or voice selection
needs a text change, return to approval rather than patching the wording in
post-production.

Use the rendered audio durations, not estimates or word-count timing, to create
the timeline. Where available, generate word- or phrase-level timestamps from the
provider or a forced-alignment/transcription pass; otherwise use measured scene
durations and mark the lower timestamp precision.

## 3. Build visuals against the audio timeline

Create a timeline artifact with exact start time, end time, duration, narration
text, visual asset, on-screen text, pause, and transition for every scene. Make
visual segments fit their audio segment by extending, trimming, freezing, or
using a deliberate transition. Never speed up, cut, or pad approved speech merely
to fit an asset.

Use the configured pause to make scene changes feel intentional. By default,
hold the outgoing visual for `0.30` seconds, then crossfade to the next visual
over the remaining `0.45` seconds; start the next narration only after its slide
is fully visible. Scale the hold and crossfade proportionally if the user changes
the pause. When the pause is `0`, use a short transition only if it does not
overlap speech; otherwise use a clean cut. Do not place a transition over spoken
words by default.

Use supplied or licensed assets. Label generated visuals as such when the user
needs provenance. Keep on-screen text consistent with the approved narration and
the source material; do not introduce unsupported claims. Generate captions from
the final rendered audio and preserve the approved wording except for essential
caption readability conventions.

For demo videos, capture the relevant UI state before recording and align each
action with the spoken claim. Prefer readable pacing over dense screen activity.
For information videos, favor one primary idea per scene and allow the audience
enough time to read key text.

## 4. Assemble and verify

Render the video with the final narration as its primary audio track. Align all
clips, images, slides, transitions, captions, and overlays to the measured
timeline. Render default transitions inside the explicit inter-scene silence.
Include music or effects only if requested; duck them beneath speech and ensure
they do not obscure narration.

Before delivery, verify:

- Every spoken claim appears in the approved narration and is supported by the
  supplied material where factual.
- The final audio starts at zero, has no accidental gaps or overlaps, and matches
  the manifest duration; every intentional gap is recorded as a configured pause.
- Visual scene boundaries, captions, and on-screen text match the final audio
  timestamps; inspect scene transitions frame-by-frame where timing is critical.
- Metrum AI logo, colors, fonts, contrast, and gradient treatment match the
  required brand reference.
- The render has the requested dimensions, frame rate, codec/container, and
  playable audio.

Deliver the final video, the approved narration, final audio, captions, and the
non-secret timeline/manifest. State any approximation, missing asset, or timing
limitation plainly; do not claim frame-exact alignment when only scene-level
timing was available.
