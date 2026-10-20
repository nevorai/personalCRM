# Nevorai CRM: overlap audit and core plan (2026-10-20)

Method: compared table names (migrations) and screens of Agencies (~/nevorai-agency, 95 migrations), Academy OS (~/academyos, 160) and Cafe OS (~/cafe-os, 13). Table and screen level only, not a line-by-line code read.

## What all three already have (the core)
| Piece | Agencies | Academy OS | Cafe OS |
|---|---|---|---|
| Tenants + platform admin | tenants, tenant_members, platform_admins | tenants, platform_admins | tenants, platform_admins |
| People / profiles | employees, profiles | profiles, students, user_roles | profiles, staff_members |
| Roles and permissions | roles, role_capabilities, employee_roles | user_roles, staff_invitations | (basic) |
| Leads | leads | leads, registrations | none |
| Attendance | attendance (+ QR, WFH, shifts) | attendance_marks, attendance_qr_scans | attendance, staff_attendance |
| Notifications / push | notifications, push_subscriptions | notifications, notification_outbox, push_devices | none |
| Site content / branding | company_brand | site_content, branding | site_content |
| Reports | views, targets | dashboard.reports, insights | ai_briefs |

## What is different (these become packs)
- Agencies: clients, content items and review, pages and reels, shoots, workflows, HR (leave, letters, exit, salary), incentives, chat.
- Academy OS: students, batches, fee plans, fees, admissions, coaches, Match Centre (cricket scoring, tournaments), automation rules, communications.
- Cafe OS: tables, menu, orders, recipes, inventory, expenses.

## Biggest finding: the stacks differ
- Agencies = Vite + React, schema `agency` in the Nevorai OS database.
- Academy OS = TanStack Start + Bun, own tables.
- Cafe OS = a third setup.
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
Flow, Connect, Store, Bookings, Courses (not CRMs).

## Open questions for Adarsh
- Which business types come after Agencies: Academies first? Coaching centres need only a pack on Academy OS.
- Academy and Cafe prices (needed before their sales pages).
- Cafe OS has no leads or notifications, so it is the smallest pack; confirm it is in the CRM family at all.
