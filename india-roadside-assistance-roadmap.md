# RoadSaathi Blueprint — India's First Urgently-Style RSA Platform
### A build roadmap for a category-defining roadside assistance app

---

## 0. The Positioning: Why "no one has done this before" is actually true

Existing India players (ReadyAssist, AUTO i CARE, StrandD) solved the basic "connect stranded driver to mechanic" problem. None of them have combined **all** of the following into one platform — that's your white space:

1. **Two-wheeler-first, not car-first.** India has ~21 crore registered two-wheelers vs ~4 crore cars. Every US/Canada app (Urgently, Honk) is built car-first because that's their market. Build your dispatch, pricing, and provider network around bikes/scooters as the primary use case, cars as secondary.
2. **EV-native from day one.** Mobile charging vans, battery diagnostics, EV-specific towing protocols, and charging-station guidance — this is barely served in India today.
3. **Highway + rural coverage as a core promise, not an afterthought.** India's national highway network is where breakdowns are most dangerous (no shade, no safety, women traveling alone). AUTO i CARE covers highways but isn't the safety-first brand.
4. **Vernacular + WhatsApp-first UX.** Not everyone will download and navigate an English app under stress. A WhatsApp bot fallback ("send location, get help") + regional language support is something no competitor has nailed.
5. **Safety-layer for women and solo travelers.** Live-share-to-family, verified provider photo before dispatch, panic button tied to local police helpline — a genuine differentiator, not a checkbox feature.

---

## 1. Phase 0 — Validate before you build (Weeks 1–4)

**Goal: prove people will pay before writing the matching algorithm.**

- Pick ONE city (Bengaluru fits — dense EV adoption + heavy 2-wheeler traffic + your location)
- Manually onboard 15–20 providers: local mechanics, tyre shops, tow operators, EV service points. Cold calls and visits, not an app.
- Put a simple Google Form / WhatsApp Business number as your "app"
- When someone requests help, YOU manually call the nearest provider and coordinate — Wizard-of-Oz style
- Track: response time, price acceptance, repeat requests, what breaks
- Target: 50 real paid jobs before writing production code

This tells you your actual dispatch radius, real provider pricing, and what customers complain about — all things a generic dev guide can't tell you.

---

## 2. Phase 1 — MVP Build (Months 2–4)

### Customer app — minimum feature set
- Phone/OTP login (no email-first flows — India is phone-native)
- Vehicle profile (2W/4W/EV toggle — this branches your whole flow)
- One-tap SOS + service picker: jump-start, flat tyre, fuel delivery, towing, lockout, EV charging, minor repair
- GPS auto-detect + manual pin-drop (GPS drifts badly on Indian highways/flyovers)
- Upfront price quote before confirm
- Live map tracking + ETA
- Masked-number call/chat with provider
- OTP-verified service completion (prevents fraud on both sides)
- UPI-first payment (Razorpay/Cashfree), cash-on-completion as fallback
- "Share my trip" link for family — ship this in v1, not later

### Provider app — minimum feature set
- Job accept/reject with map + distance shown
- Turn-by-turn navigation handoff to Google Maps
- Status updates (en route → arrived → in progress → done)
- Earnings + payout ledger
- Document upload: license, RC, insurance (gate live jobs behind verification)

### Admin dashboard
- Provider approval queue
- Live job map across the city
- Manual override/reassign (you WILL need this early — automated dispatch fails edge cases)
- Basic analytics: response time, completion rate, demand by zone/hour

### Tech stack
| Layer | Choice | Why |
|---|---|---|
| Mobile | React Native or Flutter | One codebase, ship Android + iOS together |
| Backend | Node.js/Express | Fast iteration, huge ecosystem |
| Database | PostgreSQL + PostGIS | You already know PL/pgSQL — PostGIS gives you geospatial "nearest provider" queries natively |
| Real-time | Redis + Socket.io | Live location pings, job status pushes |
| Maps | Google Maps Platform (Directions, Distance Matrix, Places) | Budget for usage costs from day one |
| Payments | Razorpay or Cashfree | UPI-native, India-compliant |
| Notifications | Firebase Cloud Messaging + SMS via MSG91 | Riders often lose data connectivity when stranded — SMS fallback matters |
| Hosting | AWS Mumbai region or GCP Bangalore | Keep latency and data residency local |

### Core dispatch logic (this is your actual moat, not the UI)
A simple nearest-provider match isn't enough. Rank candidate providers by a weighted score of:
- Distance/ETA (PostGIS `ST_DWithin` + Distance Matrix API)
- Provider rating
- Vehicle-type match (does this provider actually handle EVs/2-wheelers/heavy tow?)
- Current load (don't slam your best providers with every job)

This is exactly the kind of thing you can write as a PL/pgSQL function — a `find_best_provider(job_id)` that does `NOT EXISTS` checks for availability/verification and `RAISE EXCEPTION` when no provider qualifies in radius, falling back to a wider search radius.

---

## 3. Phase 2 — Differentiation Layer (Months 5–7)

This is where you build the things that make it "no one has done before":

- **WhatsApp Business API bot** — "send location + describe problem" flow for users who won't download an app under stress
- **EV support vertical** — mobile charging van partnerships, battery health check-ins, EV-specific tow protocol (can't flatbed all EVs the same way as ICE vehicles)
- **Highway SOS mode** — auto-detects highway driving via geofencing, shows nearest highway patrol/police helpline alongside your service, prioritizes towing for highway jobs (higher danger = higher priority in your queue)
- **Women/solo-traveler safety layer** — provider photo + ID shown before dispatch, live-share defaults to ON for solo trips at night, one-tap connect to local police control room
- **Vernacular support** — Hindi, Kannada, Tamil, Telugu at minimum for your launch geography

---

## 4. Phase 3 — Monetization & Partnerships (Months 6–9, runs parallel)

- **Pay-per-use** (primary early revenue) — 15–25% commission on each job
- **Subscription plans** — "N free services/year," rolled out once you have retention data
- **B2B fleet contracts** — food delivery fleets, cab aggregators, corporates with company vehicles need guaranteed RSA; often more stable than consumer revenue
- **Insurance/OEM partnerships** — most Indian motor insurance policies already promise RSA but outsource it poorly; you can be the white-labeled backend they plug into via API

---

## 5. Phase 4 — Scale (Month 9+)

- Expand city by city, not all at once — replicate the Phase 0 manual-validation step in each new city before automating
- Build a provider-density heatmap into your admin tools to know exactly where to recruit next
- Consider a second, thinner "highway network" layer — long-haul truck driver community partnerships for rural/highway coverage, since that's the hardest gap to fill with city-based gig workers

---

## 6. Legal & compliance checklist (India-specific)

- Private limited company registration (needed for payment gateway approval, future funding)
- GST registration
- Provider vetting: driving license, vehicle RC, third-party insurance verified before any job goes live — liability exposure is real if an unverified operator causes damage
- Independent-contractor agreements for providers (gig model, not employment)
- Digital Personal Data Protection Act compliance for how you store location/vehicle/customer data

---

## 7. Realistic budget & timeline snapshot

| Phase | Duration | Rough cost (India dev rates) |
|---|---|---|
| Phase 0 (manual validation) | 1 month | Near-zero, just your time + a WhatsApp number |
| Phase 1 (MVP build) | 3 months | ₹8–20 lakh if outsourced; much less if self-built |
| Phase 2 (differentiation) | 2–3 months | ₹4–8 lakh |
| Phase 3 (partnerships) | Parallel, ongoing | Mostly BD time, not dev cost |
| Phase 4 (scale) | Ongoing | City-by-city, funded by Phase 3 revenue or a raise |

---

## Next steps I can help with directly
- PostgreSQL schema + PL/pgSQL functions for the provider-matching engine (`find_best_provider`, availability checks with `NOT EXISTS`, exception handling)
- React Native screen scaffolding for the customer SOS flow
- Node.js dispatch API structure
