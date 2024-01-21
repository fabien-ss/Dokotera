--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: association_symptome_maladie; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.association_symptome_maladie (
    id_target character varying(20),
    id_symptome character varying(20),
    intervalle_min integer,
    intervalle_max integer
);


ALTER TABLE public.association_symptome_maladie OWNER TO your_username;

--
-- Name: association_symptome_medicament; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.association_symptome_medicament (
    id_association_medicament_symptome character varying(20) NOT NULL,
    id_target character varying(20),
    id_symptome character varying(20),
    effet integer NOT NULL
);


ALTER TABLE public.association_symptome_medicament OWNER TO your_username;

--
-- Name: effet_association_medicament_symptome; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.effet_association_medicament_symptome (
    id_effet character varying(20),
    id_target_symptome character varying(20),
    effet integer NOT NULL
);


ALTER TABLE public.effet_association_medicament_symptome OWNER TO your_username;

--
-- Name: maladie; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.maladie (
    id_maladie character varying(20) NOT NULL,
    nom character varying(200)
);


ALTER TABLE public.maladie OWNER TO your_username;

--
-- Name: medicament; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.medicament (
    id_medicament character varying(20) NOT NULL,
    nom character varying(200)
);


ALTER TABLE public.medicament OWNER TO your_username;

--
-- Name: patient; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.patient (
    id_patient character varying(20) NOT NULL,
    nom character varying(200) NOT NULL
);


ALTER TABLE public.patient OWNER TO your_username;

--
-- Name: patient_symptome; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.patient_symptome (
    id_patient character varying(20),
    id_symptome character varying(20),
    etat integer NOT NULL,
    date_consultation timestamp without time zone DEFAULT now(),
    id character varying(20) NOT NULL,
    column_name integer
);


ALTER TABLE public.patient_symptome OWNER TO your_username;

--
-- Name: prix_medicament; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.prix_medicament (
    id_medicament character varying(20),
    prix double precision,
    date_prix timestamp without time zone DEFAULT now()
);


ALTER TABLE public.prix_medicament OWNER TO your_username;

--
-- Name: seq_association_symptome_medicament; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_association_symptome_medicament
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_association_symptome_medicament OWNER TO your_username;

--
-- Name: seq_maladie; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_maladie
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_maladie OWNER TO your_username;

--
-- Name: seq_medicament; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_medicament
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_medicament OWNER TO your_username;

--
-- Name: seq_patient; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_patient
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_patient OWNER TO your_username;

--
-- Name: seq_ps; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_ps
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_ps OWNER TO your_username;

--
-- Name: seq_symptome; Type: SEQUENCE; Schema: public; Owner: your_username
--

CREATE SEQUENCE public.seq_symptome
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_symptome OWNER TO your_username;

--
-- Name: symptome; Type: TABLE; Schema: public; Owner: your_username
--

CREATE TABLE public.symptome (
    id_symptome character varying(20) NOT NULL,
    nom character varying(200)
);


ALTER TABLE public.symptome OWNER TO your_username;

--
-- Name: v_date_dernier_symptome_patient; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_date_dernier_symptome_patient AS
 SELECT p.id_patient,
    max(ps.date_consultation) AS derniere_date
   FROM (public.patient p
     JOIN public.patient_symptome ps ON (((p.id_patient)::text = (ps.id_patient)::text)))
  GROUP BY p.id_patient;


ALTER VIEW public.v_date_dernier_symptome_patient OWNER TO your_username;

--
-- Name: v_derniers_symptomes; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_derniers_symptomes AS
 SELECT ps.id_patient,
    ps.id_symptome,
    ps.etat,
    ps.date_consultation
   FROM (public.v_date_dernier_symptome_patient vddp
     JOIN public.patient_symptome ps ON ((((vddp.id_patient)::text = (ps.id_patient)::text) AND (ps.date_consultation = vddp.derniere_date))));


ALTER VIEW public.v_derniers_symptomes OWNER TO your_username;

--
-- Name: v_maladie_patient; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_maladie_patient AS
 SELECT vds.etat,
    vds.id_symptome,
    vds.id_patient,
    asm.intervalle_min,
    asm.intervalle_max,
    asm.id_target AS maladie,
    (vds.etat - asm.intervalle_min) AS min,
    (vds.etat - asm.intervalle_max) AS max
   FROM (public.v_derniers_symptomes vds
     JOIN public.association_symptome_maladie asm ON (((vds.id_symptome)::text = (asm.id_symptome)::text)));


ALTER VIEW public.v_maladie_patient OWNER TO your_username;

--
-- Name: v_maladie_patient2; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_maladie_patient2 AS
 SELECT vds.etat,
    vds.id_symptome,
    vds.id_patient AS id_target,
    asm.intervalle_min,
    asm.intervalle_max,
    asm.id_target AS id_maladie,
        CASE
            WHEN ((((asm.intervalle_max + asm.intervalle_min))::double precision / (2)::double precision) > (vds.etat)::double precision) THEN ((((asm.intervalle_max + asm.intervalle_min))::double precision / (2)::double precision) - (vds.etat)::double precision)
            WHEN ((((asm.intervalle_max + asm.intervalle_min))::double precision / (2)::double precision) <= (vds.etat)::double precision) THEN ((vds.etat)::double precision - (((asm.intervalle_max + asm.intervalle_min))::double precision / (2)::double precision))
            ELSE NULL::double precision
        END AS valeur,
    (((asm.intervalle_max + asm.intervalle_min))::double precision / (2)::double precision) AS max_valeur
   FROM (public.v_derniers_symptomes vds
     JOIN public.association_symptome_maladie asm ON (((vds.id_symptome)::text = (asm.id_symptome)::text)));


ALTER VIEW public.v_maladie_patient2 OWNER TO your_username;

--
-- Name: v_nombre_patient_symptome; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_nombre_patient_symptome AS
 SELECT count(id_symptome) AS nombre,
    id_maladie,
    id_target,
    sum(valeur) AS score,
    sum(max_valeur) AS total
   FROM public.v_maladie_patient2 vmp
  GROUP BY id_maladie, id_target;


ALTER VIEW public.v_nombre_patient_symptome OWNER TO your_username;

--
-- Name: v_nombre_symptome_maladie; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_nombre_symptome_maladie AS
 SELECT count(id_symptome) AS nombre,
    id_target
   FROM public.association_symptome_maladie asm
  GROUP BY id_target;


ALTER VIEW public.v_nombre_symptome_maladie OWNER TO your_username;

--
-- Name: v_maladie_patient_match; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_maladie_patient_match AS
 SELECT (vnsm.nombre)::integer AS nombre,
    (vnps.nombre)::integer AS nb_symptome,
    vnsm.id_target AS id_maladie,
    vnps.id_target AS id_patient,
    ((vnps.score * (100)::double precision) / vnps.total) AS score
   FROM (public.v_nombre_symptome_maladie vnsm
     JOIN public.v_nombre_patient_symptome vnps ON (((vnsm.id_target)::text = (vnps.id_maladie)::text)))
  ORDER BY vnps.score;


ALTER VIEW public.v_maladie_patient_match OWNER TO your_username;

--
-- Name: v_medicament_prix; Type: VIEW; Schema: public; Owner: your_username
--

CREATE VIEW public.v_medicament_prix AS
 SELECT m.id_medicament,
    m.nom,
    pm.prix
   FROM (public.medicament m
     JOIN public.prix_medicament pm ON (((m.id_medicament)::text = (pm.id_medicament)::text)));


ALTER VIEW public.v_medicament_prix OWNER TO your_username;

--
-- Data for Name: association_symptome_maladie; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.association_symptome_maladie (id_target, id_symptome, intervalle_min, intervalle_max) FROM stdin;
MAD001	SYMP002	5	6
MAD001	SYMP001	4	5
MAD001	SYMP003	5	6
MAD002	SYMP003	5	5
MAD002	SYMP001	4	4
MAD002	SYMP002	5	6
MAD003	SYMP003	6	6
MAD003	SYMP001	6	6
MAD003	SYMP002	6	6
\.


--
-- Data for Name: association_symptome_medicament; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.association_symptome_medicament (id_association_medicament_symptome, id_target, id_symptome, effet) FROM stdin;
ASSOC003	MED001	SYMP003	2
ASSOC005	MED002	SYMP002	5
ASSOC002	MED001	SYMP002	2
ASSOC004	MED002	SYMP001	2
ASSOC008	MED003	SYMP002	0
ASSOC007	MED003	SYMP001	5
ASSOC009	MED003	SYMP003	0
ASSOC001	MED001	SYMP001	0
ASSOC006	MED002	SYMP003	0
\.


--
-- Data for Name: effet_association_medicament_symptome; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.effet_association_medicament_symptome (id_effet, id_target_symptome, effet) FROM stdin;
ASSOC001	SYMP002	4
ASSOC002	SYMP001	2
ASSOC003	SYMP001	1
ASSOC004	SYMP003	5
ASSOC005	SYMP003	1
ASSOC006	SYMP003	2
ASSOC007	SYMP001	6
ASSOC008	SYMP002	1
ASSOC009	SYMP002	4
\.


--
-- Data for Name: maladie; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.maladie (id_maladie, nom) FROM stdin;
MAD001	Paludisme
MAD002	Calcul
MAD003	Rein
MAD01	TA
\.


--
-- Data for Name: medicament; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.medicament (id_medicament, nom) FROM stdin;
MED001	PARACETAMOL
MED002	DOLIPRANE
MED003	CHARBON
\.


--
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.patient (id_patient, nom) FROM stdin;
PAT001	KOTO
PAT002	Meva
PAT003	Xavier
\.


--
-- Data for Name: patient_symptome; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.patient_symptome (id_patient, id_symptome, etat, date_consultation, id, column_name) FROM stdin;
PAT001	SYMP001	5	2024-01-21 08:23:44.329041	PS106	\N
PAT001	SYMP002	7	2024-01-21 08:23:44.329041	PS107	\N
PAT001	SYMP003	7	2024-01-21 08:23:44.329041	PS108	\N
PAT001	SYMP001	4	2024-01-21 06:48:20.396919	PS016	\N
PAT001	SYMP002	7	2024-01-21 06:48:20.396919	PS017	\N
PAT001	SYMP003	2	2024-01-21 06:48:20.396919	PS018	\N
PAT001	SYMP001	4	2024-01-21 06:49:58.079016	PS019	\N
PAT001	SYMP002	2	2024-01-21 06:49:58.079016	PS020	\N
PAT001	SYMP003	2	2024-01-21 06:49:58.079016	PS021	\N
PAT001	SYMP001	6	2024-01-21 07:06:27.441378	PS022	\N
PAT001	SYMP002	6	2024-01-21 07:06:27.441378	PS023	\N
PAT001	SYMP003	6	2024-01-21 07:06:27.441378	PS024	\N
PAT001	SYMP001	6	2024-01-21 07:06:48.596315	PS025	\N
PAT001	SYMP002	6	2024-01-21 07:06:48.596315	PS026	\N
PAT001	SYMP003	6	2024-01-21 07:06:48.596315	PS027	\N
PAT001	SYMP001	6	2024-01-21 07:10:07.91179	PS028	\N
PAT001	SYMP002	6	2024-01-21 07:10:07.91179	PS029	\N
PAT001	SYMP003	6	2024-01-21 07:10:07.91179	PS030	\N
PAT001	SYMP001	6	2024-01-21 07:10:36.511209	PS031	\N
PAT001	SYMP002	6	2024-01-21 07:10:36.511209	PS032	\N
PAT001	SYMP003	6	2024-01-21 07:10:36.511209	PS033	\N
PAT001	SYMP001	6	2024-01-21 07:25:54.934574	PS034	\N
PAT001	SYMP002	6	2024-01-21 07:25:54.934574	PS035	\N
PAT001	SYMP003	6	2024-01-21 07:25:54.934574	PS036	\N
PAT001	SYMP001	45	2024-01-21 07:29:12.082783	PS037	\N
PAT001	SYMP002	0	2024-01-21 07:29:12.082783	PS038	\N
PAT001	SYMP003	0	2024-01-21 07:29:12.082783	PS039	\N
PAT001	SYMP001	4	2024-01-21 07:31:06.381452	PS040	\N
PAT001	SYMP002	5	2024-01-21 07:31:06.381452	PS041	\N
PAT001	SYMP003	5	2024-01-21 07:31:06.381452	PS042	\N
PAT001	SYMP001	4	2024-01-21 07:31:49.632781	PS043	\N
PAT001	SYMP002	5	2024-01-21 07:31:49.632781	PS044	\N
PAT001	SYMP003	5	2024-01-21 07:31:49.632781	PS045	\N
PAT001	SYMP001	4	2024-01-21 07:35:57.403367	PS046	\N
PAT001	SYMP002	5	2024-01-21 07:35:57.403367	PS047	\N
PAT001	SYMP003	5	2024-01-21 07:35:57.403367	PS048	\N
PAT001	SYMP001	4	2024-01-21 07:36:16.26203	PS049	\N
PAT001	SYMP002	5	2024-01-21 07:36:16.26203	PS050	\N
PAT001	SYMP003	5	2024-01-21 07:36:16.26203	PS051	\N
PAT001	SYMP001	4	2024-01-21 07:38:00.54865	PS052	\N
PAT001	SYMP002	5	2024-01-21 07:38:00.54865	PS053	\N
PAT001	SYMP003	5	2024-01-21 07:38:00.54865	PS054	\N
PAT001	SYMP001	4	2024-01-21 07:39:05.994861	PS055	\N
PAT001	SYMP002	5	2024-01-21 07:39:05.994861	PS056	\N
PAT001	SYMP003	5	2024-01-21 07:39:05.994861	PS057	\N
PAT001	SYMP001	4	2024-01-21 07:40:42.730858	PS058	\N
PAT001	SYMP002	5	2024-01-21 07:40:42.730858	PS059	\N
PAT001	SYMP003	5	2024-01-21 07:40:42.730858	PS060	\N
PAT001	SYMP001	4	2024-01-21 07:42:05.050625	PS061	\N
PAT001	SYMP002	5	2024-01-21 07:42:05.050625	PS062	\N
PAT001	SYMP003	5	2024-01-21 07:42:05.050625	PS063	\N
PAT001	SYMP001	4	2024-01-21 07:42:47.644488	PS064	\N
PAT001	SYMP002	5	2024-01-21 07:42:47.644488	PS065	\N
PAT001	SYMP003	5	2024-01-21 07:42:47.644488	PS066	\N
PAT001	SYMP001	4	2024-01-21 07:42:50.916747	PS067	\N
PAT001	SYMP002	5	2024-01-21 07:42:50.916747	PS068	\N
PAT001	SYMP003	5	2024-01-21 07:42:50.916747	PS069	\N
PAT001	SYMP001	4	2024-01-21 07:43:10.153433	PS070	\N
PAT001	SYMP002	5	2024-01-21 07:43:10.153433	PS071	\N
PAT001	SYMP003	5	2024-01-21 07:43:10.153433	PS072	\N
PAT001	SYMP001	4	2024-01-21 07:43:21.07318	PS073	\N
PAT001	SYMP002	5	2024-01-21 07:43:21.07318	PS074	\N
PAT001	SYMP003	5	2024-01-21 07:43:21.07318	PS075	\N
PAT001	SYMP001	4	2024-01-21 07:50:01.467264	PS076	\N
PAT001	SYMP002	5	2024-01-21 07:50:01.467264	PS077	\N
PAT001	SYMP003	5	2024-01-21 07:50:01.467264	PS078	\N
PAT001	SYMP001	4	2024-01-21 07:50:02.600384	PS079	\N
PAT001	SYMP002	5	2024-01-21 07:50:02.600384	PS080	\N
PAT001	SYMP003	5	2024-01-21 07:50:02.600384	PS081	\N
PAT001	SYMP001	4	2024-01-21 07:59:00.592826	PS082	\N
PAT001	SYMP002	5	2024-01-21 07:59:00.592826	PS083	\N
PAT001	SYMP003	5	2024-01-21 07:59:00.592826	PS084	\N
PAT001	SYMP001	4	2024-01-21 07:59:38.242693	PS085	\N
PAT001	SYMP002	5	2024-01-21 07:59:38.242693	PS086	\N
PAT001	SYMP003	5	2024-01-21 07:59:38.242693	PS087	\N
PAT002	SYMP001	1	2024-01-21 08:01:42.332252	PS088	\N
PAT002	SYMP002	8	2024-01-21 08:01:42.332252	PS089	\N
PAT002	SYMP003	5	2024-01-21 08:01:42.332252	PS090	\N
PAT002	SYMP001	1	2024-01-21 08:02:14.152348	PS091	\N
PAT002	SYMP002	8	2024-01-21 08:02:14.152348	PS092	\N
PAT002	SYMP003	5	2024-01-21 08:02:14.152348	PS093	\N
PAT002	SYMP001	5	2024-01-21 08:05:39.511855	PS094	\N
PAT002	SYMP002	5	2024-01-21 08:05:39.511855	PS095	\N
PAT002	SYMP003	5	2024-01-21 08:05:39.511855	PS096	\N
PAT002	SYMP001	5	2024-01-21 08:07:45.328517	PS097	\N
PAT002	SYMP002	5	2024-01-21 08:07:45.328517	PS098	\N
PAT002	SYMP003	5	2024-01-21 08:07:45.328517	PS099	\N
PAT002	SYMP001	7	2024-01-21 08:14:51.428787	PS100	\N
PAT002	SYMP002	5	2024-01-21 08:14:51.428787	PS101	\N
PAT002	SYMP003	5	2024-01-21 08:14:51.428787	PS102	\N
PAT002	SYMP001	7	2024-01-21 08:15:19.431139	PS103	\N
PAT002	SYMP002	9	2024-01-21 08:15:19.431139	PS104	\N
PAT002	SYMP003	5	2024-01-21 08:15:19.431139	PS105	\N
PAT001	SYMP001	5	2024-01-21 08:25:37.650844	PS109	\N
PAT001	SYMP002	7	2024-01-21 08:25:37.650844	PS110	\N
PAT001	SYMP003	7	2024-01-21 08:25:37.650844	PS111	\N
PAT001	SYMP001	6	2024-01-21 08:32:13.812159	PS112	\N
PAT001	SYMP002	7	2024-01-21 08:32:13.812159	PS113	\N
PAT001	SYMP003	7	2024-01-21 08:32:13.812159	PS114	\N
PAT001	SYMP001	6	2024-01-21 08:32:22.656769	PS115	\N
PAT001	SYMP002	10	2024-01-21 08:32:22.656769	PS116	\N
PAT001	SYMP003	7	2024-01-21 08:32:22.656769	PS117	\N
PAT001	SYMP001	6	2024-01-21 08:40:04.656368	PS118	\N
PAT001	SYMP002	10	2024-01-21 08:40:04.656368	PS119	\N
PAT001	SYMP003	7	2024-01-21 08:40:04.656368	PS120	\N
PAT001	SYMP001	6	2024-01-21 08:40:36.274619	PS121	\N
PAT001	SYMP002	10	2024-01-21 08:40:36.274619	PS122	\N
PAT001	SYMP003	7	2024-01-21 08:40:36.274619	PS123	\N
PAT001	SYMP001	6	2024-01-21 08:41:33.243521	PS124	\N
PAT001	SYMP002	10	2024-01-21 08:41:33.243521	PS125	\N
PAT001	SYMP003	7	2024-01-21 08:41:33.243521	PS126	\N
PAT001	SYMP001	6	2024-01-21 08:41:34.349887	PS127	\N
PAT001	SYMP002	10	2024-01-21 08:41:34.349887	PS128	\N
PAT001	SYMP003	7	2024-01-21 08:41:34.349887	PS129	\N
PAT001	SYMP001	6	2024-01-21 08:41:37.689955	PS130	\N
PAT001	SYMP002	10	2024-01-21 08:41:37.689955	PS131	\N
PAT001	SYMP003	7	2024-01-21 08:41:37.689955	PS132	\N
PAT001	SYMP001	6	2024-01-21 08:43:06.270495	PS133	\N
PAT001	SYMP002	10	2024-01-21 08:43:06.270495	PS134	\N
PAT001	SYMP003	7	2024-01-21 08:43:06.270495	PS135	\N
PAT001	SYMP001	6	2024-01-21 08:45:20.767378	PS136	\N
PAT001	SYMP002	6	2024-01-21 08:45:20.767378	PS137	\N
PAT001	SYMP003	6	2024-01-21 08:45:20.767378	PS138	\N
PAT001	SYMP001	0	2024-01-21 10:47:43.847023	PS139	\N
PAT001	SYMP002	10	2024-01-21 10:47:43.847023	PS140	\N
PAT001	SYMP003	0	2024-01-21 10:47:43.847023	PS141	\N
PAT001	SYMP001	4	2024-01-21 10:49:09.256811	PS142	\N
PAT001	SYMP002	5	2024-01-21 10:49:09.256811	PS143	\N
PAT001	SYMP003	5	2024-01-21 10:49:09.256811	PS144	\N
PAT002	SYMP001	4	2024-01-21 11:13:16.037332	PS145	\N
PAT002	SYMP002	4	2024-01-21 11:13:16.037332	PS146	\N
PAT002	SYMP003	4	2024-01-21 11:13:16.037332	PS147	\N
PAT002	SYMP001	4	2024-01-21 11:14:21.013737	PS148	\N
PAT002	SYMP002	4	2024-01-21 11:14:21.013737	PS149	\N
PAT002	SYMP003	4	2024-01-21 11:14:21.013737	PS150	\N
PAT002	SYMP001	4	2024-01-21 11:14:25.580456	PS151	\N
PAT002	SYMP002	4	2024-01-21 11:14:25.580456	PS152	\N
PAT002	SYMP003	4	2024-01-21 11:14:25.580456	PS153	\N
PAT002	SYMP001	4	2024-01-21 11:14:31.505584	PS154	\N
PAT002	SYMP002	4	2024-01-21 11:14:31.505584	PS155	\N
PAT002	SYMP003	4	2024-01-21 11:14:31.505584	PS156	\N
PAT002	SYMP001	4	2024-01-21 11:14:53.770645	PS157	\N
PAT002	SYMP002	6	2024-01-21 11:14:53.770645	PS158	\N
PAT002	SYMP003	4	2024-01-21 11:14:53.770645	PS159	\N
PAT002	SYMP001	4	2024-01-21 11:19:22.217352	PS160	\N
PAT002	SYMP002	6	2024-01-21 11:19:22.217352	PS161	\N
PAT002	SYMP003	4	2024-01-21 11:19:22.217352	PS162	\N
PAT002	SYMP001	6	2024-01-21 11:19:46.870158	PS163	\N
PAT002	SYMP002	6	2024-01-21 11:19:46.870158	PS164	\N
PAT002	SYMP003	7	2024-01-21 11:19:46.870158	PS165	\N
PAT002	SYMP001	2	2024-01-21 11:21:24.545265	PS166	\N
PAT002	SYMP002	1	2024-01-21 11:21:24.545265	PS167	\N
PAT002	SYMP003	1	2024-01-21 11:21:24.545265	PS168	\N
PAT002	SYMP001	2	2024-01-21 11:23:57.030921	PS169	\N
PAT002	SYMP002	8	2024-01-21 11:23:57.030921	PS170	\N
PAT002	SYMP003	1	2024-01-21 11:23:57.030921	PS171	\N
PAT003	SYMP001	8	2024-01-21 11:39:26.593339	PS172	\N
PAT003	SYMP002	4	2024-01-21 11:39:26.593339	PS173	\N
PAT003	SYMP003	5	2024-01-21 11:39:26.593339	PS174	\N
PAT001	SYMP001	0	2024-01-21 13:05:04.721552	PS175	\N
PAT001	SYMP002	0	2024-01-21 13:05:04.721552	PS176	\N
PAT001	SYMP003	0	2024-01-21 13:05:04.721552	PS177	\N
PAT001	SYMP001	0	2024-01-21 13:05:08.275546	PS178	\N
PAT001	SYMP002	0	2024-01-21 13:05:08.275546	PS179	\N
PAT001	SYMP003	0	2024-01-21 13:05:08.275546	PS180	\N
PAT001	SYMP001	5	2024-01-21 15:29:25.739688	PS181	\N
PAT001	SYMP002	6	2024-01-21 15:29:25.739688	PS182	\N
PAT001	SYMP003	6	2024-01-21 15:29:25.739688	PS183	\N
PAT001	SYMP001	5	2024-01-21 15:30:56.01761	PS184	\N
PAT001	SYMP002	6	2024-01-21 15:30:56.01761	PS185	\N
PAT001	SYMP003	6	2024-01-21 15:30:56.01761	PS186	\N
PAT001	SYMP001	5	2024-01-21 15:32:37.885417	PS187	\N
PAT001	SYMP002	6	2024-01-21 15:32:37.885417	PS188	\N
PAT001	SYMP003	6	2024-01-21 15:32:37.885417	PS189	\N
PAT001	SYMP001	6	2024-01-21 17:58:17.056098	PS190	\N
PAT001	SYMP002	7	2024-01-21 17:58:17.056098	PS191	\N
PAT001	SYMP003	8	2024-01-21 17:58:17.056098	PS192	\N
PAT002	SYMP001	6	2024-01-21 17:59:16.736299	PS193	\N
PAT002	SYMP002	6	2024-01-21 17:59:16.736299	PS194	\N
PAT002	SYMP003	6	2024-01-21 17:59:16.736299	PS195	\N
\.


--
-- Data for Name: prix_medicament; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.prix_medicament (id_medicament, prix, date_prix) FROM stdin;
MED002	210	2024-01-21 07:13:51.06992
MED001	120	2024-01-21 07:13:51.06992
MED003	100	2024-01-21 07:13:51.06992
\.


--
-- Data for Name: symptome; Type: TABLE DATA; Schema: public; Owner: your_username
--

COPY public.symptome (id_symptome, nom) FROM stdin;
SYMP001	Maux de ventre
SYMP002	Maux de tête
SYMP003	Douleur musculaire
\.


--
-- Name: seq_association_symptome_medicament; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_association_symptome_medicament', 5, true);


--
-- Name: seq_maladie; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_maladie', 1, true);


--
-- Name: seq_medicament; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_medicament', 7, true);


--
-- Name: seq_patient; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_patient', 1, false);


--
-- Name: seq_ps; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_ps', 195, true);


--
-- Name: seq_symptome; Type: SEQUENCE SET; Schema: public; Owner: your_username
--

SELECT pg_catalog.setval('public.seq_symptome', 3, true);


--
-- Name: association_symptome_medicament association_medicament_symptome_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_medicament
    ADD CONSTRAINT association_medicament_symptome_pkey PRIMARY KEY (id_association_medicament_symptome);


--
-- Name: maladie maladie_nom_key; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.maladie
    ADD CONSTRAINT maladie_nom_key UNIQUE (nom);


--
-- Name: maladie maladie_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.maladie
    ADD CONSTRAINT maladie_pkey PRIMARY KEY (id_maladie);


--
-- Name: medicament medicament_nom_key; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.medicament
    ADD CONSTRAINT medicament_nom_key UNIQUE (nom);


--
-- Name: medicament medicament_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.medicament
    ADD CONSTRAINT medicament_pkey PRIMARY KEY (id_medicament);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id_patient);


--
-- Name: patient_symptome patient_symptome_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.patient_symptome
    ADD CONSTRAINT patient_symptome_pkey PRIMARY KEY (id);


--
-- Name: symptome symptome_nom_key; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.symptome
    ADD CONSTRAINT symptome_nom_key UNIQUE (nom);


--
-- Name: symptome symptome_pkey; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.symptome
    ADD CONSTRAINT symptome_pkey PRIMARY KEY (id_symptome);


--
-- Name: association_symptome_medicament unique_medicament_symptome; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_medicament
    ADD CONSTRAINT unique_medicament_symptome UNIQUE (id_symptome, id_target);


--
-- Name: association_symptome_maladie unique_symptome_maladie; Type: CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_maladie
    ADD CONSTRAINT unique_symptome_maladie UNIQUE (id_symptome, id_target);


--
-- Name: association_symptome_medicament association_medicament_symptome_id_medicament_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_medicament
    ADD CONSTRAINT association_medicament_symptome_id_medicament_fkey FOREIGN KEY (id_target) REFERENCES public.medicament(id_medicament);


--
-- Name: association_symptome_medicament association_medicament_symptome_id_symptome_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_medicament
    ADD CONSTRAINT association_medicament_symptome_id_symptome_fkey FOREIGN KEY (id_symptome) REFERENCES public.symptome(id_symptome);


--
-- Name: association_symptome_maladie association_symptome_maladie_id_maladie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_maladie
    ADD CONSTRAINT association_symptome_maladie_id_maladie_fkey FOREIGN KEY (id_target) REFERENCES public.maladie(id_maladie);


--
-- Name: association_symptome_maladie association_symptome_maladie_id_sympome_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.association_symptome_maladie
    ADD CONSTRAINT association_symptome_maladie_id_sympome_fkey FOREIGN KEY (id_symptome) REFERENCES public.symptome(id_symptome);


--
-- Name: effet_association_medicament_symptome effet_association_medicament_symptome_id_effet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.effet_association_medicament_symptome
    ADD CONSTRAINT effet_association_medicament_symptome_id_effet_fkey FOREIGN KEY (id_effet) REFERENCES public.association_symptome_medicament(id_association_medicament_symptome);


--
-- Name: effet_association_medicament_symptome effet_association_medicament_symptome_id_target_symptome_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.effet_association_medicament_symptome
    ADD CONSTRAINT effet_association_medicament_symptome_id_target_symptome_fkey FOREIGN KEY (id_target_symptome) REFERENCES public.symptome(id_symptome);


--
-- Name: patient_symptome patient_symptome_id_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.patient_symptome
    ADD CONSTRAINT patient_symptome_id_patient_fkey FOREIGN KEY (id_patient) REFERENCES public.patient(id_patient);


--
-- Name: patient_symptome patient_symptome_id_symptome_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.patient_symptome
    ADD CONSTRAINT patient_symptome_id_symptome_fkey FOREIGN KEY (id_symptome) REFERENCES public.symptome(id_symptome);


--
-- Name: prix_medicament prix_medicament_id_medicament_fkey; Type: FK CONSTRAINT; Schema: public; Owner: your_username
--

ALTER TABLE ONLY public.prix_medicament
    ADD CONSTRAINT prix_medicament_id_medicament_fkey FOREIGN KEY (id_medicament) REFERENCES public.medicament(id_medicament);


--
-- PostgreSQL database dump complete
--

