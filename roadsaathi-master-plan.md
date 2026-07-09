# RoadSaathi — Master Plan & Checklist
### Everything in one place: what to build, what to learn, what to spend, what to expect

---

## 1. The Prototype (already built)

File: `roadsaathi-prototype.html` — open it, click through:
- **Rider App** → Home/SOS screen → Price & provider match → Live tracking
- **Provider App** → Incoming job → En route & earnings

Use this to show teachers, mentors, or in interviews. It is not real functioning software — it's a clickable demo to prove the concept before writing backend code.

**Your action:** ☐ Download it, test it on your phone browser, ☐ get feedback from at least 3 people (a teacher, a friend, a potential user) before touching real code.

---

## 2. What to build, in order (do not skip steps)

☐ **Step 0 — Manual validation (Week 1-4, no coding)**
- Pick one small area (your neighborhood or college area)
- Talk to 5-15 local mechanics/tyre shops/tow operators in person
- Coordinate 20-50 real jobs manually via phone/WhatsApp — you are the "app"
- Track: response time, price acceptance, what breaks, what people actually ask for

☐ **Step 1 — MVP build (Month 2-4)**
- Customer app: OTP login, vehicle profile, SOS + service picker, GPS + manual pin, upfront price, live tracking, OTP-verified completion, UPI payment, share-trip link
- Provider app: accept/reject jobs, navigation handoff, status updates, earnings ledger, document upload
- Admin dashboard: provider approval, live job map, manual override, basic analytics

☐ **Step 2 — Differentiation layer (Month 5-7)**
- WhatsApp Business bot fallback
- EV support vertical (mobile charging, EV tow protocol)
- Highway SOS mode
- Safety layer (provider photo before dispatch, live-share default ON at night)
- Vernacular language support

☐ **Step 3 — Monetization & partnerships (Month 6-9, parallel)**
- Pay-per-use commission (15-25%)
- Subscription plans once you have retention data
- B2B fleet contracts
- Insurance/OEM partnership outreach (this is your highest-leverage move — see Section 5)

☐ **Step 4 — Scale (Month 9+)**
- Expand city by city, repeating Step 0 validation each time
- Build provider-density heatmap
- Consider highway/rural truck-driver network layer

---

## 3. Tech stack checklist

| Layer | Choice |
|---|---|
| ☐ Mobile | React Native or Flutter (pick ONE) |
| ☐ Backend | Node.js/Express |
| ☐ Database | PostgreSQL + PostGIS (builds on your PL/pgSQL skills) |
| ☐ Real-time | Redis + Socket.io |
| ☐ Maps | Google Maps Platform (Directions, Distance Matrix, Places) |
| ☐ Payments | Razorpay or Cashfree (UPI-native) |
| ☐ Notifications | Firebase Cloud Messaging + SMS via MSG91 |
| ☐ Hosting | AWS Mumbai or GCP Bangalore region |

**Core piece to build first:** `find_best_provider(job_id)` — a PL/pgSQL function using `NOT EXISTS` for availability checks, `RAISE EXCEPTION` when nothing qualifies in radius, ranking candidates by distance/rating/vehicle-type match/current load.

---

## 4. Skills & courses checklist

☐ PostgreSQL/PL/pgSQL — you already have this, keep sharpening
☐ React Native OR Flutter — official docs + YouTube playlists, no paid course needed
☐ Node.js/Express REST API design — official docs + build-along tutorials
☐ Razorpay integration basics — free docs + sandbox
☐ (Optional) Y Combinator Startup School — free, good for unit economics basics

**Qualities to build in yourself:**
☐ Comfort with cold outreach and rejection (biggest predictor of solo-founder success)
☐ Patience for slow, unglamorous ops work
☐ Basic financial discipline — track every rupee
☐ Willingness to talk to providers in their language, not just English
☐ Keep your existing trait: concise, no-fluff execution

---

## 5. Budget checklist (bootstrapped, one city)

| Item | Cost (₹) | Done? |
|---|---|---|
| Company registration (Pvt Ltd) + GST | 8,000 – 15,000 | ☐ |
| Domain, hosting, cloud (6 months) | 15,000 – 40,000 | ☐ |
| Maps API (early, low volume) | 5,000 – 20,000/month once live | ☐ |
| App store fees (Play + Apple) | ~11,000 | ☐ |
| Basic legal (provider agreements, T&Cs) | 10,000 – 25,000 | ☐ |
| Marketing to seed first providers/customers | 15,000 – 50,000 | ☐ |
| Buffer (3-4 months running costs) | 50,000 – 1,00,000 | ☐ |
| **Rough total (self-built app)** | **₹1.5 – 3 lakh** | |

Not financial advice — this is a factual planning estimate, not a guarantee.

---

## 6. Reality check — what competitors actually show

| Company | Status |
|---|---|
| **Urgently (USA)** | $129M revenue (2025), but being acquired by rival Agero after Nasdaq non-compliance notices — revenue scale didn't mean standalone survival |
| **ReadyAssist (India)** | ₹11.88 Cr revenue vs ₹23.22 Cr expenses in FY23-24 — a ₹11.34 Cr loss, 7+ years in, ~₹7 Cr raised |
| **AUTO i CARE (India)** | Bootstrapped, no disclosed revenue, 55,000+ garage network built without big VC money |

**Lesson:** Revenue takes years. Profit takes longer. Even funded, established players run at a loss. Plan accordingly — don't expect fast money.

---

## 7. Your highest-leverage move

Don't chase individual consumer downloads first. The pattern that actually worked for every player above (Urgently+BMW, ReadyAssist+Okinawa):

☐ Identify 2-3 EV two-wheeler OEMs or fleet operators in your city
☐ Reach out once you have a working MVP + validation data from Step 0
☐ Pitch: "I'll be your RSA tech layer" — not "download my consumer app"

This is the single most important note on this whole page.

---

## 8. Timeline expectations (realistic, not promises)

- Months 1-3: No profit, validating and building
- Months 4-6: First real paid jobs, likely still net negative
- Months 6-12: Possible operational breakeven (revenue covers running costs) if demand and provider trust hold
- Year 2+: Real profit, if it comes, usually from scale or a B2B/OEM deal — not from consumer volume alone

---

## 9. What to note down right now, this week

1. ☐ Area/city to launch in: _______________
2. ☐ 5 mechanics/providers to visit this week: _______________
3. ☐ React Native or Flutter — pick one: _______________
4. ☐ Set a date to start the PL/pgSQL dispatch schema: _______________
5. ☐ First EV OEM/fleet to research for future partnership: _______________
