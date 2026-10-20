# Nevorai CRM: overlap audit and core plan (2026-10-20)

Method: compared table names (migrations) and screens of Agencies (~/nevorai-agency, 95 migrations), Academy OS (~/academyos, 160). Cafe OS is a dropped product and is left out. Table and screen level only, not a line-by-line code read.

## What both already have (the core)
| Piece | Agencies | Academy OS |
|---|---|---|
| Tenants + platform admin | tenants, tenant_members, platform_admins | tenants, platform_admins |
| People / profiles | employees, profiles | profiles, students, user_roles |
| Roles and permissions | roles, role_capabilities, employee_roles | user_roles, staff_invitations |
| Leads | leads | leads, registrations |
| Attendance | attendance (+ QR, WFH, shifts) | attendance_marks, attendance_qr_scans |
| Notifications / push | notifications, push_subscriptions | notifications, notification_outbox, push_devices |
| Site content / branding | company_brand | site_content, branding |
| Reports | views, targets | dashboard.reports, insights |

## What is different (these become packs)
- Agencies: clients, content items and review, pages and reels, shoots, workflows, HR (leave, letters, exit, salary), incentives, chat.
- Academy OS: students, batches, fee plans, fees, admissions, coaches, Match Centre (cricket scoring, tournaments), automation rules, communications.

## Biggest finding: the stacks differ
- Agencies = Vite + React, schema `agency` in the Nevorai OS database.
- Academy OS = TanStack Start + Bun, own tables.
So "one core" cannot mean copying a shared folder today. Each shared piece has to be extracted as a database contract (the same tables and functions in every schema) plus a small UI kit, one piece at a time.

## Order of extraction (each step tested, live apps untouched until a step passes)
1. Tenant + roles + capabilities contract (the table shape and `has_capability()` function). Lowest risk, every pack needs it.
2. Leads (one table shape; Agencies and Academy already have `leads`).
3. Notifications + push (same shape in both).
4. Attendance (QR, shifts): the biggest duplicate.
5. Payments to the business: Academy's fee/payment tables, pointed at the tenant's own Razorpay (money boundary).
6. Reports shell.
Plan billing already goes through Kaizen for every product, so nothing to extract there. Check that Academy's `billing_subscriptions` / `billing_charges` are for student fees and not Nevorai plans; if they are Nevorai plans, move them to Kaizen.

## Do not touch
Flow, Connect, Store, Bookings, Courses (not CRMs). Cafe OS: dropped, on hold, no clients, not on the website.

## Business types (Adarsh, 2026-10-20)
- Agencies: live first.
- Academies: the product is not finished yet. Finish it first; price and sales page come after.
- Coaching centres: not built, not pending. Nothing to do.
- Cafes: dropped product, on hold. Never mention it.
