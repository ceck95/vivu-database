/*
* @Author: toan.nguyen
* @Date:   2016-10-26 16:03:03
* @Last Modified by:   toan.nguyen
* @Last Modified time: 2016-10-26 16:03:12
*/

DROP SEQUENCE IF EXISTS public.discount_beta_code_seq;
--DELIMITER
CREATE SEQUENCE public.discount_beta_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--DELIMITER

--
-- Name: public.discount_beta_code_generator(); Type: FUNCTION; Schema: public;
--

CREATE OR REPLACE FUNCTION public.discount_beta_code_generator(OUT result text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- the id of this DB shard, must be set for each
    -- schema shard you have - you could pass this as a parameter too
    seq_id bigint;
    prefix text := 'GVN1DB';
BEGIN
    SELECT nextval('public.discount_beta_code_seq') INTO seq_id;

    IF seq_id < 100000 THEN
        result := prefix || LPAD(seq_id::text, 5, '0');
        ELSE
        result := prefix || seq_id::text;
        END IF;
END;
$$;
