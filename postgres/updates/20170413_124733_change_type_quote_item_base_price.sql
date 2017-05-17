ALTER TABLE vv.quote_item ALTER COLUMN base_price TYPE double precision USING (base_price::double precision);
