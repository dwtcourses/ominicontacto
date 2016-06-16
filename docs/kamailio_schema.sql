--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: concat(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION concat(text, text) RETURNS text
    LANGUAGE sql
    AS $_$SELECT $1 || $2;$_$;


ALTER FUNCTION public.concat(text, text) OWNER TO postgres;

--
-- Name: rand(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rand() RETURNS double precision
    LANGUAGE sql
    AS $$SELECT random();$$;


ALTER FUNCTION public.rand() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acc (
    id integer NOT NULL,
    method character varying(16) DEFAULT ''::character varying NOT NULL,
    from_tag character varying(64) DEFAULT ''::character varying NOT NULL,
    to_tag character varying(64) DEFAULT ''::character varying NOT NULL,
    callid character varying(255) DEFAULT ''::character varying NOT NULL,
    sip_code character varying(3) DEFAULT ''::character varying NOT NULL,
    sip_reason character varying(128) DEFAULT ''::character varying NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.acc OWNER TO postgres;

--
-- Name: acc_cdrs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_cdrs (
    id integer NOT NULL,
    start_time timestamp without time zone DEFAULT '2000-01-01 00:00:00'::timestamp without time zone NOT NULL,
    end_time timestamp without time zone DEFAULT '2000-01-01 00:00:00'::timestamp without time zone NOT NULL,
    duration real DEFAULT 0 NOT NULL
);


ALTER TABLE public.acc_cdrs OWNER TO postgres;

--
-- Name: acc_cdrs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE acc_cdrs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.acc_cdrs_id_seq OWNER TO postgres;

--
-- Name: acc_cdrs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE acc_cdrs_id_seq OWNED BY acc_cdrs.id;


--
-- Name: acc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE acc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.acc_id_seq OWNER TO postgres;

--
-- Name: acc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE acc_id_seq OWNED BY acc.id;


--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    grp integer DEFAULT 1 NOT NULL,
    ip_addr character varying(50) NOT NULL,
    mask integer DEFAULT 32 NOT NULL,
    port smallint DEFAULT 0 NOT NULL,
    tag character varying(64)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: aliases; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aliases (
    id integer NOT NULL,
    ruid character varying(64) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT NULL::character varying,
    contact character varying(255) DEFAULT ''::character varying NOT NULL,
    received character varying(128) DEFAULT NULL::character varying,
    path character varying(512) DEFAULT NULL::character varying,
    expires timestamp without time zone DEFAULT '2030-05-28 21:32:15'::timestamp without time zone NOT NULL,
    q real DEFAULT 1.0 NOT NULL,
    callid character varying(255) DEFAULT 'Default-Call-ID'::character varying NOT NULL,
    cseq integer DEFAULT 1 NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    cflags integer DEFAULT 0 NOT NULL,
    user_agent character varying(255) DEFAULT ''::character varying NOT NULL,
    socket character varying(64) DEFAULT NULL::character varying,
    methods integer,
    instance character varying(255) DEFAULT NULL::character varying,
    reg_id integer DEFAULT 0 NOT NULL,
    server_id integer DEFAULT 0 NOT NULL,
    connection_id integer DEFAULT 0 NOT NULL,
    keepalive integer DEFAULT 0 NOT NULL,
    partition integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.aliases OWNER TO postgres;

--
-- Name: aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aliases_id_seq OWNER TO postgres;

--
-- Name: aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aliases_id_seq OWNED BY aliases.id;


--
-- Name: carrier_name; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE carrier_name (
    id integer NOT NULL,
    carrier character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE public.carrier_name OWNER TO postgres;

--
-- Name: carrier_name_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE carrier_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrier_name_id_seq OWNER TO postgres;

--
-- Name: carrier_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE carrier_name_id_seq OWNED BY carrier_name.id;


--
-- Name: carrierfailureroute; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE carrierfailureroute (
    id integer NOT NULL,
    carrier integer DEFAULT 0 NOT NULL,
    domain integer DEFAULT 0 NOT NULL,
    scan_prefix character varying(64) DEFAULT ''::character varying NOT NULL,
    host_name character varying(128) DEFAULT ''::character varying NOT NULL,
    reply_code character varying(3) DEFAULT ''::character varying NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    mask integer DEFAULT 0 NOT NULL,
    next_domain integer DEFAULT 0 NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.carrierfailureroute OWNER TO postgres;

--
-- Name: carrierfailureroute_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE carrierfailureroute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrierfailureroute_id_seq OWNER TO postgres;

--
-- Name: carrierfailureroute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE carrierfailureroute_id_seq OWNED BY carrierfailureroute.id;


--
-- Name: carrierroute; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE carrierroute (
    id integer NOT NULL,
    carrier integer DEFAULT 0 NOT NULL,
    domain integer DEFAULT 0 NOT NULL,
    scan_prefix character varying(64) DEFAULT ''::character varying NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    mask integer DEFAULT 0 NOT NULL,
    prob real DEFAULT 0 NOT NULL,
    strip integer DEFAULT 0 NOT NULL,
    rewrite_host character varying(128) DEFAULT ''::character varying NOT NULL,
    rewrite_prefix character varying(64) DEFAULT ''::character varying NOT NULL,
    rewrite_suffix character varying(64) DEFAULT ''::character varying NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.carrierroute OWNER TO postgres;

--
-- Name: carrierroute_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE carrierroute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrierroute_id_seq OWNER TO postgres;

--
-- Name: carrierroute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE carrierroute_id_seq OWNED BY carrierroute.id;


--
-- Name: cdr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cdr (
    id integer NOT NULL,
    calldate timestamp with time zone DEFAULT now() NOT NULL,
    clid character varying(80),
    src character varying(80),
    dst character varying(80),
    dcontext character varying(80),
    channel character varying(80),
    dstchannel character varying(80),
    lastapp character varying(80),
    lastdata character varying(80),
    duration integer DEFAULT 0 NOT NULL,
    billsec integer DEFAULT 0 NOT NULL,
    disposition character varying(45),
    amaflags integer DEFAULT 0 NOT NULL,
    accountcode character varying(20),
    uniqueid character varying(150),
    userfield character varying(255)
);


ALTER TABLE public.cdr OWNER TO postgres;

--
-- Name: cdr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cdr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cdr_id_seq OWNER TO postgres;

--
-- Name: cdr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cdr_id_seq OWNED BY cdr.id;


--
-- Name: cpl; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cpl (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    cpl_xml text,
    cpl_bin text
);


ALTER TABLE public.cpl OWNER TO postgres;

--
-- Name: cpl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cpl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpl_id_seq OWNER TO postgres;

--
-- Name: cpl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cpl_id_seq OWNED BY cpl.id;


--
-- Name: dbaliases; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dbaliases (
    id integer NOT NULL,
    alias_username character varying(64) DEFAULT ''::character varying NOT NULL,
    alias_domain character varying(64) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.dbaliases OWNER TO postgres;

--
-- Name: dbaliases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dbaliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dbaliases_id_seq OWNER TO postgres;

--
-- Name: dbaliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dbaliases_id_seq OWNED BY dbaliases.id;


--
-- Name: dialog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dialog (
    id integer NOT NULL,
    hash_entry integer NOT NULL,
    hash_id integer NOT NULL,
    callid character varying(255) NOT NULL,
    from_uri character varying(128) NOT NULL,
    from_tag character varying(64) NOT NULL,
    to_uri character varying(128) NOT NULL,
    to_tag character varying(64) NOT NULL,
    caller_cseq character varying(20) NOT NULL,
    callee_cseq character varying(20) NOT NULL,
    caller_route_set character varying(512),
    callee_route_set character varying(512),
    caller_contact character varying(128) NOT NULL,
    callee_contact character varying(128) NOT NULL,
    caller_sock character varying(64) NOT NULL,
    callee_sock character varying(64) NOT NULL,
    state integer NOT NULL,
    start_time integer NOT NULL,
    timeout integer DEFAULT 0 NOT NULL,
    sflags integer DEFAULT 0 NOT NULL,
    iflags integer DEFAULT 0 NOT NULL,
    toroute_name character varying(32),
    req_uri character varying(128) NOT NULL,
    xdata character varying(512)
);


ALTER TABLE public.dialog OWNER TO postgres;

--
-- Name: dialog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dialog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dialog_id_seq OWNER TO postgres;

--
-- Name: dialog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dialog_id_seq OWNED BY dialog.id;


--
-- Name: dialog_vars; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dialog_vars (
    id integer NOT NULL,
    hash_entry integer NOT NULL,
    hash_id integer NOT NULL,
    dialog_key character varying(128) NOT NULL,
    dialog_value character varying(512) NOT NULL
);


ALTER TABLE public.dialog_vars OWNER TO postgres;

--
-- Name: dialog_vars_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dialog_vars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dialog_vars_id_seq OWNER TO postgres;

--
-- Name: dialog_vars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dialog_vars_id_seq OWNED BY dialog_vars.id;


--
-- Name: dialplan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dialplan (
    id integer NOT NULL,
    dpid integer NOT NULL,
    pr integer NOT NULL,
    match_op integer NOT NULL,
    match_exp character varying(64) NOT NULL,
    match_len integer NOT NULL,
    subst_exp character varying(64) NOT NULL,
    repl_exp character varying(64) NOT NULL,
    attrs character varying(64) NOT NULL
);


ALTER TABLE public.dialplan OWNER TO postgres;

--
-- Name: dialplan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dialplan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dialplan_id_seq OWNER TO postgres;

--
-- Name: dialplan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dialplan_id_seq OWNED BY dialplan.id;


--
-- Name: dispatcher; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dispatcher (
    id integer NOT NULL,
    setid integer DEFAULT 0 NOT NULL,
    destination character varying(192) DEFAULT ''::character varying NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attrs character varying(128) DEFAULT ''::character varying NOT NULL,
    description character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.dispatcher OWNER TO postgres;

--
-- Name: dispatcher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dispatcher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dispatcher_id_seq OWNER TO postgres;

--
-- Name: dispatcher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dispatcher_id_seq OWNED BY dispatcher.id;


--
-- Name: domain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain (
    id integer NOT NULL,
    domain character varying(64) NOT NULL,
    did character varying(64) DEFAULT NULL::character varying,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.domain OWNER TO postgres;

--
-- Name: domain_attrs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_attrs (
    id integer NOT NULL,
    did character varying(64) NOT NULL,
    name character varying(32) NOT NULL,
    type integer NOT NULL,
    value character varying(255) NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.domain_attrs OWNER TO postgres;

--
-- Name: domain_attrs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_attrs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_attrs_id_seq OWNER TO postgres;

--
-- Name: domain_attrs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_attrs_id_seq OWNED BY domain_attrs.id;


--
-- Name: domain_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_id_seq OWNER TO postgres;

--
-- Name: domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_id_seq OWNED BY domain.id;


--
-- Name: domain_name; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_name (
    id integer NOT NULL,
    domain character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE public.domain_name OWNER TO postgres;

--
-- Name: domain_name_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domain_name_id_seq OWNER TO postgres;

--
-- Name: domain_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_name_id_seq OWNED BY domain_name.id;


--
-- Name: domainpolicy; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domainpolicy (
    id integer NOT NULL,
    rule character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    att character varying(255),
    val character varying(128),
    description character varying(255) NOT NULL
);


ALTER TABLE public.domainpolicy OWNER TO postgres;

--
-- Name: domainpolicy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domainpolicy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domainpolicy_id_seq OWNER TO postgres;

--
-- Name: domainpolicy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domainpolicy_id_seq OWNED BY domainpolicy.id;


--
-- Name: globalblacklist; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE globalblacklist (
    id integer NOT NULL,
    prefix character varying(64) DEFAULT ''::character varying NOT NULL,
    whitelist smallint DEFAULT 0 NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.globalblacklist OWNER TO postgres;

--
-- Name: globalblacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE globalblacklist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.globalblacklist_id_seq OWNER TO postgres;

--
-- Name: globalblacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE globalblacklist_id_seq OWNED BY globalblacklist.id;


--
-- Name: grp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grp (
    id integer NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    grp character varying(64) DEFAULT ''::character varying NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.grp OWNER TO postgres;

--
-- Name: grp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grp_id_seq OWNER TO postgres;

--
-- Name: grp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grp_id_seq OWNED BY grp.id;


--
-- Name: htable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE htable (
    id integer NOT NULL,
    key_name character varying(64) DEFAULT ''::character varying NOT NULL,
    key_type integer DEFAULT 0 NOT NULL,
    value_type integer DEFAULT 0 NOT NULL,
    key_value character varying(128) DEFAULT ''::character varying NOT NULL,
    expires integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.htable OWNER TO postgres;

--
-- Name: htable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE htable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.htable_id_seq OWNER TO postgres;

--
-- Name: htable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE htable_id_seq OWNED BY htable.id;


--
-- Name: imc_members; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE imc_members (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    domain character varying(64) NOT NULL,
    room character varying(64) NOT NULL,
    flag integer NOT NULL
);


ALTER TABLE public.imc_members OWNER TO postgres;

--
-- Name: imc_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE imc_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imc_members_id_seq OWNER TO postgres;

--
-- Name: imc_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE imc_members_id_seq OWNED BY imc_members.id;


--
-- Name: imc_rooms; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE imc_rooms (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    domain character varying(64) NOT NULL,
    flag integer NOT NULL
);


ALTER TABLE public.imc_rooms OWNER TO postgres;

--
-- Name: imc_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE imc_rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imc_rooms_id_seq OWNER TO postgres;

--
-- Name: imc_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE imc_rooms_id_seq OWNED BY imc_rooms.id;


--
-- Name: lcr_gw; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lcr_gw (
    id integer NOT NULL,
    lcr_id smallint NOT NULL,
    gw_name character varying(128),
    ip_addr character varying(50),
    hostname character varying(64),
    port smallint,
    params character varying(64),
    uri_scheme smallint,
    transport smallint,
    strip smallint,
    prefix character varying(16) DEFAULT NULL::character varying,
    tag character varying(64) DEFAULT NULL::character varying,
    flags integer DEFAULT 0 NOT NULL,
    defunct integer
);


ALTER TABLE public.lcr_gw OWNER TO postgres;

--
-- Name: lcr_gw_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lcr_gw_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lcr_gw_id_seq OWNER TO postgres;

--
-- Name: lcr_gw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lcr_gw_id_seq OWNED BY lcr_gw.id;


--
-- Name: lcr_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lcr_rule (
    id integer NOT NULL,
    lcr_id smallint NOT NULL,
    prefix character varying(16) DEFAULT NULL::character varying,
    from_uri character varying(64) DEFAULT NULL::character varying,
    request_uri character varying(64) DEFAULT NULL::character varying,
    stopper integer DEFAULT 0 NOT NULL,
    enabled integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.lcr_rule OWNER TO postgres;

--
-- Name: lcr_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lcr_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lcr_rule_id_seq OWNER TO postgres;

--
-- Name: lcr_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lcr_rule_id_seq OWNED BY lcr_rule.id;


--
-- Name: lcr_rule_target; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lcr_rule_target (
    id integer NOT NULL,
    lcr_id smallint NOT NULL,
    rule_id integer NOT NULL,
    gw_id integer NOT NULL,
    priority smallint NOT NULL,
    weight integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.lcr_rule_target OWNER TO postgres;

--
-- Name: lcr_rule_target_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lcr_rule_target_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lcr_rule_target_id_seq OWNER TO postgres;

--
-- Name: lcr_rule_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lcr_rule_target_id_seq OWNED BY lcr_rule_target.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    ruid character varying(64) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT NULL::character varying,
    contact character varying(255) DEFAULT ''::character varying NOT NULL,
    received character varying(128) DEFAULT NULL::character varying,
    path character varying(512) DEFAULT NULL::character varying,
    expires timestamp without time zone DEFAULT '2030-05-28 21:32:15'::timestamp without time zone NOT NULL,
    q real DEFAULT 1.0 NOT NULL,
    callid character varying(255) DEFAULT 'Default-Call-ID'::character varying NOT NULL,
    cseq integer DEFAULT 1 NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    cflags integer DEFAULT 0 NOT NULL,
    user_agent character varying(255) DEFAULT ''::character varying NOT NULL,
    socket character varying(64) DEFAULT NULL::character varying,
    methods integer,
    instance character varying(255) DEFAULT NULL::character varying,
    reg_id integer DEFAULT 0 NOT NULL,
    server_id integer DEFAULT 0 NOT NULL,
    connection_id integer DEFAULT 0 NOT NULL,
    keepalive integer DEFAULT 0 NOT NULL,
    partition integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.location OWNER TO postgres;

--
-- Name: location_attrs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE location_attrs (
    id integer NOT NULL,
    ruid character varying(64) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT NULL::character varying,
    aname character varying(64) DEFAULT ''::character varying NOT NULL,
    atype integer DEFAULT 0 NOT NULL,
    avalue character varying(255) DEFAULT ''::character varying NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.location_attrs OWNER TO postgres;

--
-- Name: location_attrs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE location_attrs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_attrs_id_seq OWNER TO postgres;

--
-- Name: location_attrs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE location_attrs_id_seq OWNED BY location_attrs.id;


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: missed_calls; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE missed_calls (
    id integer NOT NULL,
    method character varying(16) DEFAULT ''::character varying NOT NULL,
    from_tag character varying(64) DEFAULT ''::character varying NOT NULL,
    to_tag character varying(64) DEFAULT ''::character varying NOT NULL,
    callid character varying(255) DEFAULT ''::character varying NOT NULL,
    sip_code character varying(3) DEFAULT ''::character varying NOT NULL,
    sip_reason character varying(128) DEFAULT ''::character varying NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.missed_calls OWNER TO postgres;

--
-- Name: missed_calls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE missed_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.missed_calls_id_seq OWNER TO postgres;

--
-- Name: missed_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE missed_calls_id_seq OWNED BY missed_calls.id;


--
-- Name: mohqcalls; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mohqcalls (
    id integer NOT NULL,
    mohq_id integer NOT NULL,
    call_id character varying(100) NOT NULL,
    call_status integer NOT NULL,
    call_from character varying(100) NOT NULL,
    call_contact character varying(100),
    call_time timestamp without time zone NOT NULL
);


ALTER TABLE public.mohqcalls OWNER TO postgres;

--
-- Name: mohqcalls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mohqcalls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mohqcalls_id_seq OWNER TO postgres;

--
-- Name: mohqcalls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mohqcalls_id_seq OWNED BY mohqcalls.id;


--
-- Name: mohqueues; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mohqueues (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    uri character varying(100) NOT NULL,
    mohdir character varying(100),
    mohfile character varying(100) NOT NULL,
    debug integer NOT NULL
);


ALTER TABLE public.mohqueues OWNER TO postgres;

--
-- Name: mohqueues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mohqueues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mohqueues_id_seq OWNER TO postgres;

--
-- Name: mohqueues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mohqueues_id_seq OWNED BY mohqueues.id;


--
-- Name: mtree; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mtree (
    id integer NOT NULL,
    tprefix character varying(32) DEFAULT ''::character varying NOT NULL,
    tvalue character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.mtree OWNER TO postgres;

--
-- Name: mtree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mtree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mtree_id_seq OWNER TO postgres;

--
-- Name: mtree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mtree_id_seq OWNED BY mtree.id;


--
-- Name: mtrees; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mtrees (
    id integer NOT NULL,
    tname character varying(128) DEFAULT ''::character varying NOT NULL,
    tprefix character varying(32) DEFAULT ''::character varying NOT NULL,
    tvalue character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.mtrees OWNER TO postgres;

--
-- Name: mtrees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mtrees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mtrees_id_seq OWNER TO postgres;

--
-- Name: mtrees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE mtrees_id_seq OWNED BY mtrees.id;


--
-- Name: pdt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pdt (
    id integer NOT NULL,
    sdomain character varying(128) NOT NULL,
    prefix character varying(32) NOT NULL,
    domain character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.pdt OWNER TO postgres;

--
-- Name: pdt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pdt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pdt_id_seq OWNER TO postgres;

--
-- Name: pdt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pdt_id_seq OWNED BY pdt.id;


--
-- Name: pl_pipes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pl_pipes (
    id integer NOT NULL,
    pipeid character varying(64) DEFAULT ''::character varying NOT NULL,
    algorithm character varying(32) DEFAULT ''::character varying NOT NULL,
    plimit integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.pl_pipes OWNER TO postgres;

--
-- Name: pl_pipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pl_pipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pl_pipes_id_seq OWNER TO postgres;

--
-- Name: pl_pipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pl_pipes_id_seq OWNED BY pl_pipes.id;


--
-- Name: purplemap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE purplemap (
    id integer NOT NULL,
    sip_user character varying(128) NOT NULL,
    ext_user character varying(128) NOT NULL,
    ext_prot character varying(16) NOT NULL,
    ext_pass character varying(64)
);


ALTER TABLE public.purplemap OWNER TO postgres;

--
-- Name: purplemap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE purplemap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purplemap_id_seq OWNER TO postgres;

--
-- Name: purplemap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE purplemap_id_seq OWNED BY purplemap.id;


--
-- Name: re_grp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE re_grp (
    id integer NOT NULL,
    reg_exp character varying(128) DEFAULT ''::character varying NOT NULL,
    group_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.re_grp OWNER TO postgres;

--
-- Name: re_grp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE re_grp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.re_grp_id_seq OWNER TO postgres;

--
-- Name: re_grp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE re_grp_id_seq OWNED BY re_grp.id;


--
-- Name: rtpproxy; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rtpproxy (
    id integer NOT NULL,
    setid character varying(32) DEFAULT 0 NOT NULL,
    url character varying(64) DEFAULT ''::character varying NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    description character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.rtpproxy OWNER TO postgres;

--
-- Name: rtpproxy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rtpproxy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rtpproxy_id_seq OWNER TO postgres;

--
-- Name: rtpproxy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rtpproxy_id_seq OWNED BY rtpproxy.id;


--
-- Name: sca_subscriptions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sca_subscriptions (
    id integer NOT NULL,
    subscriber character varying(255) NOT NULL,
    aor character varying(255) NOT NULL,
    event integer DEFAULT 0 NOT NULL,
    expires integer DEFAULT 0 NOT NULL,
    state integer DEFAULT 0 NOT NULL,
    app_idx integer DEFAULT 0 NOT NULL,
    call_id character varying(255) NOT NULL,
    from_tag character varying(64) NOT NULL,
    to_tag character varying(64) NOT NULL,
    record_route text,
    notify_cseq integer NOT NULL,
    subscribe_cseq integer NOT NULL
);


ALTER TABLE public.sca_subscriptions OWNER TO postgres;

--
-- Name: sca_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sca_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sca_subscriptions_id_seq OWNER TO postgres;

--
-- Name: sca_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sca_subscriptions_id_seq OWNED BY sca_subscriptions.id;


--
-- Name: silo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE silo (
    id integer NOT NULL,
    src_addr character varying(128) DEFAULT ''::character varying NOT NULL,
    dst_addr character varying(128) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    inc_time integer DEFAULT 0 NOT NULL,
    exp_time integer DEFAULT 0 NOT NULL,
    snd_time integer DEFAULT 0 NOT NULL,
    ctype character varying(32) DEFAULT 'text/plain'::character varying NOT NULL,
    body bytea,
    extra_hdrs text,
    callid character varying(128) DEFAULT ''::character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.silo OWNER TO postgres;

--
-- Name: silo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE silo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.silo_id_seq OWNER TO postgres;

--
-- Name: silo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE silo_id_seq OWNED BY silo.id;


--
-- Name: sip; Type: TABLE; Schema: public; Owner: kamailio; Tablespace: 
--

CREATE TABLE sip (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    accountcode character varying(20),
    amaflags character varying(7),
    callgroup character varying(10),
    callerid character varying(80),
    directmedia character varying(3) DEFAULT 'yes'::character varying,
    context character varying(80) DEFAULT 'default'::character varying,
    defaultip character varying(15),
    dtmfmode character varying(7),
    fromuser character varying(80),
    fromdomain character varying(80),
    host character varying(31) DEFAULT 'dynamic'::character varying NOT NULL,
    insecure character varying(4),
    language character varying(2),
    mailbox character varying(50),
    md5secret character varying(80),
    nat character varying(5) DEFAULT 'no'::character varying NOT NULL,
    permit character varying(95),
    deny character varying(95),
    mask character varying(95),
    pickupgroup character varying(10),
    port character varying(5),
    qualify character varying(3),
    restrictcid character varying(1),
    rtptimeout character varying(3),
    rtpholdtimeout character varying(3),
    secret character varying(80),
    type character varying DEFAULT 'friend'::character varying NOT NULL,
    username character varying(80),
    disallow character varying(100) DEFAULT 'all'::character varying,
    allow character varying(100) DEFAULT 'alaw,ulaw'::character varying,
    musiconhold character varying(100),
    regseconds integer DEFAULT 0 NOT NULL,
    ipaddr character varying(15),
    regexten character varying(80),
    cancallforward character varying(3) DEFAULT 'yes'::character varying,
    lastms character varying(80),
    useragent character varying(100),
    defaultuser character varying(100),
    fullcontact character varying(100),
    regserver character varying(100),
    kamailiopass character varying(80)
);


ALTER TABLE public.sip OWNER TO kamailio;

--
-- Name: sip_id_seq; Type: SEQUENCE; Schema: public; Owner: kamailio
--

CREATE SEQUENCE sip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sip_id_seq OWNER TO kamailio;

--
-- Name: sip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kamailio
--

ALTER SEQUENCE sip_id_seq OWNED BY sip.id;


--
-- Name: sip_trace; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sip_trace (
    id integer NOT NULL,
    time_stamp timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL,
    time_us integer DEFAULT 0 NOT NULL,
    callid character varying(255) DEFAULT ''::character varying NOT NULL,
    traced_user character varying(128) DEFAULT ''::character varying NOT NULL,
    msg text NOT NULL,
    method character varying(50) DEFAULT ''::character varying NOT NULL,
    status character varying(128) DEFAULT ''::character varying NOT NULL,
    fromip character varying(50) DEFAULT ''::character varying NOT NULL,
    toip character varying(50) DEFAULT ''::character varying NOT NULL,
    fromtag character varying(64) DEFAULT ''::character varying NOT NULL,
    totag character varying(64) DEFAULT ''::character varying NOT NULL,
    direction character varying(4) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.sip_trace OWNER TO postgres;

--
-- Name: sip_trace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sip_trace_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sip_trace_id_seq OWNER TO postgres;

--
-- Name: sip_trace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sip_trace_id_seq OWNED BY sip_trace.id;


--
-- Name: speed_dial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speed_dial (
    id integer NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    sd_username character varying(64) DEFAULT ''::character varying NOT NULL,
    sd_domain character varying(64) DEFAULT ''::character varying NOT NULL,
    new_uri character varying(128) DEFAULT ''::character varying NOT NULL,
    fname character varying(64) DEFAULT ''::character varying NOT NULL,
    lname character varying(64) DEFAULT ''::character varying NOT NULL,
    description character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.speed_dial OWNER TO postgres;

--
-- Name: speed_dial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE speed_dial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.speed_dial_id_seq OWNER TO postgres;

--
-- Name: speed_dial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE speed_dial_id_seq OWNED BY speed_dial.id;


--
-- Name: subscriber; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subscriber (
    id integer NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    password character varying(25) DEFAULT ''::character varying NOT NULL,
    email_address character varying(64) DEFAULT ''::character varying NOT NULL,
    ha1 character varying(64) DEFAULT ''::character varying NOT NULL,
    ha1b character varying(64) DEFAULT ''::character varying NOT NULL,
    rpid character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE public.subscriber OWNER TO postgres;

--
-- Name: subscriber_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subscriber_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriber_id_seq OWNER TO postgres;

--
-- Name: subscriber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subscriber_id_seq OWNED BY subscriber.id;


--
-- Name: topos_d; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE topos_d (
    id integer NOT NULL,
    rectime timestamp without time zone NOT NULL,
    s_method character varying(64) DEFAULT ''::character varying NOT NULL,
    s_cseq character varying(64) DEFAULT ''::character varying NOT NULL,
    a_callid character varying(255) DEFAULT ''::character varying NOT NULL,
    a_uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    b_uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    a_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    b_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    as_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    bs_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    a_tag character varying(255) DEFAULT ''::character varying NOT NULL,
    b_tag character varying(255) DEFAULT ''::character varying NOT NULL,
    a_rr text DEFAULT ''::text NOT NULL,
    b_rr text DEFAULT ''::text NOT NULL,
    s_rr text DEFAULT ''::text NOT NULL,
    iflags integer DEFAULT 0 NOT NULL,
    a_uri character varying(128) DEFAULT ''::character varying NOT NULL,
    b_uri character varying(128) DEFAULT ''::character varying NOT NULL,
    r_uri character varying(128) DEFAULT ''::character varying NOT NULL,
    a_srcaddr character varying(128) DEFAULT ''::character varying NOT NULL,
    b_srcaddr character varying(128) DEFAULT ''::character varying NOT NULL,
    a_socket character varying(128) DEFAULT ''::character varying NOT NULL,
    b_socket character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.topos_d OWNER TO postgres;

--
-- Name: topos_d_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE topos_d_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.topos_d_id_seq OWNER TO postgres;

--
-- Name: topos_d_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE topos_d_id_seq OWNED BY topos_d.id;


--
-- Name: topos_t; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE topos_t (
    id integer NOT NULL,
    rectime timestamp without time zone NOT NULL,
    s_method character varying(64) DEFAULT ''::character varying NOT NULL,
    s_cseq character varying(64) DEFAULT ''::character varying NOT NULL,
    a_callid character varying(255) DEFAULT ''::character varying NOT NULL,
    a_uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    b_uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    direction integer DEFAULT 0 NOT NULL,
    x_via text DEFAULT ''::text NOT NULL,
    x_vbranch character varying(255) DEFAULT ''::character varying NOT NULL,
    x_rr text DEFAULT ''::text NOT NULL,
    y_rr text DEFAULT ''::text NOT NULL,
    s_rr text DEFAULT ''::text NOT NULL,
    x_uri character varying(128) DEFAULT ''::character varying NOT NULL,
    a_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    b_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    as_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    bs_contact character varying(128) DEFAULT ''::character varying NOT NULL,
    x_tag character varying(255) DEFAULT ''::character varying NOT NULL,
    a_tag character varying(255) DEFAULT ''::character varying NOT NULL,
    b_tag character varying(255) DEFAULT ''::character varying NOT NULL,
    a_srcaddr character varying(128) DEFAULT ''::character varying NOT NULL,
    b_srcaddr character varying(128) DEFAULT ''::character varying NOT NULL,
    a_socket character varying(128) DEFAULT ''::character varying NOT NULL,
    b_socket character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.topos_t OWNER TO postgres;

--
-- Name: topos_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE topos_t_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.topos_t_id_seq OWNER TO postgres;

--
-- Name: topos_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE topos_t_id_seq OWNED BY topos_t.id;


--
-- Name: trusted; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trusted (
    id integer NOT NULL,
    src_ip character varying(50) NOT NULL,
    proto character varying(4) NOT NULL,
    from_pattern character varying(64) DEFAULT NULL::character varying,
    ruri_pattern character varying(64) DEFAULT NULL::character varying,
    tag character varying(64),
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.trusted OWNER TO postgres;

--
-- Name: trusted_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trusted_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trusted_id_seq OWNER TO postgres;

--
-- Name: trusted_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trusted_id_seq OWNED BY trusted.id;


--
-- Name: uacreg; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE uacreg (
    id integer NOT NULL,
    l_uuid character varying(64) DEFAULT ''::character varying NOT NULL,
    l_username character varying(64) DEFAULT ''::character varying NOT NULL,
    l_domain character varying(128) DEFAULT ''::character varying NOT NULL,
    r_username character varying(64) DEFAULT ''::character varying NOT NULL,
    r_domain character varying(128) DEFAULT ''::character varying NOT NULL,
    realm character varying(64) DEFAULT ''::character varying NOT NULL,
    auth_username character varying(64) DEFAULT ''::character varying NOT NULL,
    auth_password character varying(64) DEFAULT ''::character varying NOT NULL,
    auth_proxy character varying(64) DEFAULT ''::character varying NOT NULL,
    expires integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    reg_delay integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.uacreg OWNER TO postgres;

--
-- Name: uacreg_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE uacreg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uacreg_id_seq OWNER TO postgres;

--
-- Name: uacreg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE uacreg_id_seq OWNED BY uacreg.id;


--
-- Name: uri; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE uri (
    id integer NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    uri_user character varying(64) DEFAULT ''::character varying NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.uri OWNER TO postgres;

--
-- Name: uri_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE uri_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uri_id_seq OWNER TO postgres;

--
-- Name: uri_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE uri_id_seq OWNED BY uri.id;


--
-- Name: userblacklist; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE userblacklist (
    id integer NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    prefix character varying(64) DEFAULT ''::character varying NOT NULL,
    whitelist smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.userblacklist OWNER TO postgres;

--
-- Name: userblacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE userblacklist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userblacklist_id_seq OWNER TO postgres;

--
-- Name: userblacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE userblacklist_id_seq OWNED BY userblacklist.id;


--
-- Name: usr_preferences; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usr_preferences (
    id integer NOT NULL,
    uuid character varying(64) DEFAULT ''::character varying NOT NULL,
    username character varying(128) DEFAULT 0 NOT NULL,
    domain character varying(64) DEFAULT ''::character varying NOT NULL,
    attribute character varying(32) DEFAULT ''::character varying NOT NULL,
    type integer DEFAULT 0 NOT NULL,
    value character varying(128) DEFAULT ''::character varying NOT NULL,
    last_modified timestamp without time zone DEFAULT '1900-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.usr_preferences OWNER TO postgres;

--
-- Name: usr_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usr_preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usr_preferences_id_seq OWNER TO postgres;

--
-- Name: usr_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usr_preferences_id_seq OWNED BY usr_preferences.id;


--
-- Name: version; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE version (
    table_name character varying(32) NOT NULL,
    table_version integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.version OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acc ALTER COLUMN id SET DEFAULT nextval('acc_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acc_cdrs ALTER COLUMN id SET DEFAULT nextval('acc_cdrs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aliases ALTER COLUMN id SET DEFAULT nextval('aliases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY carrier_name ALTER COLUMN id SET DEFAULT nextval('carrier_name_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY carrierfailureroute ALTER COLUMN id SET DEFAULT nextval('carrierfailureroute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY carrierroute ALTER COLUMN id SET DEFAULT nextval('carrierroute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cdr ALTER COLUMN id SET DEFAULT nextval('cdr_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cpl ALTER COLUMN id SET DEFAULT nextval('cpl_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dbaliases ALTER COLUMN id SET DEFAULT nextval('dbaliases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialog ALTER COLUMN id SET DEFAULT nextval('dialog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialog_vars ALTER COLUMN id SET DEFAULT nextval('dialog_vars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialplan ALTER COLUMN id SET DEFAULT nextval('dialplan_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dispatcher ALTER COLUMN id SET DEFAULT nextval('dispatcher_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain ALTER COLUMN id SET DEFAULT nextval('domain_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_attrs ALTER COLUMN id SET DEFAULT nextval('domain_attrs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_name ALTER COLUMN id SET DEFAULT nextval('domain_name_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domainpolicy ALTER COLUMN id SET DEFAULT nextval('domainpolicy_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY globalblacklist ALTER COLUMN id SET DEFAULT nextval('globalblacklist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grp ALTER COLUMN id SET DEFAULT nextval('grp_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY htable ALTER COLUMN id SET DEFAULT nextval('htable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY imc_members ALTER COLUMN id SET DEFAULT nextval('imc_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY imc_rooms ALTER COLUMN id SET DEFAULT nextval('imc_rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lcr_gw ALTER COLUMN id SET DEFAULT nextval('lcr_gw_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lcr_rule ALTER COLUMN id SET DEFAULT nextval('lcr_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lcr_rule_target ALTER COLUMN id SET DEFAULT nextval('lcr_rule_target_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location_attrs ALTER COLUMN id SET DEFAULT nextval('location_attrs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY missed_calls ALTER COLUMN id SET DEFAULT nextval('missed_calls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mohqcalls ALTER COLUMN id SET DEFAULT nextval('mohqcalls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mohqueues ALTER COLUMN id SET DEFAULT nextval('mohqueues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mtree ALTER COLUMN id SET DEFAULT nextval('mtree_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mtrees ALTER COLUMN id SET DEFAULT nextval('mtrees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pdt ALTER COLUMN id SET DEFAULT nextval('pdt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pl_pipes ALTER COLUMN id SET DEFAULT nextval('pl_pipes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY purplemap ALTER COLUMN id SET DEFAULT nextval('purplemap_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY re_grp ALTER COLUMN id SET DEFAULT nextval('re_grp_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rtpproxy ALTER COLUMN id SET DEFAULT nextval('rtpproxy_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sca_subscriptions ALTER COLUMN id SET DEFAULT nextval('sca_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY silo ALTER COLUMN id SET DEFAULT nextval('silo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kamailio
--

ALTER TABLE ONLY sip ALTER COLUMN id SET DEFAULT nextval('sip_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sip_trace ALTER COLUMN id SET DEFAULT nextval('sip_trace_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speed_dial ALTER COLUMN id SET DEFAULT nextval('speed_dial_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subscriber ALTER COLUMN id SET DEFAULT nextval('subscriber_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topos_d ALTER COLUMN id SET DEFAULT nextval('topos_d_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY topos_t ALTER COLUMN id SET DEFAULT nextval('topos_t_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trusted ALTER COLUMN id SET DEFAULT nextval('trusted_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY uacreg ALTER COLUMN id SET DEFAULT nextval('uacreg_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY uri ALTER COLUMN id SET DEFAULT nextval('uri_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY userblacklist ALTER COLUMN id SET DEFAULT nextval('userblacklist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usr_preferences ALTER COLUMN id SET DEFAULT nextval('usr_preferences_id_seq'::regclass);


--
-- Name: acc_cdrs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_cdrs
    ADD CONSTRAINT acc_cdrs_pkey PRIMARY KEY (id);


--
-- Name: acc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc
    ADD CONSTRAINT acc_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aliases
    ADD CONSTRAINT aliases_pkey PRIMARY KEY (id);


--
-- Name: aliases_ruid_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aliases
    ADD CONSTRAINT aliases_ruid_idx UNIQUE (ruid);


--
-- Name: carrier_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY carrier_name
    ADD CONSTRAINT carrier_name_pkey PRIMARY KEY (id);


--
-- Name: carrierfailureroute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY carrierfailureroute
    ADD CONSTRAINT carrierfailureroute_pkey PRIMARY KEY (id);


--
-- Name: carrierroute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY carrierroute
    ADD CONSTRAINT carrierroute_pkey PRIMARY KEY (id);


--
-- Name: cdr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cdr
    ADD CONSTRAINT cdr_pkey PRIMARY KEY (id);


--
-- Name: cpl_account_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cpl
    ADD CONSTRAINT cpl_account_idx UNIQUE (username, domain);


--
-- Name: cpl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cpl
    ADD CONSTRAINT cpl_pkey PRIMARY KEY (id);


--
-- Name: dbaliases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dbaliases
    ADD CONSTRAINT dbaliases_pkey PRIMARY KEY (id);


--
-- Name: dialog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialog
    ADD CONSTRAINT dialog_pkey PRIMARY KEY (id);


--
-- Name: dialog_vars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialog_vars
    ADD CONSTRAINT dialog_vars_pkey PRIMARY KEY (id);


--
-- Name: dialplan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialplan
    ADD CONSTRAINT dialplan_pkey PRIMARY KEY (id);


--
-- Name: dispatcher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dispatcher
    ADD CONSTRAINT dispatcher_pkey PRIMARY KEY (id);


--
-- Name: domain_attrs_domain_attrs_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_attrs
    ADD CONSTRAINT domain_attrs_domain_attrs_idx UNIQUE (did, name, value);


--
-- Name: domain_attrs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_attrs
    ADD CONSTRAINT domain_attrs_pkey PRIMARY KEY (id);


--
-- Name: domain_domain_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_domain_idx UNIQUE (domain);


--
-- Name: domain_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_name
    ADD CONSTRAINT domain_name_pkey PRIMARY KEY (id);


--
-- Name: domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (id);


--
-- Name: domainpolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domainpolicy
    ADD CONSTRAINT domainpolicy_pkey PRIMARY KEY (id);


--
-- Name: domainpolicy_rav_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domainpolicy
    ADD CONSTRAINT domainpolicy_rav_idx UNIQUE (rule, att, val);


--
-- Name: globalblacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY globalblacklist
    ADD CONSTRAINT globalblacklist_pkey PRIMARY KEY (id);


--
-- Name: grp_account_group_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grp
    ADD CONSTRAINT grp_account_group_idx UNIQUE (username, domain, grp);


--
-- Name: grp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grp
    ADD CONSTRAINT grp_pkey PRIMARY KEY (id);


--
-- Name: htable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY htable
    ADD CONSTRAINT htable_pkey PRIMARY KEY (id);


--
-- Name: imc_members_account_room_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY imc_members
    ADD CONSTRAINT imc_members_account_room_idx UNIQUE (username, domain, room);


--
-- Name: imc_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY imc_members
    ADD CONSTRAINT imc_members_pkey PRIMARY KEY (id);


--
-- Name: imc_rooms_name_domain_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY imc_rooms
    ADD CONSTRAINT imc_rooms_name_domain_idx UNIQUE (name, domain);


--
-- Name: imc_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY imc_rooms
    ADD CONSTRAINT imc_rooms_pkey PRIMARY KEY (id);


--
-- Name: lcr_gw_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lcr_gw
    ADD CONSTRAINT lcr_gw_pkey PRIMARY KEY (id);


--
-- Name: lcr_rule_lcr_id_prefix_from_uri_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lcr_rule
    ADD CONSTRAINT lcr_rule_lcr_id_prefix_from_uri_idx UNIQUE (lcr_id, prefix, from_uri);


--
-- Name: lcr_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lcr_rule
    ADD CONSTRAINT lcr_rule_pkey PRIMARY KEY (id);


--
-- Name: lcr_rule_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lcr_rule_target
    ADD CONSTRAINT lcr_rule_target_pkey PRIMARY KEY (id);


--
-- Name: lcr_rule_target_rule_id_gw_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lcr_rule_target
    ADD CONSTRAINT lcr_rule_target_rule_id_gw_id_idx UNIQUE (rule_id, gw_id);


--
-- Name: location_attrs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location_attrs
    ADD CONSTRAINT location_attrs_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: location_ruid_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_ruid_idx UNIQUE (ruid);


--
-- Name: missed_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY missed_calls
    ADD CONSTRAINT missed_calls_pkey PRIMARY KEY (id);


--
-- Name: mohqcalls_mohqcalls_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mohqcalls
    ADD CONSTRAINT mohqcalls_mohqcalls_idx UNIQUE (call_id);


--
-- Name: mohqcalls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mohqcalls
    ADD CONSTRAINT mohqcalls_pkey PRIMARY KEY (id);


--
-- Name: mohqueues_mohqueue_name_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mohqueues
    ADD CONSTRAINT mohqueues_mohqueue_name_idx UNIQUE (name);


--
-- Name: mohqueues_mohqueue_uri_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mohqueues
    ADD CONSTRAINT mohqueues_mohqueue_uri_idx UNIQUE (uri);


--
-- Name: mohqueues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mohqueues
    ADD CONSTRAINT mohqueues_pkey PRIMARY KEY (id);


--
-- Name: mtree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mtree
    ADD CONSTRAINT mtree_pkey PRIMARY KEY (id);


--
-- Name: mtree_tprefix_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mtree
    ADD CONSTRAINT mtree_tprefix_idx UNIQUE (tprefix);


--
-- Name: mtrees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mtrees
    ADD CONSTRAINT mtrees_pkey PRIMARY KEY (id);


--
-- Name: mtrees_tname_tprefix_tvalue_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mtrees
    ADD CONSTRAINT mtrees_tname_tprefix_tvalue_idx UNIQUE (tname, tprefix, tvalue);


--
-- Name: pdt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pdt
    ADD CONSTRAINT pdt_pkey PRIMARY KEY (id);


--
-- Name: pdt_sdomain_prefix_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pdt
    ADD CONSTRAINT pdt_sdomain_prefix_idx UNIQUE (sdomain, prefix);


--
-- Name: pl_pipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pl_pipes
    ADD CONSTRAINT pl_pipes_pkey PRIMARY KEY (id);


--
-- Name: purplemap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY purplemap
    ADD CONSTRAINT purplemap_pkey PRIMARY KEY (id);


--
-- Name: re_grp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY re_grp
    ADD CONSTRAINT re_grp_pkey PRIMARY KEY (id);


--
-- Name: rtpproxy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rtpproxy
    ADD CONSTRAINT rtpproxy_pkey PRIMARY KEY (id);


--
-- Name: sca_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sca_subscriptions
    ADD CONSTRAINT sca_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: sca_subscriptions_sca_subscriptions_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sca_subscriptions
    ADD CONSTRAINT sca_subscriptions_sca_subscriptions_idx UNIQUE (subscriber, call_id, from_tag, to_tag);


--
-- Name: silo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY silo
    ADD CONSTRAINT silo_pkey PRIMARY KEY (id);


--
-- Name: sip_conf_pkey; Type: CONSTRAINT; Schema: public; Owner: kamailio; Tablespace: 
--

ALTER TABLE ONLY sip
    ADD CONSTRAINT sip_conf_pkey PRIMARY KEY (id);


--
-- Name: sip_trace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sip_trace
    ADD CONSTRAINT sip_trace_pkey PRIMARY KEY (id);


--
-- Name: speed_dial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speed_dial
    ADD CONSTRAINT speed_dial_pkey PRIMARY KEY (id);


--
-- Name: speed_dial_speed_dial_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speed_dial
    ADD CONSTRAINT speed_dial_speed_dial_idx UNIQUE (username, domain, sd_domain, sd_username);


--
-- Name: subscriber_account_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_account_idx UNIQUE (username, domain);


--
-- Name: subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (id);


--
-- Name: topos_d_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY topos_d
    ADD CONSTRAINT topos_d_pkey PRIMARY KEY (id);


--
-- Name: topos_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY topos_t
    ADD CONSTRAINT topos_t_pkey PRIMARY KEY (id);


--
-- Name: trusted_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trusted
    ADD CONSTRAINT trusted_pkey PRIMARY KEY (id);


--
-- Name: uacreg_l_uuid_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY uacreg
    ADD CONSTRAINT uacreg_l_uuid_idx UNIQUE (l_uuid);


--
-- Name: uacreg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY uacreg
    ADD CONSTRAINT uacreg_pkey PRIMARY KEY (id);


--
-- Name: uri_account_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY uri
    ADD CONSTRAINT uri_account_idx UNIQUE (username, domain, uri_user);


--
-- Name: uri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY uri
    ADD CONSTRAINT uri_pkey PRIMARY KEY (id);


--
-- Name: userblacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY userblacklist
    ADD CONSTRAINT userblacklist_pkey PRIMARY KEY (id);


--
-- Name: usr_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usr_preferences
    ADD CONSTRAINT usr_preferences_pkey PRIMARY KEY (id);


--
-- Name: version_table_name_idx; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY version
    ADD CONSTRAINT version_table_name_idx UNIQUE (table_name);


--
-- Name: acc_callid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_callid_idx ON acc USING btree (callid);


--
-- Name: acc_cdrs_start_time_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_cdrs_start_time_idx ON acc_cdrs USING btree (start_time);


--
-- Name: aliases_account_contact_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX aliases_account_contact_idx ON aliases USING btree (username, domain, contact);


--
-- Name: aliases_expires_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX aliases_expires_idx ON aliases USING btree (expires);


--
-- Name: billsec; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX billsec ON cdr USING btree (billsec);


--
-- Name: calldate; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calldate ON cdr USING btree (calldate);


--
-- Name: dbaliases_alias_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dbaliases_alias_idx ON dbaliases USING btree (alias_username, alias_domain);


--
-- Name: dbaliases_alias_user_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dbaliases_alias_user_idx ON dbaliases USING btree (alias_username);


--
-- Name: dbaliases_target_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dbaliases_target_idx ON dbaliases USING btree (username, domain);


--
-- Name: dialog_hash_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dialog_hash_idx ON dialog USING btree (hash_entry, hash_id);


--
-- Name: dialog_vars_hash_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dialog_vars_hash_idx ON dialog_vars USING btree (hash_entry, hash_id);


--
-- Name: domainpolicy_rule_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX domainpolicy_rule_idx ON domainpolicy USING btree (rule);


--
-- Name: dst; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dst ON cdr USING btree (dst);


--
-- Name: globalblacklist_globalblacklist_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX globalblacklist_globalblacklist_idx ON globalblacklist USING btree (prefix);


--
-- Name: lcr_gw_lcr_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lcr_gw_lcr_id_idx ON lcr_gw USING btree (lcr_id);


--
-- Name: lcr_rule_target_lcr_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lcr_rule_target_lcr_id_idx ON lcr_rule_target USING btree (lcr_id);


--
-- Name: location_account_contact_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX location_account_contact_idx ON location USING btree (username, domain, contact);


--
-- Name: location_attrs_account_record_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX location_attrs_account_record_idx ON location_attrs USING btree (username, domain, ruid);


--
-- Name: location_attrs_last_modified_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX location_attrs_last_modified_idx ON location_attrs USING btree (last_modified);


--
-- Name: location_connection_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX location_connection_idx ON location USING btree (server_id, connection_id);


--
-- Name: location_expires_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX location_expires_idx ON location USING btree (expires);


--
-- Name: missed_calls_callid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX missed_calls_callid_idx ON missed_calls USING btree (callid);


--
-- Name: name; Type: INDEX; Schema: public; Owner: kamailio; Tablespace: 
--

CREATE UNIQUE INDEX name ON sip USING btree (name);


--
-- Name: re_grp_group_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX re_grp_group_idx ON re_grp USING btree (group_id);


--
-- Name: sca_subscriptions_sca_expires_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sca_subscriptions_sca_expires_idx ON sca_subscriptions USING btree (expires);


--
-- Name: sca_subscriptions_sca_subscribers_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sca_subscriptions_sca_subscribers_idx ON sca_subscriptions USING btree (subscriber, event);


--
-- Name: silo_account_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX silo_account_idx ON silo USING btree (username, domain);


--
-- Name: sip_trace_callid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sip_trace_callid_idx ON sip_trace USING btree (callid);


--
-- Name: sip_trace_date_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sip_trace_date_idx ON sip_trace USING btree (time_stamp);


--
-- Name: sip_trace_fromip_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sip_trace_fromip_idx ON sip_trace USING btree (fromip);


--
-- Name: sip_trace_traced_user_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sip_trace_traced_user_idx ON sip_trace USING btree (traced_user);


--
-- Name: src; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX src ON cdr USING btree (src);


--
-- Name: subscriber_username_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX subscriber_username_idx ON subscriber USING btree (username);


--
-- Name: topos_d_a_callid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topos_d_a_callid_idx ON topos_d USING btree (a_callid);


--
-- Name: topos_d_rectime_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topos_d_rectime_idx ON topos_d USING btree (rectime);


--
-- Name: topos_t_a_callid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topos_t_a_callid_idx ON topos_t USING btree (a_callid);


--
-- Name: topos_t_rectime_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX topos_t_rectime_idx ON topos_t USING btree (rectime);


--
-- Name: trusted_peer_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trusted_peer_idx ON trusted USING btree (src_ip);


--
-- Name: userblacklist_userblacklist_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX userblacklist_userblacklist_idx ON userblacklist USING btree (username, domain, prefix);


--
-- Name: usr_preferences_ua_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX usr_preferences_ua_idx ON usr_preferences USING btree (uuid, attribute);


--
-- Name: usr_preferences_uda_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX usr_preferences_uda_idx ON usr_preferences USING btree (username, domain, attribute);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: acc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE acc FROM PUBLIC;
REVOKE ALL ON TABLE acc FROM postgres;
GRANT ALL ON TABLE acc TO postgres;
GRANT ALL ON TABLE acc TO kamailio;
GRANT SELECT ON TABLE acc TO kamailioro;


--
-- Name: acc_cdrs; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE acc_cdrs FROM PUBLIC;
REVOKE ALL ON TABLE acc_cdrs FROM postgres;
GRANT ALL ON TABLE acc_cdrs TO postgres;
GRANT ALL ON TABLE acc_cdrs TO kamailio;
GRANT SELECT ON TABLE acc_cdrs TO kamailioro;


--
-- Name: acc_cdrs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE acc_cdrs_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acc_cdrs_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acc_cdrs_id_seq TO postgres;
GRANT ALL ON SEQUENCE acc_cdrs_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE acc_cdrs_id_seq TO kamailioro;


--
-- Name: acc_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE acc_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE acc_id_seq FROM postgres;
GRANT ALL ON SEQUENCE acc_id_seq TO postgres;
GRANT ALL ON SEQUENCE acc_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE acc_id_seq TO kamailioro;


--
-- Name: address; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE address FROM PUBLIC;
REVOKE ALL ON TABLE address FROM postgres;
GRANT ALL ON TABLE address TO postgres;
GRANT ALL ON TABLE address TO kamailio;
GRANT SELECT ON TABLE address TO kamailioro;


--
-- Name: address_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE address_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE address_id_seq FROM postgres;
GRANT ALL ON SEQUENCE address_id_seq TO postgres;
GRANT ALL ON SEQUENCE address_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE address_id_seq TO kamailioro;


--
-- Name: aliases; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE aliases FROM PUBLIC;
REVOKE ALL ON TABLE aliases FROM postgres;
GRANT ALL ON TABLE aliases TO postgres;
GRANT ALL ON TABLE aliases TO kamailio;
GRANT SELECT ON TABLE aliases TO kamailioro;


--
-- Name: aliases_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE aliases_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE aliases_id_seq FROM postgres;
GRANT ALL ON SEQUENCE aliases_id_seq TO postgres;
GRANT ALL ON SEQUENCE aliases_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE aliases_id_seq TO kamailioro;


--
-- Name: carrier_name; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE carrier_name FROM PUBLIC;
REVOKE ALL ON TABLE carrier_name FROM postgres;
GRANT ALL ON TABLE carrier_name TO postgres;
GRANT ALL ON TABLE carrier_name TO kamailio;
GRANT SELECT ON TABLE carrier_name TO kamailioro;


--
-- Name: carrier_name_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE carrier_name_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE carrier_name_id_seq FROM postgres;
GRANT ALL ON SEQUENCE carrier_name_id_seq TO postgres;
GRANT ALL ON SEQUENCE carrier_name_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE carrier_name_id_seq TO kamailioro;


--
-- Name: carrierfailureroute; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE carrierfailureroute FROM PUBLIC;
REVOKE ALL ON TABLE carrierfailureroute FROM postgres;
GRANT ALL ON TABLE carrierfailureroute TO postgres;
GRANT ALL ON TABLE carrierfailureroute TO kamailio;
GRANT SELECT ON TABLE carrierfailureroute TO kamailioro;


--
-- Name: carrierfailureroute_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE carrierfailureroute_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE carrierfailureroute_id_seq FROM postgres;
GRANT ALL ON SEQUENCE carrierfailureroute_id_seq TO postgres;
GRANT ALL ON SEQUENCE carrierfailureroute_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE carrierfailureroute_id_seq TO kamailioro;


--
-- Name: carrierroute; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE carrierroute FROM PUBLIC;
REVOKE ALL ON TABLE carrierroute FROM postgres;
GRANT ALL ON TABLE carrierroute TO postgres;
GRANT ALL ON TABLE carrierroute TO kamailio;
GRANT SELECT ON TABLE carrierroute TO kamailioro;


--
-- Name: carrierroute_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE carrierroute_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE carrierroute_id_seq FROM postgres;
GRANT ALL ON SEQUENCE carrierroute_id_seq TO postgres;
GRANT ALL ON SEQUENCE carrierroute_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE carrierroute_id_seq TO kamailioro;


--
-- Name: cpl; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cpl FROM PUBLIC;
REVOKE ALL ON TABLE cpl FROM postgres;
GRANT ALL ON TABLE cpl TO postgres;
GRANT ALL ON TABLE cpl TO kamailio;
GRANT SELECT ON TABLE cpl TO kamailioro;


--
-- Name: cpl_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cpl_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cpl_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cpl_id_seq TO postgres;
GRANT ALL ON SEQUENCE cpl_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE cpl_id_seq TO kamailioro;


--
-- Name: dbaliases; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dbaliases FROM PUBLIC;
REVOKE ALL ON TABLE dbaliases FROM postgres;
GRANT ALL ON TABLE dbaliases TO postgres;
GRANT ALL ON TABLE dbaliases TO kamailio;
GRANT SELECT ON TABLE dbaliases TO kamailioro;


--
-- Name: dbaliases_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dbaliases_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dbaliases_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dbaliases_id_seq TO postgres;
GRANT ALL ON SEQUENCE dbaliases_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE dbaliases_id_seq TO kamailioro;


--
-- Name: dialog; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dialog FROM PUBLIC;
REVOKE ALL ON TABLE dialog FROM postgres;
GRANT ALL ON TABLE dialog TO postgres;
GRANT ALL ON TABLE dialog TO kamailio;
GRANT SELECT ON TABLE dialog TO kamailioro;


--
-- Name: dialog_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dialog_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dialog_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dialog_id_seq TO postgres;
GRANT ALL ON SEQUENCE dialog_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE dialog_id_seq TO kamailioro;


--
-- Name: dialog_vars; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dialog_vars FROM PUBLIC;
REVOKE ALL ON TABLE dialog_vars FROM postgres;
GRANT ALL ON TABLE dialog_vars TO postgres;
GRANT ALL ON TABLE dialog_vars TO kamailio;
GRANT SELECT ON TABLE dialog_vars TO kamailioro;


--
-- Name: dialog_vars_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dialog_vars_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dialog_vars_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dialog_vars_id_seq TO postgres;
GRANT ALL ON SEQUENCE dialog_vars_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE dialog_vars_id_seq TO kamailioro;


--
-- Name: dialplan; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dialplan FROM PUBLIC;
REVOKE ALL ON TABLE dialplan FROM postgres;
GRANT ALL ON TABLE dialplan TO postgres;
GRANT ALL ON TABLE dialplan TO kamailio;
GRANT SELECT ON TABLE dialplan TO kamailioro;


--
-- Name: dialplan_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dialplan_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dialplan_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dialplan_id_seq TO postgres;
GRANT ALL ON SEQUENCE dialplan_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE dialplan_id_seq TO kamailioro;


--
-- Name: dispatcher; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dispatcher FROM PUBLIC;
REVOKE ALL ON TABLE dispatcher FROM postgres;
GRANT ALL ON TABLE dispatcher TO postgres;
GRANT ALL ON TABLE dispatcher TO kamailio;
GRANT SELECT ON TABLE dispatcher TO kamailioro;


--
-- Name: dispatcher_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dispatcher_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dispatcher_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dispatcher_id_seq TO postgres;
GRANT ALL ON SEQUENCE dispatcher_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE dispatcher_id_seq TO kamailioro;


--
-- Name: domain; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE domain FROM PUBLIC;
REVOKE ALL ON TABLE domain FROM postgres;
GRANT ALL ON TABLE domain TO postgres;
GRANT ALL ON TABLE domain TO kamailio;
GRANT SELECT ON TABLE domain TO kamailioro;


--
-- Name: domain_attrs; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE domain_attrs FROM PUBLIC;
REVOKE ALL ON TABLE domain_attrs FROM postgres;
GRANT ALL ON TABLE domain_attrs TO postgres;
GRANT ALL ON TABLE domain_attrs TO kamailio;
GRANT SELECT ON TABLE domain_attrs TO kamailioro;


--
-- Name: domain_attrs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE domain_attrs_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE domain_attrs_id_seq FROM postgres;
GRANT ALL ON SEQUENCE domain_attrs_id_seq TO postgres;
GRANT ALL ON SEQUENCE domain_attrs_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE domain_attrs_id_seq TO kamailioro;


--
-- Name: domain_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE domain_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE domain_id_seq FROM postgres;
GRANT ALL ON SEQUENCE domain_id_seq TO postgres;
GRANT ALL ON SEQUENCE domain_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE domain_id_seq TO kamailioro;


--
-- Name: domain_name; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE domain_name FROM PUBLIC;
REVOKE ALL ON TABLE domain_name FROM postgres;
GRANT ALL ON TABLE domain_name TO postgres;
GRANT ALL ON TABLE domain_name TO kamailio;
GRANT SELECT ON TABLE domain_name TO kamailioro;


--
-- Name: domain_name_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE domain_name_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE domain_name_id_seq FROM postgres;
GRANT ALL ON SEQUENCE domain_name_id_seq TO postgres;
GRANT ALL ON SEQUENCE domain_name_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE domain_name_id_seq TO kamailioro;


--
-- Name: domainpolicy; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE domainpolicy FROM PUBLIC;
REVOKE ALL ON TABLE domainpolicy FROM postgres;
GRANT ALL ON TABLE domainpolicy TO postgres;
GRANT ALL ON TABLE domainpolicy TO kamailio;
GRANT SELECT ON TABLE domainpolicy TO kamailioro;


--
-- Name: domainpolicy_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE domainpolicy_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE domainpolicy_id_seq FROM postgres;
GRANT ALL ON SEQUENCE domainpolicy_id_seq TO postgres;
GRANT ALL ON SEQUENCE domainpolicy_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE domainpolicy_id_seq TO kamailioro;


--
-- Name: globalblacklist; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE globalblacklist FROM PUBLIC;
REVOKE ALL ON TABLE globalblacklist FROM postgres;
GRANT ALL ON TABLE globalblacklist TO postgres;
GRANT ALL ON TABLE globalblacklist TO kamailio;
GRANT SELECT ON TABLE globalblacklist TO kamailioro;


--
-- Name: globalblacklist_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE globalblacklist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE globalblacklist_id_seq FROM postgres;
GRANT ALL ON SEQUENCE globalblacklist_id_seq TO postgres;
GRANT ALL ON SEQUENCE globalblacklist_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE globalblacklist_id_seq TO kamailioro;


--
-- Name: grp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE grp FROM PUBLIC;
REVOKE ALL ON TABLE grp FROM postgres;
GRANT ALL ON TABLE grp TO postgres;
GRANT ALL ON TABLE grp TO kamailio;
GRANT SELECT ON TABLE grp TO kamailioro;


--
-- Name: grp_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE grp_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE grp_id_seq FROM postgres;
GRANT ALL ON SEQUENCE grp_id_seq TO postgres;
GRANT ALL ON SEQUENCE grp_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE grp_id_seq TO kamailioro;


--
-- Name: htable; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE htable FROM PUBLIC;
REVOKE ALL ON TABLE htable FROM postgres;
GRANT ALL ON TABLE htable TO postgres;
GRANT ALL ON TABLE htable TO kamailio;
GRANT SELECT ON TABLE htable TO kamailioro;


--
-- Name: htable_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE htable_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE htable_id_seq FROM postgres;
GRANT ALL ON SEQUENCE htable_id_seq TO postgres;
GRANT ALL ON SEQUENCE htable_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE htable_id_seq TO kamailioro;


--
-- Name: imc_members; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE imc_members FROM PUBLIC;
REVOKE ALL ON TABLE imc_members FROM postgres;
GRANT ALL ON TABLE imc_members TO postgres;
GRANT ALL ON TABLE imc_members TO kamailio;
GRANT SELECT ON TABLE imc_members TO kamailioro;


--
-- Name: imc_members_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE imc_members_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE imc_members_id_seq FROM postgres;
GRANT ALL ON SEQUENCE imc_members_id_seq TO postgres;
GRANT ALL ON SEQUENCE imc_members_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE imc_members_id_seq TO kamailioro;


--
-- Name: imc_rooms; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE imc_rooms FROM PUBLIC;
REVOKE ALL ON TABLE imc_rooms FROM postgres;
GRANT ALL ON TABLE imc_rooms TO postgres;
GRANT ALL ON TABLE imc_rooms TO kamailio;
GRANT SELECT ON TABLE imc_rooms TO kamailioro;


--
-- Name: imc_rooms_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE imc_rooms_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE imc_rooms_id_seq FROM postgres;
GRANT ALL ON SEQUENCE imc_rooms_id_seq TO postgres;
GRANT ALL ON SEQUENCE imc_rooms_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE imc_rooms_id_seq TO kamailioro;


--
-- Name: lcr_gw; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE lcr_gw FROM PUBLIC;
REVOKE ALL ON TABLE lcr_gw FROM postgres;
GRANT ALL ON TABLE lcr_gw TO postgres;
GRANT ALL ON TABLE lcr_gw TO kamailio;
GRANT SELECT ON TABLE lcr_gw TO kamailioro;


--
-- Name: lcr_gw_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE lcr_gw_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lcr_gw_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lcr_gw_id_seq TO postgres;
GRANT ALL ON SEQUENCE lcr_gw_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE lcr_gw_id_seq TO kamailioro;


--
-- Name: lcr_rule; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE lcr_rule FROM PUBLIC;
REVOKE ALL ON TABLE lcr_rule FROM postgres;
GRANT ALL ON TABLE lcr_rule TO postgres;
GRANT ALL ON TABLE lcr_rule TO kamailio;
GRANT SELECT ON TABLE lcr_rule TO kamailioro;


--
-- Name: lcr_rule_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE lcr_rule_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lcr_rule_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lcr_rule_id_seq TO postgres;
GRANT ALL ON SEQUENCE lcr_rule_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE lcr_rule_id_seq TO kamailioro;


--
-- Name: lcr_rule_target; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE lcr_rule_target FROM PUBLIC;
REVOKE ALL ON TABLE lcr_rule_target FROM postgres;
GRANT ALL ON TABLE lcr_rule_target TO postgres;
GRANT ALL ON TABLE lcr_rule_target TO kamailio;
GRANT SELECT ON TABLE lcr_rule_target TO kamailioro;


--
-- Name: lcr_rule_target_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE lcr_rule_target_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE lcr_rule_target_id_seq FROM postgres;
GRANT ALL ON SEQUENCE lcr_rule_target_id_seq TO postgres;
GRANT ALL ON SEQUENCE lcr_rule_target_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE lcr_rule_target_id_seq TO kamailioro;


--
-- Name: location; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE location FROM PUBLIC;
REVOKE ALL ON TABLE location FROM postgres;
GRANT ALL ON TABLE location TO postgres;
GRANT ALL ON TABLE location TO kamailio;
GRANT SELECT ON TABLE location TO kamailioro;


--
-- Name: location_attrs; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE location_attrs FROM PUBLIC;
REVOKE ALL ON TABLE location_attrs FROM postgres;
GRANT ALL ON TABLE location_attrs TO postgres;
GRANT ALL ON TABLE location_attrs TO kamailio;
GRANT SELECT ON TABLE location_attrs TO kamailioro;


--
-- Name: location_attrs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE location_attrs_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE location_attrs_id_seq FROM postgres;
GRANT ALL ON SEQUENCE location_attrs_id_seq TO postgres;
GRANT ALL ON SEQUENCE location_attrs_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE location_attrs_id_seq TO kamailioro;


--
-- Name: location_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE location_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE location_id_seq FROM postgres;
GRANT ALL ON SEQUENCE location_id_seq TO postgres;
GRANT ALL ON SEQUENCE location_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE location_id_seq TO kamailioro;


--
-- Name: missed_calls; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE missed_calls FROM PUBLIC;
REVOKE ALL ON TABLE missed_calls FROM postgres;
GRANT ALL ON TABLE missed_calls TO postgres;
GRANT ALL ON TABLE missed_calls TO kamailio;
GRANT SELECT ON TABLE missed_calls TO kamailioro;


--
-- Name: missed_calls_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE missed_calls_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE missed_calls_id_seq FROM postgres;
GRANT ALL ON SEQUENCE missed_calls_id_seq TO postgres;
GRANT ALL ON SEQUENCE missed_calls_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE missed_calls_id_seq TO kamailioro;


--
-- Name: mohqcalls; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mohqcalls FROM PUBLIC;
REVOKE ALL ON TABLE mohqcalls FROM postgres;
GRANT ALL ON TABLE mohqcalls TO postgres;
GRANT ALL ON TABLE mohqcalls TO kamailio;
GRANT SELECT ON TABLE mohqcalls TO kamailioro;


--
-- Name: mohqcalls_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE mohqcalls_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE mohqcalls_id_seq FROM postgres;
GRANT ALL ON SEQUENCE mohqcalls_id_seq TO postgres;
GRANT ALL ON SEQUENCE mohqcalls_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE mohqcalls_id_seq TO kamailioro;


--
-- Name: mohqueues; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mohqueues FROM PUBLIC;
REVOKE ALL ON TABLE mohqueues FROM postgres;
GRANT ALL ON TABLE mohqueues TO postgres;
GRANT ALL ON TABLE mohqueues TO kamailio;
GRANT SELECT ON TABLE mohqueues TO kamailioro;


--
-- Name: mohqueues_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE mohqueues_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE mohqueues_id_seq FROM postgres;
GRANT ALL ON SEQUENCE mohqueues_id_seq TO postgres;
GRANT ALL ON SEQUENCE mohqueues_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE mohqueues_id_seq TO kamailioro;


--
-- Name: mtree; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mtree FROM PUBLIC;
REVOKE ALL ON TABLE mtree FROM postgres;
GRANT ALL ON TABLE mtree TO postgres;
GRANT ALL ON TABLE mtree TO kamailio;
GRANT SELECT ON TABLE mtree TO kamailioro;


--
-- Name: mtree_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE mtree_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE mtree_id_seq FROM postgres;
GRANT ALL ON SEQUENCE mtree_id_seq TO postgres;
GRANT ALL ON SEQUENCE mtree_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE mtree_id_seq TO kamailioro;


--
-- Name: mtrees; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mtrees FROM PUBLIC;
REVOKE ALL ON TABLE mtrees FROM postgres;
GRANT ALL ON TABLE mtrees TO postgres;
GRANT ALL ON TABLE mtrees TO kamailio;
GRANT SELECT ON TABLE mtrees TO kamailioro;


--
-- Name: mtrees_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE mtrees_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE mtrees_id_seq FROM postgres;
GRANT ALL ON SEQUENCE mtrees_id_seq TO postgres;
GRANT ALL ON SEQUENCE mtrees_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE mtrees_id_seq TO kamailioro;


--
-- Name: pdt; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pdt FROM PUBLIC;
REVOKE ALL ON TABLE pdt FROM postgres;
GRANT ALL ON TABLE pdt TO postgres;
GRANT ALL ON TABLE pdt TO kamailio;
GRANT SELECT ON TABLE pdt TO kamailioro;


--
-- Name: pdt_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE pdt_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE pdt_id_seq FROM postgres;
GRANT ALL ON SEQUENCE pdt_id_seq TO postgres;
GRANT ALL ON SEQUENCE pdt_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE pdt_id_seq TO kamailioro;


--
-- Name: pl_pipes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pl_pipes FROM PUBLIC;
REVOKE ALL ON TABLE pl_pipes FROM postgres;
GRANT ALL ON TABLE pl_pipes TO postgres;
GRANT ALL ON TABLE pl_pipes TO kamailio;
GRANT SELECT ON TABLE pl_pipes TO kamailioro;


--
-- Name: pl_pipes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE pl_pipes_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE pl_pipes_id_seq FROM postgres;
GRANT ALL ON SEQUENCE pl_pipes_id_seq TO postgres;
GRANT ALL ON SEQUENCE pl_pipes_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE pl_pipes_id_seq TO kamailioro;


--
-- Name: purplemap; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE purplemap FROM PUBLIC;
REVOKE ALL ON TABLE purplemap FROM postgres;
GRANT ALL ON TABLE purplemap TO postgres;
GRANT ALL ON TABLE purplemap TO kamailio;
GRANT SELECT ON TABLE purplemap TO kamailioro;


--
-- Name: purplemap_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE purplemap_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE purplemap_id_seq FROM postgres;
GRANT ALL ON SEQUENCE purplemap_id_seq TO postgres;
GRANT ALL ON SEQUENCE purplemap_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE purplemap_id_seq TO kamailioro;


--
-- Name: re_grp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE re_grp FROM PUBLIC;
REVOKE ALL ON TABLE re_grp FROM postgres;
GRANT ALL ON TABLE re_grp TO postgres;
GRANT ALL ON TABLE re_grp TO kamailio;
GRANT SELECT ON TABLE re_grp TO kamailioro;


--
-- Name: re_grp_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE re_grp_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE re_grp_id_seq FROM postgres;
GRANT ALL ON SEQUENCE re_grp_id_seq TO postgres;
GRANT ALL ON SEQUENCE re_grp_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE re_grp_id_seq TO kamailioro;


--
-- Name: rtpproxy; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE rtpproxy FROM PUBLIC;
REVOKE ALL ON TABLE rtpproxy FROM postgres;
GRANT ALL ON TABLE rtpproxy TO postgres;
GRANT ALL ON TABLE rtpproxy TO kamailio;
GRANT SELECT ON TABLE rtpproxy TO kamailioro;


--
-- Name: rtpproxy_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE rtpproxy_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE rtpproxy_id_seq FROM postgres;
GRANT ALL ON SEQUENCE rtpproxy_id_seq TO postgres;
GRANT ALL ON SEQUENCE rtpproxy_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE rtpproxy_id_seq TO kamailioro;


--
-- Name: sca_subscriptions; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sca_subscriptions FROM PUBLIC;
REVOKE ALL ON TABLE sca_subscriptions FROM postgres;
GRANT ALL ON TABLE sca_subscriptions TO postgres;
GRANT ALL ON TABLE sca_subscriptions TO kamailio;
GRANT SELECT ON TABLE sca_subscriptions TO kamailioro;


--
-- Name: sca_subscriptions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE sca_subscriptions_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sca_subscriptions_id_seq FROM postgres;
GRANT ALL ON SEQUENCE sca_subscriptions_id_seq TO postgres;
GRANT ALL ON SEQUENCE sca_subscriptions_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE sca_subscriptions_id_seq TO kamailioro;


--
-- Name: silo; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE silo FROM PUBLIC;
REVOKE ALL ON TABLE silo FROM postgres;
GRANT ALL ON TABLE silo TO postgres;
GRANT ALL ON TABLE silo TO kamailio;
GRANT SELECT ON TABLE silo TO kamailioro;


--
-- Name: silo_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE silo_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE silo_id_seq FROM postgres;
GRANT ALL ON SEQUENCE silo_id_seq TO postgres;
GRANT ALL ON SEQUENCE silo_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE silo_id_seq TO kamailioro;


--
-- Name: sip_trace; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sip_trace FROM PUBLIC;
REVOKE ALL ON TABLE sip_trace FROM postgres;
GRANT ALL ON TABLE sip_trace TO postgres;
GRANT ALL ON TABLE sip_trace TO kamailio;
GRANT SELECT ON TABLE sip_trace TO kamailioro;


--
-- Name: sip_trace_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE sip_trace_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sip_trace_id_seq FROM postgres;
GRANT ALL ON SEQUENCE sip_trace_id_seq TO postgres;
GRANT ALL ON SEQUENCE sip_trace_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE sip_trace_id_seq TO kamailioro;


--
-- Name: speed_dial; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE speed_dial FROM PUBLIC;
REVOKE ALL ON TABLE speed_dial FROM postgres;
GRANT ALL ON TABLE speed_dial TO postgres;
GRANT ALL ON TABLE speed_dial TO kamailio;
GRANT SELECT ON TABLE speed_dial TO kamailioro;


--
-- Name: speed_dial_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE speed_dial_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE speed_dial_id_seq FROM postgres;
GRANT ALL ON SEQUENCE speed_dial_id_seq TO postgres;
GRANT ALL ON SEQUENCE speed_dial_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE speed_dial_id_seq TO kamailioro;


--
-- Name: subscriber; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE subscriber FROM PUBLIC;
REVOKE ALL ON TABLE subscriber FROM postgres;
GRANT ALL ON TABLE subscriber TO postgres;
GRANT ALL ON TABLE subscriber TO kamailio;
GRANT SELECT ON TABLE subscriber TO kamailioro;


--
-- Name: subscriber_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE subscriber_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE subscriber_id_seq FROM postgres;
GRANT ALL ON SEQUENCE subscriber_id_seq TO postgres;
GRANT ALL ON SEQUENCE subscriber_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE subscriber_id_seq TO kamailioro;


--
-- Name: topos_d; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE topos_d FROM PUBLIC;
REVOKE ALL ON TABLE topos_d FROM postgres;
GRANT ALL ON TABLE topos_d TO postgres;
GRANT ALL ON TABLE topos_d TO kamailio;
GRANT SELECT ON TABLE topos_d TO kamailioro;


--
-- Name: topos_d_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE topos_d_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE topos_d_id_seq FROM postgres;
GRANT ALL ON SEQUENCE topos_d_id_seq TO postgres;
GRANT ALL ON SEQUENCE topos_d_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE topos_d_id_seq TO kamailioro;


--
-- Name: topos_t; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE topos_t FROM PUBLIC;
REVOKE ALL ON TABLE topos_t FROM postgres;
GRANT ALL ON TABLE topos_t TO postgres;
GRANT ALL ON TABLE topos_t TO kamailio;
GRANT SELECT ON TABLE topos_t TO kamailioro;


--
-- Name: topos_t_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE topos_t_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE topos_t_id_seq FROM postgres;
GRANT ALL ON SEQUENCE topos_t_id_seq TO postgres;
GRANT ALL ON SEQUENCE topos_t_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE topos_t_id_seq TO kamailioro;


--
-- Name: trusted; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trusted FROM PUBLIC;
REVOKE ALL ON TABLE trusted FROM postgres;
GRANT ALL ON TABLE trusted TO postgres;
GRANT ALL ON TABLE trusted TO kamailio;
GRANT SELECT ON TABLE trusted TO kamailioro;


--
-- Name: trusted_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE trusted_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE trusted_id_seq FROM postgres;
GRANT ALL ON SEQUENCE trusted_id_seq TO postgres;
GRANT ALL ON SEQUENCE trusted_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE trusted_id_seq TO kamailioro;


--
-- Name: uacreg; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE uacreg FROM PUBLIC;
REVOKE ALL ON TABLE uacreg FROM postgres;
GRANT ALL ON TABLE uacreg TO postgres;
GRANT ALL ON TABLE uacreg TO kamailio;
GRANT SELECT ON TABLE uacreg TO kamailioro;


--
-- Name: uacreg_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE uacreg_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE uacreg_id_seq FROM postgres;
GRANT ALL ON SEQUENCE uacreg_id_seq TO postgres;
GRANT ALL ON SEQUENCE uacreg_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE uacreg_id_seq TO kamailioro;


--
-- Name: uri; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE uri FROM PUBLIC;
REVOKE ALL ON TABLE uri FROM postgres;
GRANT ALL ON TABLE uri TO postgres;
GRANT ALL ON TABLE uri TO kamailio;
GRANT SELECT ON TABLE uri TO kamailioro;


--
-- Name: uri_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE uri_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE uri_id_seq FROM postgres;
GRANT ALL ON SEQUENCE uri_id_seq TO postgres;
GRANT ALL ON SEQUENCE uri_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE uri_id_seq TO kamailioro;


--
-- Name: userblacklist; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE userblacklist FROM PUBLIC;
REVOKE ALL ON TABLE userblacklist FROM postgres;
GRANT ALL ON TABLE userblacklist TO postgres;
GRANT ALL ON TABLE userblacklist TO kamailio;
GRANT SELECT ON TABLE userblacklist TO kamailioro;


--
-- Name: userblacklist_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE userblacklist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE userblacklist_id_seq FROM postgres;
GRANT ALL ON SEQUENCE userblacklist_id_seq TO postgres;
GRANT ALL ON SEQUENCE userblacklist_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE userblacklist_id_seq TO kamailioro;


--
-- Name: usr_preferences; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE usr_preferences FROM PUBLIC;
REVOKE ALL ON TABLE usr_preferences FROM postgres;
GRANT ALL ON TABLE usr_preferences TO postgres;
GRANT ALL ON TABLE usr_preferences TO kamailio;
GRANT SELECT ON TABLE usr_preferences TO kamailioro;


--
-- Name: usr_preferences_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE usr_preferences_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE usr_preferences_id_seq FROM postgres;
GRANT ALL ON SEQUENCE usr_preferences_id_seq TO postgres;
GRANT ALL ON SEQUENCE usr_preferences_id_seq TO kamailio;
GRANT SELECT ON SEQUENCE usr_preferences_id_seq TO kamailioro;


--
-- Name: version; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE version FROM PUBLIC;
REVOKE ALL ON TABLE version FROM postgres;
GRANT ALL ON TABLE version TO postgres;
GRANT ALL ON TABLE version TO kamailio;
GRANT SELECT ON TABLE version TO kamailioro;


--
-- PostgreSQL database dump complete
--

