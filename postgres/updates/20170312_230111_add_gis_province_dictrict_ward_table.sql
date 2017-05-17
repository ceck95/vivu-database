/**
* @Author: Tran Van Nhut <nhutdev>
* @Date:   2017-03-12T23:01:12+07:00
* @Email:  tranvannhut4495@gmail.com
* @Last modified by:   nhutdev
* @Last modified time: 2017-03-12T23:01:33+07:00
*/



-- Table: gis_province

-- DROP TABLE gis_province;

CREATE TABLE gis_province (
    country_code text,
    province_code text,
    name text NOT NULL,
    name_ascii text,
    type text,
    gis_id bigint,
    metadata jsonb,
    tsv tsvector,
  CONSTRAINT gis_province_pkey PRIMARY KEY (country_code, province_code)
);

-- Table: gis_district

-- DROP TABLE gis_district;

CREATE TABLE gis_district (
    country_code text NOT NULL,
    province_code text NOT NULL,
    district_code text NOT NULL,
    name text NOT NULL,
    name_ascii text,
    type text,
    location text,
    latitude decimal(8,6),
    longitude decimal(9,6),

    gis_id bigint,
    metadata jsonb,
    tsv tsvector,
  CONSTRAINT gis_district_pkey PRIMARY KEY (country_code, province_code, district_code)
);

-- Table: gis_ward

-- DROP TABLE gis_ward;

CREATE TABLE gis_ward (
    uid serial NOT NULL,
    country_code text NOT NULL,
    province_code text,
    district_code text,
    ward_code text,
    name text NOT NULL,
    name_ascii text,
    type text,
    location text,
    latitude decimal(8,6),
    longitude decimal(9,6),

    gis_id bigint,
    metadata jsonb,
    tsv tsvector,
  CONSTRAINT gis_ward_pkey PRIMARY KEY (uid)
);
