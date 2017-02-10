
-- Table: system_settings

-- DROP TABLE system_settings;

CREATE TABLE system_settings (
    id serial NOT NULL PRIMARY KEY,
    key text NOT NULL,
    value text NOT NULL,
    targets text[],
    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
    created_by bigint,
    updated_by bigint,
    status int DEFAULT 1
);


-- Table: gis_country

-- DROP TABLE gis_country;

CREATE TABLE gis_country (
    country_code text NOT NULL,
    iso3 text NOT NULL,
    iso_num int NOT NULL,
    fips text,
    name text NOT NULL,
    capital text,
    area_km2 float,
    population int,
    continent text,
    tld text,
    currency_code text,
    currency_name text,
    phone_code text,
    postal_code_format text,
    postal_code_regex text,
    languages text,
    neighbours text,
    equivalen_fips_code text,
    gis_id bigint,
    metadata jsonb,
    tsv tsvector,
    CONSTRAINT gis_country_pkey PRIMARY KEY(country_code),
    CONSTRAINT gis_country_iso3_unique UNIQUE (iso3),
    CONSTRAINT gis_country_iso_num UNIQUE(iso_num)
);
