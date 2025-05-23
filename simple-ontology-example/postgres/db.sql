--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    city text NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    company_id integer NOT NULL,
    name text NOT NULL,
    address text,
    web_url text
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    person_id integer NOT NULL,
    given_name text NOT NULL,
    family_name text NOT NULL,
    home_city text NOT NULL,
    email text NOT NULL,
    company_id integer
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, city) FROM stdin;
1	Turku
2	Vaasa
3	Pietarsaari
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (company_id, name, address, web_url) FROM stdin;
1	NordicTech	12 Code St	http://norditech.fi
2	WasaWatt	45 Sea View	http://wasawatt.fi
3	Pietarsaari Innovations	88 Future Rd	http://pietainno.fi
4	FinEdu	Learn Lane	http://fied.fi
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (person_id, given_name, family_name, home_city, email, company_id) FROM stdin;
1	Aino	Korhonen	Turku	aino.korhonen@axample.fi	4
2	Mikko	Virtanen	Vaasa	virtanen.mikko@example.fi	2
3	Sari	Makinen	Turku	sari.makinen@example.fi	1
4	Teemu	H├ñm├ñl├ñinen	Pietarsaari	thamalainen@example.fi	3
5	Laura	Heikkinen	Pietarsaari	lheikkinen@example.fi	2
6	Jukka	Koskinen	Pietarsaari	jukka2000@example.fi	2
7	Noora	J├ñrvinen	Turku	noora123@example.fi	4
8	Ville	Lehtonen	Pietarsaari	ville.lehtonen@example.fi	3
9	Emilia	Saarinen	Vaasa	emilia.saarinen@example.fi	3
10	Antti	Salmi	Pietarsaari	antti.salmi@example.fi	4
\.


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (company_id);


--
-- Name: persons persons_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_email_key UNIQUE (email);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (person_id);


--
-- Name: persons persons_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.organizations(company_id);


--
-- PostgreSQL database dump complete
--

