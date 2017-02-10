/*
* @Author: chienpm
* @Date:   2016-07-12 10:51:47
* @Last Modified by:   chienpm
* @Last Modified time: 2016-07-12 11:43:07
*/

CREATE SCHEMA IF NOT EXISTS hc;

CREATE SEQUENCE hc.global_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: id_generator(); Type: FUNCTION; Schema: public; Owner: eateruser
--

CREATE FUNCTION hc.id_generator(OUT result bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    our_epoch bigint := 1314220021721;
    seq_id bigint;
    now_millis bigint;
    -- the id of this DB shard, must be set for each
    -- schema shard you have - you could pass this as a parameter too
    shard_id int := 1;
BEGIN
    SELECT nextval('hc.global_id_sequence') % 1024 INTO seq_id;

    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
    result := (now_millis - our_epoch) << 23;
    result := result | (shard_id << 10);
    result := result | (seq_id);
END;
$$;
