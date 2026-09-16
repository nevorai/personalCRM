-- Which Nevorai product a client's site/app actually is, and its tenant id
-- inside that product. Tagging these two lets the CRM answer "how much MRR
-- does Academy OS make" and lets a Razorpay subscription be matched back to
-- the tenant record without a human remembering the mapping.
--
-- Deliberately NOT here: anything about money the tenant collects from its
-- own customers (parents paying an academy). That money never touches this
-- database. Only the tenant -> Nevorai subscription belongs in the CRM.

alter table crm_products add column if not exists platform text;
alter table crm_products add column if not exists tenant_id text;

create index if not exists idx_crm_products_tenant on crm_products(platform, tenant_id)
  where tenant_id is not null;
