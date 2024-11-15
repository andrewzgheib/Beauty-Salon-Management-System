------------------------
-- pgAdmin SQL dump file
------------------------

CREATE EXTENSION IF NOT EXISTS citext;

------------------------
-- ENUMs
------------------------
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'appointment_status') THEN
        CREATE TYPE "public"."appointment_status" AS ENUM (
            'Booked',
            'Completed',
            'Cancelled',
            'Postponed',
            'Other'
        );
    END IF;
END $$;
ALTER TYPE "public"."appointment_status" OWNER TO "postgres";

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'form_type') THEN
        CREATE TYPE "public"."form_type" AS ENUM (
            'Test',
            'Quiz',
            'Survey',
            'Other'
        );
    END IF;
END $$;
ALTER TYPE "public"."form_type" OWNER TO "postgres";

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'transaction_status') THEN
        CREATE TYPE "public"."transaction_status" AS ENUM (
            'Pending',
            'Completed',
            'Failed'
        );
    END IF;
END $$;
ALTER TYPE "public"."transaction_status" OWNER TO "postgres";

------------------------
-- Domains
------------------------
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'name_domain') THEN
        CREATE DOMAIN "public"."name_domain" AS citext
        CHECK(VALUE ~* '^[A-Za-z'' -]+( [A-Za-z'' -]+)*$');
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'pn_domain') THEN
        CREATE DOMAIN "public"."pn_domain" AS citext
        CHECK(VALUE ~* '^[0-9]{7,15}$');
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'email_domain') THEN
        CREATE DOMAIN "public"."email_domain" AS citext
        CHECK(VALUE ~* '^[A-Za-z0-9.-_]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$');
    END IF;
END $$;

------------------------
-- Tables & Sequences
------------------------
CREATE TABLE IF NOT EXISTS public.appointments (
    appointment_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_id integer NOT NULL,
    employee_id integer,
    appointment_date timestamp without time zone NOT NULL,
    appointment_status public.appointment_status NOT NULL,
    is_walk_in boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.appointments OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.appointments_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNER TO postgres;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNED BY public.appointments.appointment_id;


CREATE TABLE IF NOT EXISTS public.attendances (
    attendance_id integer NOT NULL,
    employee_id integer NOT NULL,
    employee_check_in timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_check_out timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.attendances OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.attendances_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNER TO postgres;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNED BY public.attendances.attendance_id;

CREATE TABLE IF NOT EXISTS public.bundle_items (
    bundle_item_id integer NOT NULL,
    bundle_id integer NOT NULL,
    product_id integer NOT NULL,
    bundle_product_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundle_items OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.bundle_items_bundle_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNED BY public.bundle_items.bundle_item_id;

CREATE TABLE IF NOT EXISTS public.bundles (
    bundle_id integer NOT NULL,
    bundle_name character varying(255) NOT NULL,
    bundle_description character varying(255),
    bundle_price money NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.bundles_bundle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNED BY public.bundles.bundle_id;

CREATE TABLE IF NOT EXISTS public.cities (
    city_id integer NOT NULL,
    city_name character varying(255) NOT NULL,
    country_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.cities OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.cities_city_id_seq OWNER TO postgres;
ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;

CREATE TABLE IF NOT EXISTS public.countries (
    country_id integer NOT NULL,
    country_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.countries OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.countries_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.countries_country_id_seq OWNER TO postgres;
ALTER SEQUENCE public.countries_country_id_seq OWNED BY public.countries.country_id;

CREATE TABLE IF NOT EXISTS public.customer_forms (
    customer_form_id integer NOT NULL,
    customer_id integer NOT NULL,
    form_id integer NOT NULL,
    customer_form_time_started timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_form_time_completed timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_forms OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customer_forms_customer_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNED BY public.customer_forms.customer_form_id;

CREATE TABLE IF NOT EXISTS public.customers (
    customer_id integer NOT NULL,
    customer_fn public.name_domain NOT NULL,
    customer_ln public.name_domain NOT NULL,
    customer_email public.email_domain,
    customer_pn public.pn_domain,
    customer_dob date NOT NULL,
    customer_pronoun_id integer NOT NULL,
    customer_city_id integer NOT NULL,
    preferences jsonb,
    promotions boolean DEFAULT false NOT NULL,
    customer_pfp character varying(255),
    is_google boolean DEFAULT false NOT NULL,
    is_apple boolean DEFAULT false NOT NULL,
    is_2fa boolean DEFAULT false NOT NULL,
    customer_registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_last_login timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_customers_auth CHECK ((NOT (is_google AND is_apple)))
);
ALTER TABLE public.customers OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;

CREATE TABLE IF NOT EXISTS public.customer_pronouns (
    customer_pronoun_id integer NOT NULL,
    customer_id integer NOT NULL,
    pronoun_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_pronouns OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customer_pronouns_customer_pronoun_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_pronouns_customer_pronoun_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_pronouns_customer_pronoun_id_seq OWNED BY public.customer_pronouns.customer_pronoun_id;

CREATE TABLE IF NOT EXISTS public.discounts (
    discount_id integer NOT NULL,
    product_id integer NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    discount_start_date timestamp without time zone NOT NULL,
    discount_end_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.discounts OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.discounts_discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.discounts_discount_id_seq OWNER TO postgres;
ALTER SEQUENCE public.discounts_discount_id_seq OWNED BY public.discounts.discount_id;

CREATE TABLE IF NOT EXISTS public.employee_pronouns (
    employee_pronoun_id integer NOT NULL,
    employee_id integer NOT NULL,
    pronoun_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_pronouns OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_pronouns_employee_pronoun_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employee_pronouns_employee_pronoun_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_pronouns_employee_pronoun_id_seq OWNED BY public.employee_pronouns.employee_pronoun_id;

CREATE TABLE IF NOT EXISTS public.employee_reviews (
    employee_review_id integer NOT NULL,
    employee_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_stars_count integer NOT NULL,
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_reviews_employee_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNED BY public.employee_reviews.employee_review_id;

CREATE TABLE IF NOT EXISTS public.employee_roles (
    employee_role_id integer NOT NULL,
    employee_id integer NOT NULL,
    role_id integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_roles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_roles_employee_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNED BY public.employee_roles.employee_role_id;

CREATE TABLE IF NOT EXISTS public.employees (
    employee_id integer NOT NULL,
    employee_fn public.name_domain,
    employee_ln public.name_domain NOT NULL,
    employee_email public.email_domain,
    employee_pn public.pn_domain,
    employee_dob date NOT NULL,
    employee_pronoun_id integer NOT NULL,
    employee_city_id integer NOT NULL,
    employee_pfp character varying(255),
    employee_role_id integer NOT NULL,
    hire_date date NOT NULL,
    employee_registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_last_login timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employees OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;

CREATE TABLE IF NOT EXISTS public.form_types (
    form_type_id integer NOT NULL,
    form_type public.form_type,
    form_type_description text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.form_types OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.form_types_form_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNER TO postgres;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNED BY public.form_types.form_type_id;

CREATE TABLE IF NOT EXISTS public.forms (
    form_id integer NOT NULL,
    form_name character varying(255) NOT NULL,
    form_description character varying(255),
    form_type_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.forms OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.forms_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.forms_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.forms_form_id_seq OWNED BY public.forms.form_id;

CREATE TABLE IF NOT EXISTS public.inventory (
    inventory_id integer NOT NULL,
    product_id integer NOT NULL,
    production_date date,
    expiry_date date,
    stock_in_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stock_out_date date,
    is_restocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.inventory OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.inventory_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNER TO postgres;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNED BY public.inventory.inventory_id;

CREATE TABLE IF NOT EXISTS public.product_brands (
    product_brand_id integer NOT NULL,
    product_brand character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_brands OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_brands_product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNED BY public.product_brands.product_brand_id;

CREATE TABLE IF NOT EXISTS public.product_categories (
    product_category_id integer NOT NULL,
    product_category character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_categories_product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNED BY public.product_categories.product_category_id;

CREATE TABLE IF NOT EXISTS public.product_favorites (
    product_favorite_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_favorites OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_favorites_product_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNED BY public.product_favorites.product_favorite_id;

CREATE TABLE IF NOT EXISTS public.product_reviews (
    product_review_id integer NOT NULL,
    product_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_stars_count integer NOT NULL,
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_reviews_product_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNED BY public.product_reviews.product_review_id;

CREATE TABLE IF NOT EXISTS public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    product_description character varying(255),
    product_price money NOT NULL,
    product_brand_id integer NOT NULL,
    product_category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.products OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;
ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;

CREATE TABLE IF NOT EXISTS public.pronouns(
    pronoun_id integer NOT NULL,
    pronoun character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.pronouns OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.pronouns_pronoun_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.pronouns_pronoun_id_seq OWNER TO postgres;
ALTER SEQUENCE public.pronouns_pronoun_id_seq OWNED BY public.pronouns.pronoun_id;

CREATE TABLE IF NOT EXISTS public.roles (
    role_id integer NOT NULL,
    role_name character varying(255) NOT NULL,
    role_description character varying(255),
    role_salary numeric NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone
);
ALTER TABLE public.roles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;

CREATE TABLE IF NOT EXISTS public.service_categories (
    service_category_id integer NOT NULL,
    service_category_name character varying(255) NOT NULL,
    service_category_description character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_categories_service_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNED BY public.service_categories.service_category_id;

CREATE TABLE IF NOT EXISTS public.service_favorites (
    service_favorite_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_id integer NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_favorites OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_favorites_service_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNED BY public.service_favorites.service_favorite_id;

CREATE TABLE IF NOT EXISTS public.service_reviews (
    service_review_id integer NOT NULL,
    service_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_stars_count integer NOT NULL,
    customer_service_review text,
    customer_service_review_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_reviews_service_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNED BY public.service_reviews.service_review_id;

CREATE TABLE IF NOT EXISTS public.services (
    service_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    service_description character varying(255),
    service_price money,
    service_category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.services OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_service_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_service_id_seq OWNED BY public.services.service_id;

CREATE TABLE IF NOT EXISTS public.transaction_categories (
    transaction_category_id integer NOT NULL,
    transaction_category character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.transaction_categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.transaction_categories_transaction_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transaction_categories_transaction_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.transaction_categories_transaction_category_id_seq OWNED BY public.transaction_categories.transaction_category_id;

CREATE TABLE IF NOT EXISTS public.transaction_types (
    transaction_type_id integer NOT NULL,
    transaction_type character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.transaction_types OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.transaction_types_transaction_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNER TO postgres;
ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNED BY public.transaction_types.transaction_type_id;

CREATE TABLE IF NOT EXISTS public.transactions (
    transaction_id integer NOT NULL,
    customer_id integer NOT NULL,
    transaction_category_id integer NOT NULL,
    transaction_price money NOT NULL,
    transaction_type_id integer NOT NULL,
    transaction_time timestamp without time zone NOT NULL,
    transaction_status public.transaction_status NOT NULL,
    is_deposit boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.transactions OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;
ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


ALTER TABLE ONLY public.appointments ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointments_appointment_id_seq'::regclass);
ALTER TABLE ONLY public.attendances ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendances_attendance_id_seq'::regclass);
ALTER TABLE ONLY public.bundle_items ALTER COLUMN bundle_item_id SET DEFAULT nextval('public.bundle_items_bundle_item_id_seq'::regclass);
ALTER TABLE ONLY public.bundles ALTER COLUMN bundle_id SET DEFAULT nextval('public.bundles_bundle_id_seq'::regclass);
ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);
ALTER TABLE ONLY public.countries ALTER COLUMN country_id SET DEFAULT nextval('public.countries_country_id_seq'::regclass);
ALTER TABLE ONLY public.customer_forms ALTER COLUMN customer_form_id SET DEFAULT nextval('public.customer_forms_customer_form_id_seq'::regclass);
ALTER TABLE ONLY public.customer_pronouns ALTER COLUMN customer_pronoun_id SET DEFAULT nextval('public.customer_pronouns_customer_pronoun_id_seq'::regclass);
ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);
ALTER TABLE ONLY public.discounts ALTER COLUMN discount_id SET DEFAULT nextval('public.discounts_discount_id_seq'::regclass);
ALTER TABLE ONLY public.employee_pronouns ALTER COLUMN employee_pronoun_id SET DEFAULT nextval('public.employee_pronouns_employee_pronoun_id_seq'::regclass);
ALTER TABLE ONLY public.employee_reviews ALTER COLUMN employee_review_id SET DEFAULT nextval('public.employee_reviews_employee_review_id_seq'::regclass);
ALTER TABLE ONLY public.employee_roles ALTER COLUMN employee_role_id SET DEFAULT nextval('public.employee_roles_employee_role_id_seq'::regclass);
ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);
ALTER TABLE ONLY public.form_types ALTER COLUMN form_type_id SET DEFAULT nextval('public.form_types_form_type_id_seq'::regclass);
ALTER TABLE ONLY public.forms ALTER COLUMN form_id SET DEFAULT nextval('public.forms_form_id_seq'::regclass);
ALTER TABLE ONLY public.inventory ALTER COLUMN inventory_id SET DEFAULT nextval('public.inventory_inventory_id_seq'::regclass);
ALTER TABLE ONLY public.product_brands ALTER COLUMN product_brand_id SET DEFAULT nextval('public.product_brands_product_brand_id_seq'::regclass);
ALTER TABLE ONLY public.product_categories ALTER COLUMN product_category_id SET DEFAULT nextval('public.product_categories_product_category_id_seq'::regclass);
ALTER TABLE ONLY public.product_favorites ALTER COLUMN product_favorite_id SET DEFAULT nextval('public.product_favorites_product_favorite_id_seq'::regclass);
ALTER TABLE ONLY public.product_reviews ALTER COLUMN product_review_id SET DEFAULT nextval('public.product_reviews_product_review_id_seq'::regclass);
ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
ALTER TABLE ONLY public.pronouns ALTER COLUMN pronoun_id SET DEFAULT nextval('public.pronouns_pronoun_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);
ALTER TABLE ONLY public.service_categories ALTER COLUMN service_category_id SET DEFAULT nextval('public.service_categories_service_category_id_seq'::regclass);
ALTER TABLE ONLY public.service_favorites ALTER COLUMN service_favorite_id SET DEFAULT nextval('public.service_favorites_service_favorite_id_seq'::regclass);
ALTER TABLE ONLY public.service_reviews ALTER COLUMN service_review_id SET DEFAULT nextval('public.service_reviews_service_review_id_seq'::regclass);
ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.service_service_id_seq'::regclass);
ALTER TABLE ONLY public.transaction_categories ALTER COLUMN transaction_category_id SET DEFAULT nextval('public.transaction_categories_transaction_category_id_seq'::regclass);
ALTER TABLE ONLY public.transaction_types ALTER COLUMN transaction_type_id SET DEFAULT nextval('public.transaction_types_transaction_type_id_seq'::regclass);
ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);

SELECT pg_catalog.setval('public.appointments_appointment_id_seq', 1, false);
SELECT pg_catalog.setval('public.attendances_attendance_id_seq', 1, false);
SELECT pg_catalog.setval('public.bundle_items_bundle_item_id_seq', 1, false);
SELECT pg_catalog.setval('public.bundles_bundle_id_seq', 1, false);
SELECT pg_catalog.setval('public.cities_city_id_seq', 1, false);
SELECT pg_catalog.setval('public.countries_country_id_seq', 1, false);
SELECT pg_catalog.setval('public.customer_forms_customer_form_id_seq', 1, false);
SELECT pg_catalog.setval('public.customer_pronouns_customer_pronoun_id_seq', 1, false);
SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);
SELECT pg_catalog.setval('public.discounts_discount_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_pronouns_employee_pronoun_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_reviews_employee_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_roles_employee_role_id_seq', 1, false);
SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);
SELECT pg_catalog.setval('public.form_types_form_type_id_seq', 1, false);
SELECT pg_catalog.setval('public.forms_form_id_seq', 1, false);
SELECT pg_catalog.setval('public.inventory_inventory_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_brands_product_brand_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_categories_product_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_favorites_product_favorite_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_reviews_product_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);
SELECT pg_catalog.setval('public.pronouns_pronoun_id_seq', 1, false);
SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_categories_service_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_favorites_service_favorite_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_reviews_service_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_service_id_seq', 1, false);
SELECT pg_catalog.setval('public.transaction_categories_transaction_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.transaction_types_transaction_type_id_seq', 1, false);
SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 1, false);

------------------------
-- Primary Keys
------------------------
ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);
ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (attendance_id);
ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT bundle_items_pkey PRIMARY KEY (bundle_item_id);
ALTER TABLE ONLY public.bundles
    ADD CONSTRAINT bundles_pkey PRIMARY KEY (bundle_id);
ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);
ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);
ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT customer_forms_pkey PRIMARY KEY (customer_form_id);
ALTER TABLE ONLY public.customer_pronouns
    ADD CONSTRAINT customer_pronouns_pkey PRIMARY KEY (customer_pronoun_id);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (discount_id);
ALTER TABLE ONLY public.employee_pronouns
    ADD CONSTRAINT employee_pronouns_pkey PRIMARY KEY (employee_pronoun_id);
ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT employee_reviews_pkey PRIMARY KEY (employee_review_id);
ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT employee_roles_pkey PRIMARY KEY (employee_role_id);
ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);
ALTER TABLE ONLY public.form_types
    ADD CONSTRAINT form_types_pkey PRIMARY KEY (form_type_id);
ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);
ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);
ALTER TABLE ONLY public.product_brands
    ADD CONSTRAINT product_brands_pkey PRIMARY KEY (product_brand_id);
ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (product_category_id);
ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT product_favorites_pkey PRIMARY KEY (product_favorite_id);
ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (product_review_id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
ALTER TABLE ONLY public.pronouns
    ADD CONSTRAINT pronouns_pkey PRIMARY KEY (pronoun_id);
ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);
ALTER TABLE ONLY public.service_categories
    ADD CONSTRAINT service_categories_pkey PRIMARY KEY (service_category_id);
ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT service_favorites_pkey PRIMARY KEY (service_favorite_id);
ALTER TABLE ONLY public.services
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);
ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (service_review_id);
ALTER TABLE ONLY public.transaction_categories
    ADD CONSTRAINT transaction_categories_pkey PRIMARY KEY (transaction_category_id);
ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (transaction_type_id);
ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);

------------------------
-- Uniques
------------------------
ALTER TABLE ONLY public.bundles
    ADD CONSTRAINT uq_bundles_bundle_name UNIQUE (bundle_name);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT uq_customers_customer_email UNIQUE (customer_email);
ALTER TABLE ONLY public.forms
    ADD CONSTRAINT uq_forms_form_name UNIQUE (form_name);
ALTER TABLE ONLY public.pronouns
    ADD CONSTRAINT uq_pronouns_pronoun UNIQUE (pronoun);
ALTER TABLE ONLY public.roles
    ADD CONSTRAINT uq_roles_role_name UNIQUE (role_name);
ALTER TABLE ONLY public.services
    ADD CONSTRAINT uq_services_service_name UNIQUE (service_name);

------------------------
-- Indexes
------------------------
CREATE INDEX idx_employees_employee_role_id ON public.employees USING btree (employee_role_id);
CREATE INDEX idx_customers_address ON public.customers USING btree (customer_city_id);
CREATE INDEX idx_customers_customer_dob ON public.customers USING btree (customer_dob);
CREATE INDEX idx_customers_customer_pronoun_id ON public.customers USING btree (customer_pronoun_id);
CREATE INDEX idx_customers_preferences ON public.customers USING btree (preferences);
CREATE INDEX idx_employee_reviews_employee_id ON public.employee_reviews USING btree (employee_id);
CREATE INDEX idx_employee_reviews_employee_stars_count ON public.employee_reviews USING btree (employee_stars_count);
CREATE INDEX idx_employee_roles_employee_id ON public.employee_roles USING btree (employee_id);
CREATE INDEX idx_employee_roles_role_id ON public.employee_roles USING btree (role_id);
CREATE INDEX idx_employees_employee_address_id ON public.employees USING btree (employee_city_id);
CREATE INDEX idx_employees_role_id ON public.employees USING btree (employee_role_id);
CREATE INDEX idx_inventory_inventory_id ON public.inventory USING btree (inventory_id);
CREATE INDEX idx_inventory_is_restocked ON public.inventory USING btree (is_restocked);
CREATE INDEX idx_inventory_product_id ON public.inventory USING btree (product_id);
CREATE INDEX idx_inventory_stock_out_date ON public.inventory USING btree (stock_out_date);
CREATE INDEX idx_product_reviews_product_id ON public.product_reviews USING btree (product_id);
CREATE INDEX idx_product_reviews_product_stars_count ON public.product_reviews USING btree (product_stars_count);
CREATE INDEX idx_products_product_price ON public.products USING btree (product_price);
CREATE INDEX idx_service_reviews_service_id ON public.service_reviews USING btree (service_id);
CREATE INDEX idx_service_reviews_service_stars_count ON public.service_reviews USING btree (service_stars_count);
CREATE INDEX idx_services_service_category_id ON public.services USING btree (service_category_id);
CREATE INDEX idx_services_service_price ON public.services USING btree (service_price);

------------------------
-- Foreign Keys
------------------------
ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_attendances_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT fk_bundle_items_bundle_id FOREIGN KEY (bundle_id) REFERENCES public.bundles(bundle_id);
ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT fk_bundle_items_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_cities_country_id FOREIGN KEY (country_id) REFERENCES public.countries(country_id);
ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT fk_customer_forms_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT fk_customer_forms_form_id FOREIGN KEY (form_id) REFERENCES public.forms(form_id);
ALTER TABLE ONLY public.customer_pronouns
    ADD CONSTRAINT fk_customer_pronouns_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.customer_pronouns
    ADD CONSTRAINT fk_customer_pronouns_pronoun_id FOREIGN KEY (pronoun_id) REFERENCES public.pronouns(pronoun_id);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customers_customer_city_id FOREIGN KEY (customer_city_id) REFERENCES public.cities(city_id);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customers_customer_pronoun_id FOREIGN KEY (customer_pronoun_id) REFERENCES public.customer_pronouns(customer_pronoun_id);
ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT fk_discounts_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
ALTER TABLE ONLY public.employee_pronouns
    ADD CONSTRAINT fk_employee_pronouns_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
ALTER TABLE ONLY public.employee_pronouns
    ADD CONSTRAINT fk_employee_pronouns_pronoun_id FOREIGN KEY (pronoun_id) REFERENCES public.pronouns(pronoun_id);
ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT fk_employee_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT fk_employee_reviews_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT fk_employee_roles_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT fk_employee_roles_role_id FOREIGN KEY (role_id) REFERENCES public.roles(role_id);
ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_employee_city_id FOREIGN KEY (employee_city_id) REFERENCES public.cities(city_id);
ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_employee_pronoun_id FOREIGN KEY (employee_pronoun_id) REFERENCES public.employee_pronouns(employee_pronoun_id);
ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_employee_role_id FOREIGN KEY (employee_role_id) REFERENCES public.employee_roles(employee_role_id);
ALTER TABLE ONLY public.forms
    ADD CONSTRAINT fk_forms_form_type_id FOREIGN KEY (form_type_id) REFERENCES public.form_types(form_type_id);
ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT fk_product_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT fk_product_favorites_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT fk_product_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT fk_product_reviews_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_product_brand_id FOREIGN KEY (product_brand_id) REFERENCES public.product_brands(product_brand_id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_product_category_id FOREIGN KEY (product_category_id) REFERENCES public.product_categories(product_category_id);
ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT fk_service_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT fk_service_favorites_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT fk_service_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT fk_service_reviews_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_services_service_category_id FOREIGN KEY (service_category_id) REFERENCES public.service_categories(service_category_id);
ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_transaction_category_id_id FOREIGN KEY (transaction_category_id) REFERENCES public.transaction_categories(transaction_category_id);
ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_transaction_type_id FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_types(transaction_type_id);