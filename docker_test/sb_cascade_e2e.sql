--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-05 22:27:47 EDT

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

--
-- TOC entry 2 (class 3079 OID 26246)
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 26429)
-- Name: comic_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comic_tags (
    id bigint NOT NULL,
    ordinal integer,
    comic_id bigint,
    tag_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.comic_tags OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26428)
-- Name: comic_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comic_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comic_tags_id_seq OWNER TO postgres;

--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 227
-- Name: comic_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comic_tags_id_seq OWNED BY public.comic_tags.id;


--
-- TOC entry 222 (class 1259 OID 26378)
-- Name: comics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comics (
    id bigint NOT NULL,
    title character varying(255),
    body text,
    slug character varying(255),
    published boolean DEFAULT false NOT NULL,
    post_date date,
    meta_description character varying(255),
    image_alt_text character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    media_id bigint
);


ALTER TABLE public.comics OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 26377)
-- Name: comics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comics_id_seq OWNER TO postgres;

--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 221
-- Name: comics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comics_id_seq OWNED BY public.comics.id;


--
-- TOC entry 224 (class 1259 OID 26394)
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.files OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26393)
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.files_id_seq OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 223
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- TOC entry 230 (class 1259 OID 26920)
-- Name: pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    title character varying(255),
    body text,
    slug character varying(255),
    meta_description character varying(255),
    image_alt_text character varying(255),
    media_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.pages OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 26919)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO postgres;

--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 229
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 216 (class 1259 OID 26221)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26962)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    key character varying(255),
    value character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26961)
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.settings_id_seq OWNER TO postgres;

--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 231
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- TOC entry 226 (class 1259 OID 26403)
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slug character varying(255)
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26402)
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 225
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- TOC entry 218 (class 1259 OID 26352)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26351)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 220 (class 1259 OID 26362)
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.users_tokens OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 26361)
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- TOC entry 3601 (class 2604 OID 26432)
-- Name: comic_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comic_tags ALTER COLUMN id SET DEFAULT nextval('public.comic_tags_id_seq'::regclass);


--
-- TOC entry 3597 (class 2604 OID 26381)
-- Name: comics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comics ALTER COLUMN id SET DEFAULT nextval('public.comics_id_seq'::regclass);


--
-- TOC entry 3599 (class 2604 OID 26397)
-- Name: files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- TOC entry 3602 (class 2604 OID 26923)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3603 (class 2604 OID 26965)
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- TOC entry 3600 (class 2604 OID 26406)
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- TOC entry 3595 (class 2604 OID 26355)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3596 (class 2604 OID 26365)
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- TOC entry 3794 (class 0 OID 26429)
-- Dependencies: 228
-- Data for Name: comic_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comic_tags (id, ordinal, comic_id, tag_id, inserted_at, updated_at) FROM stdin;
294	0	494	11	2024-09-23 12:44:10	2024-09-23 12:44:10
304	0	504	7	2024-09-23 12:44:10	2024-09-23 12:44:10
314	2	511	62	2024-09-23 12:44:10	2024-09-23 12:44:10
295	0	495	8	2024-09-23 12:44:10	2024-09-23 12:44:10
305	0	505	59	2024-09-23 12:44:10	2024-09-23 12:44:10
296	0	496	9	2024-09-23 12:44:10	2024-09-23 12:44:10
306	1	497	61	2024-09-23 12:44:10	2024-09-23 12:44:10
297	1	498	8	2024-09-23 12:44:10	2024-09-23 12:44:10
307	0	507	16	2024-09-23 12:44:10	2024-09-23 12:44:10
298	2	498	31	2024-09-23 12:44:10	2024-09-23 12:44:10
308	1	508	58	2024-09-23 12:44:10	2024-09-23 12:44:10
299	1	499	7	2024-09-23 12:44:10	2024-09-23 12:44:10
309	0	508	56	2024-09-23 12:44:10	2024-09-23 12:44:10
300	0	500	7	2024-09-23 12:44:10	2024-09-23 12:44:10
310	0	509	14	2024-09-23 12:44:10	2024-09-23 12:44:10
291	0	492	14	2024-09-23 12:44:10	2024-09-23 12:44:10
301	0	501	5	2024-09-23 12:44:10	2024-09-23 12:44:10
311	0	510	61	2024-09-23 12:44:10	2024-09-23 12:44:10
292	0	493	7	2024-09-23 12:44:10	2024-09-23 12:44:10
302	1	501	60	2024-09-23 12:44:10	2024-09-23 12:44:10
293	1	494	10	2024-09-23 12:44:10	2024-09-23 12:44:10
303	1	504	8	2024-09-23 12:44:10	2024-09-23 12:44:10
313	1	511	8	2024-09-23 12:44:10	2024-09-23 12:44:10
\.


--
-- TOC entry 3788 (class 0 OID 26378)
-- Dependencies: 222
-- Data for Name: comics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comics (id, title, body, slug, published, post_date, meta_description, image_alt_text, user_id, inserted_at, updated_at, media_id) FROM stdin;
496	Christmas Card	\N	christmas-card	t	2023-12-25	A comic about getting a Christmas card.	Christmas Card sorrowbacon comic	\N	2023-12-25 13:58:00	2023-12-25 13:58:00	267
506	MLM	\N	mlm	t	2024-05-10	A comic about getting a call from an old friend...	MLM sorrowbacon comic	\N	2024-05-10 13:05:14	2024-05-10 13:05:16	281
497	Kitten Speech	\N	kitten-speech	t	2024-01-04	A comic about what a kitten is really saying.	Kitten Speech sorrowbacon comic	\N	2024-01-04 14:09:40	2024-01-04 14:09:42	268
507	Stock Portfolio	\N	stock-portfolio	t	2024-05-23	A comic about birds discussing their stock portfolios. 	Stock Portfolio ft. Dandy Birds sorrowbacon comic	\N	2024-05-24 13:21:04	2024-05-24 13:21:06	283
498	Harvard (Part 2)	\N	harvard-part-2	t	2024-01-12	A comic about Harvard, part 2.	\N	\N	2024-01-12 15:11:41	2024-01-12 15:29:02	270
508	Tarot	\N	tarot	t	2024-06-06	A comic about seizing destiny.	Tarot sorrowbacon comic	\N	2024-06-07 12:45:50	2024-06-07 12:45:51	285
499	Sophisticated	\N	sophisticated	t	2024-01-18	A comic about a cat being sophisticated.	Sophisticated sorrowbacon comic	\N	2024-01-19 14:53:24	2024-01-19 14:54:08	271
509	Werewolf Care	Happy Werewolf Dad's Day!	werewolf-care	t	2024-06-16	A comic about Werewolf Dad care. 	Werewolf Care sorrowbacon comic	\N	2024-06-16 12:50:35	2024-06-16 12:52:39	287
500	Pray	\N	pray	t	2024-02-02	Sociopathic Cat prays for wealth.	Pray sorrowbacon comic	\N	2024-02-02 14:49:10	2024-02-02 14:49:12	272
510	Kitten Reason	Another one: [https://sorrowbacon.com/comic/kitten-speech](https://sorrowbacon.com/comic/kitten-speech)	kitten-reason	t	2024-06-28	A comic about a kitten in hell. 	Kitten Reason sorrowbacon comic	\N	2024-06-28 12:44:25	2024-06-28 12:47:03	290
491	Aviation Cat	\N	aviation-cat	t	2023-10-05	A comic about Aviation Cat — a cat who is also a plane!	Aviation Cat sorrowbacon comic	\N	2023-10-06 03:54:05	2023-10-06 13:15:33	261
501	Zombie Cat	\N	zombie-cat	t	2024-02-16	How Zombie Cat helps you.	Zombie Cat sorrowbacon comic	\N	2024-02-16 15:35:57	2024-02-16 15:35:59	273
511	Dollars Store	\N	dollars-store	t	2024-07-11	A comic about the cost of things at the dollars store. 	Dollars Store sorrowbacon	\N	2024-07-12 15:58:02	2024-07-12 15:58:13	292
492	Parent-Teacher Conference	\N	parent-teacher-conference	t	2023-10-12	A comic about Werewolf Dad going to his child's parent-teacher conference.	Parent-Teacher Conference sorrowbacon comic - Werewolf Dad	\N	2023-10-13 02:16:54	2023-10-13 02:18:15	262
502	Lineups	\N	lineups	t	2024-03-01	A comic about how lineups differ in your 20s and 30s.	Lineups sorrowbacon comic	\N	2024-03-01 15:15:05	2024-03-01 15:16:27	274
493	Why Do Birds	\N	why-do-birds	t	2023-11-10	A comic about birds suddenly appearing. 	Why Do Birds sorrowbacon comic	\N	2023-11-10 14:02:39	2023-11-10 14:02:41	264
503	Dating App	\N	dating-app	t	2024-03-21	A comic about trying to meet people via dating apps. 	Dating App sorrowbacon comic	\N	2024-03-22 15:26:25	2024-03-22 15:26:52	275
494	Marry a Witch	\N	marry-a-witch	t	2023-11-27	A comic about marrying a witch.	Marry a Witch sorrowbacon comic	\N	2023-11-28 03:20:18	2023-11-28 03:20:19	265
504	Love Me	\N	love-me	t	2024-04-05	A comic about proving your love to a cat.	Love Me sorrowbacon comic	\N	2024-04-05 14:14:46	2024-04-05 14:14:48	278
495	Text	\N	text	t	2023-12-14	A comic about receiving texts from friends. 	Text sorrowbacon comic	\N	2023-12-14 13:51:16	2023-12-14 13:51:18	266
505	Windmill	\N	windmill	t	2024-04-19	A comic about what happens when you windmill too hard, ft. Mortal Carcass. 	Windmill sorrowbacon comic	\N	2024-04-19 13:35:49	2024-04-19 13:35:51	279
\.


--
-- TOC entry 3790 (class 0 OID 26394)
-- Dependencies: 224
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, name, url, inserted_at, updated_at) FROM stdin;
262	Parent Teacher Conference - Werewolf Dad - sorrowbacon comic.jpg	/uploads/Parent_Teacher_Conference_Werewolf_Dad_sorrowbacon_comic_7eb33297a6.jpg	2023-10-13 02:16:47	2023-10-13 02:17:11
273	Zombie Cat sorrowbacon comic.jpg	/uploads/Zombie_Cat_sorrowbacon_comic_76b84f394a.jpg	2024-02-16 15:34:10	2024-02-16 15:34:10
274	Lineups - sorrowbacon comic.jpg	/uploads/Lineups_sorrowbacon_comic_30b89520ae.jpg	2024-03-01 15:13:01	2024-03-01 15:13:01
285	Tarot sorrowbacon comic.jpg	/uploads/Tarot_sorrowbacon_comic_9f896b6d5b.jpg	2024-06-07 12:44:38	2024-06-07 12:45:13
264	Why Do Birds - sorrowbacon comic.jpg	/uploads/Why_Do_Birds_sorrowbacon_comic_f76f9e2b89.jpg	2023-11-10 14:01:46	2023-11-10 14:01:46
275	Dating App sorrowbacon comic.jpg	/uploads/Dating_App_sorrowbacon_comic_082504f369.jpg	2024-03-22 15:25:34	2024-03-22 15:25:34
242	sorrowbacon-Sociopathic Cat-welcome.jpg	/uploads/sorrowbacon_Sociopathic_Cat_welcome_ae7b8fa454.jpg	2023-03-10 22:00:28	2023-03-10 22:00:41
265	Marry a Witch sorrowbacon comic.jpg	/uploads/Marry_a_Witch_sorrowbacon_comic_2df35eb6f4.jpg	2023-11-28 03:19:18	2023-11-28 03:19:31
277	Love Me sorrowbacon comic.jpg	/uploads/Love_Me_sorrowbacon_comic_94ab356111.jpg	2024-04-05 14:13:42	2024-04-05 14:13:56
287	Werewolf Care sorrowbacon comic.jpg	/uploads/Werewolf_Care_sorrowbacon_comic_583fd17ab2.jpg	2024-06-16 12:49:37	2024-06-16 12:49:53
266	Text sorrowbacon comic.jpg	/uploads/Text_sorrowbacon_comic_d4f4415e9a.jpg	2023-12-14 13:50:32	2023-12-14 13:51:29
278	Love Me sorrowbacon comic.jpg	/uploads/Love_Me_sorrowbacon_comic_6e78b15fe4.jpg	2024-04-05 14:14:15	2024-04-05 14:14:15
288	Cupids sorrowbacon comic.jpg	/uploads/Cupids_sorrowbacon_comic_da0294c77b.jpg	2024-06-16 22:04:22	2024-06-16 22:04:35
231	Sociopathic Cat painting by Millie Ho.jpg	/uploads/Sociopathic_Cat_painting_by_Millie_Ho_cb1b32a66b.jpg	2022-10-30 16:17:09	2022-10-30 16:17:09
267	Christmas Card sorrowbacon comic.jpg	/uploads/Christmas_Card_sorrowbacon_comic_f27d26c780.jpg	2023-12-25 13:57:24	2023-12-25 13:58:13
279	Windmill sorrowbacon comic.jpg	/uploads/Windmill_sorrowbacon_comic_8ca679feab.jpg	2024-04-19 13:34:51	2024-04-19 13:35:06
130	More Eyes sorrowbacon comic.jpg	/uploads/More_Eyes_sorrowbacon_comic_06c42b496f.jpg	2022-10-27 16:36:26	2022-10-27 16:36:26
268	Kitten Speech sorrowbacon comic.jpg	/uploads/Kitten_Speech_sorrowbacon_comic_ea96628de4.jpg	2024-01-04 14:08:35	2024-01-04 14:08:35
280	MLM sorrowbacon comic.jpg	/uploads/MLM_sorrowbacon_comic_ce4bbafb0d.jpg	2024-05-10 13:04:22	2024-05-10 13:04:22
290	Kitten Reason sorrowbacon comic.jpg	/uploads/Kitten_Reason_sorrowbacon_comic_3dc9e52b08.jpg	2024-06-28 12:42:50	2024-06-28 12:42:50
270	Harvard (part 2) sorrowbacon comic.jpg	/uploads/Harvard_part_2_sorrowbacon_comic_e7b3e21370.jpg	2024-01-12 15:28:42	2024-01-12 15:28:55
281	MLM sorrowbacon comic.jpg	/uploads/MLM_sorrowbacon_comic_5066fe215a.jpg	2024-05-10 13:04:38	2024-05-10 13:04:38
132	Motivation sorrowbacon comic.jpg	/uploads/Motivation_sorrowbacon_comic_1332003766.jpg	2022-10-27 16:36:26	2022-10-27 16:36:26
260	Aviation Cat sorrowbacon comic.jpg	/uploads/Aviation_Cat_sorrowbacon_comic_b25352cd43.jpg	2023-10-06 03:52:30	2023-10-06 03:52:43
271	Sophisticated sorrowbacon comic.jpg	/uploads/Sophisticated_sorrowbacon_comic_7e40be73b6.jpg	2024-01-19 14:52:51	2024-01-19 14:52:51
292	Dollars Store sorrowbacon comic.jpg	/uploads/Dollars_Store_sorrowbacon_comic_b141e136ad.jpg	2024-07-12 15:54:57	2024-07-12 15:58:50
261	Aviation Cat sorrowbacon comic.jpg	/uploads/Aviation_Cat_sorrowbacon_comic_fd21229ab1.jpg	2023-10-06 03:53:15	2023-10-06 03:53:15
272	Pray sorrowbacon comic.jpg	/uploads/Pray_sorrowbacon_comic_8ce8372a07.jpg	2024-02-02 14:48:40	2024-02-02 14:48:40
283	Stock Portfolio sorrowbacon comic.jpg	/uploads/Stock_Portfolio_sorrowbacon_comic_cd43bb91fb.jpg	2024-05-24 13:19:03	2024-05-24 13:19:21
\.


--
-- TOC entry 3796 (class 0 OID 26920)
-- Dependencies: 230
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pages (id, title, body, slug, meta_description, image_alt_text, media_id, inserted_at, updated_at) FROM stdin;
1	About	sorrowbacon is a comic about humans and creatures. The name comes from the German word kummerspeck.\n\nWritten and illustrated by Millie Ho. \n\nBehind the scenes and more on Patreon.\n\nRead on WEBTOON and Reddit. 	about	A comic ft. cats written and illustrated by Millie Ho. Nihilism and nachos!	About	231	2022-10-31 01:40:00	2024-07-12 15:30:30
\.


--
-- TOC entry 3782 (class 0 OID 26221)
-- Dependencies: 216
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20240716213607	2024-08-28 03:44:52
20240717124856	2024-08-28 03:44:52
20240730213617	2024-08-28 03:44:52
20240824164224	2024-08-28 03:44:52
20240825034306	2024-08-28 03:44:52
20240826172112	2024-08-28 03:44:52
20240901170114	2024-09-01 17:05:52
20240906005552	2024-09-06 01:06:57
20240906145830	2024-09-06 15:05:33
20240908204757	2024-09-08 20:59:13
20240909144833	2024-09-09 14:51:50
20240913142044	2024-09-13 14:23:15
20240918030145	2024-09-18 03:02:47
20240918030306	2024-09-18 03:03:37
\.


--
-- TOC entry 3798 (class 0 OID 26962)
-- Dependencies: 232
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (id, key, value, inserted_at, updated_at) FROM stdin;
18	meta_description	sorrowbacon asdf	2024-09-23 12:44:11	2024-10-01 02:17:24
19	meta_title	sorrowbacon meta_title	2024-09-23 12:44:11	2024-10-01 02:17:24
20	site_title	sorrowbacon site_title	2024-09-23 12:44:11	2024-10-01 02:17:24
\.


--
-- TOC entry 3792 (class 0 OID 26403)
-- Dependencies: 226
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name, inserted_at, updated_at, slug) FROM stdin;
5	Mike	2022-10-25 21:48:02	2022-10-25 21:48:02	mike
7	Sociopathic Cat	2022-10-25 21:48:02	2022-10-25 21:48:02	sociopathic-cat
8	Food Bringer	2022-10-25 21:48:02	2022-10-25 21:48:02	food-bringer
9	dwayne	2022-10-25 21:48:02	2022-10-25 21:48:02	dwayne
10	Emo Kid	2022-10-25 21:48:02	2022-10-25 21:48:02	emo-kid
11	The Witch	2022-10-25 21:48:02	2022-10-25 21:48:02	the-witch
14	Werewolf Dad	2022-10-25 21:48:02	2022-10-25 21:48:02	werewolf-dad
16	Brek Brek, Dandy Bird	2022-10-25 21:48:02	2024-05-24 13:20:04	brek-brek
31	Mr. Bun	2022-10-25 21:48:02	2022-10-25 21:48:02	mr.-bun
56	The Entrepreneur	2023-02-17 04:17:09	2023-02-17 04:17:09	the-entrepreneur
58	New Student	2023-06-26 00:38:53	2023-06-26 00:38:53	new-student
59	Mortal Carcass	2023-07-06 13:12:38	2023-07-06 13:12:38	mortal-carcass
60	Zombie Cat	2024-02-16 15:36:23	2024-02-16 15:36:23	zombie-cat
61	The Kitten	2024-05-05 01:58:49	2024-05-05 01:58:49	the-kitten
62	The Cashier	2024-07-12 15:57:56	2024-07-12 15:57:56	the-cashier
\.


--
-- TOC entry 3784 (class 0 OID 26352)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hashed_password, confirmed_at, inserted_at, updated_at) FROM stdin;
1	webadmin@cleaver.ca	$2b$12$HFXdpYYklaGFqG826s7W4eL.Nv7zclKfqyWTD.L3N7ZKgFRUbF2n.	\N	2024-08-28 16:13:13	2024-08-28 16:13:13
2	api-user@cleaver.ca	$2b$12$uhcpj6shjsvmYRKqnLUoQOFGUkDHm5eTMuZ5dCbmS8AlkiUnRZqR.	2024-09-18 22:05:30	2024-09-18 21:48:39	2024-09-18 22:05:30
\.


--
-- TOC entry 3786 (class 0 OID 26362)
-- Dependencies: 220
-- Data for Name: users_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_tokens (id, user_id, token, context, sent_to, inserted_at) FROM stdin;
1	1	\\xb37c5801ad371e793462924ed83c1ae1873acfa63d49ddc263c207fadb573a7e	confirm	webadmin@cleaver.ca	2024-08-28 16:13:13
2	1	\\x0466654fdb33a4aaa8ce1ca1fbc5fca9978980f37f62d7689ceb44a35c1ec39a	session	\N	2024-08-28 16:13:13
3	2	\\xe22c9db82f9023161d51deaa0ba3d01efbb59653aa7280d014e1486397be5a97	api-token	api-user@cleaver.ca	2024-09-18 22:06:37
\.


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 227
-- Name: comic_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comic_tags_id_seq', 19, true);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 221
-- Name: comics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comics_id_seq', 3332, true);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 223
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.files_id_seq', 5790, true);


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 229
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pages_id_seq', 1, true);


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 231
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settings_id_seq', 20, true);


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 225
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 1109, true);


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_tokens_id_seq', 3, true);


--
-- TOC entry 3625 (class 2606 OID 26434)
-- Name: comic_tags comic_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comic_tags
    ADD CONSTRAINT comic_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 3615 (class 2606 OID 26386)
-- Name: comics comics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comics
    ADD CONSTRAINT comics_pkey PRIMARY KEY (id);


--
-- TOC entry 3619 (class 2606 OID 26401)
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- TOC entry 3629 (class 2606 OID 26927)
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3605 (class 2606 OID 26225)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3632 (class 2606 OID 26969)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3621 (class 2606 OID 26408)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 3608 (class 2606 OID 26359)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3611 (class 2606 OID 26369)
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3623 (class 1259 OID 26445)
-- Name: comic_tags_comic_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comic_tags_comic_id_index ON public.comic_tags USING btree (comic_id);


--
-- TOC entry 3626 (class 1259 OID 26446)
-- Name: comic_tags_tag_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comic_tags_tag_id_index ON public.comic_tags USING btree (tag_id);


--
-- TOC entry 3613 (class 1259 OID 26907)
-- Name: comics_media_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comics_media_id_index ON public.comics USING btree (media_id);


--
-- TOC entry 3616 (class 1259 OID 26981)
-- Name: comics_slug_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX comics_slug_index ON public.comics USING btree (slug);


--
-- TOC entry 3617 (class 1259 OID 26392)
-- Name: comics_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comics_user_id_index ON public.comics USING btree (user_id);


--
-- TOC entry 3627 (class 1259 OID 26933)
-- Name: pages_media_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_media_id_index ON public.pages USING btree (media_id);


--
-- TOC entry 3630 (class 1259 OID 26970)
-- Name: settings_key_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX settings_key_index ON public.settings USING btree (key);


--
-- TOC entry 3622 (class 1259 OID 26982)
-- Name: tags_slug_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tags_slug_index ON public.tags USING btree (slug);


--
-- TOC entry 3606 (class 1259 OID 26360)
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- TOC entry 3609 (class 1259 OID 26376)
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- TOC entry 3612 (class 1259 OID 26375)
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- TOC entry 3636 (class 2606 OID 26435)
-- Name: comic_tags comic_tags_comic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comic_tags
    ADD CONSTRAINT comic_tags_comic_id_fkey FOREIGN KEY (comic_id) REFERENCES public.comics(id) ON DELETE CASCADE;


--
-- TOC entry 3637 (class 2606 OID 26440)
-- Name: comic_tags comic_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comic_tags
    ADD CONSTRAINT comic_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- TOC entry 3634 (class 2606 OID 26908)
-- Name: comics comics_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comics
    ADD CONSTRAINT comics_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- TOC entry 3635 (class 2606 OID 26387)
-- Name: comics comics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comics
    ADD CONSTRAINT comics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3638 (class 2606 OID 26928)
-- Name: pages pages_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- TOC entry 3633 (class 2606 OID 26370)
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2024-10-05 22:27:47 EDT

--
-- PostgreSQL database dump complete
--

