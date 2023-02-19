--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

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
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    join_date date NOT NULL,
    age integer,
    gender character varying(20) NOT NULL,
    education character varying(100) NOT NULL,
    profession character varying(50) NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    name text,
    headline text,
    location text,
    followers bigint,
    connections bigint,
    about text,
    id integer NOT NULL
);


ALTER TABLE public.company OWNER TO postgres;

--
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_id_seq OWNER TO postgres;

--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;


--
-- Name: complaint; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaint (
    id integer NOT NULL,
    user_id integer NOT NULL,
    content character varying(200) NOT NULL,
    urgency integer NOT NULL,
    resolved boolean NOT NULL,
    created_on date NOT NULL
);


ALTER TABLE public.complaint OWNER TO postgres;

--
-- Name: complaint_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaint_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.complaint_id_seq OWNER TO postgres;

--
-- Name: complaint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaint_id_seq OWNED BY public.complaint.id;


--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact (
    created_time timestamp with time zone,
    receiver_id integer NOT NULL,
    sender_id integer NOT NULL,
    CONSTRAINT contact_check CHECK ((receiver_id <> sender_id))
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: contact_limitation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_limitation (
    blocked_user_id integer NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT contact_limitation_check CHECK ((blocked_user_id <> user_id))
);


ALTER TABLE public.contact_limitation OWNER TO postgres;

--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id integer NOT NULL,
    content character varying(1000) NOT NULL,
    send_time timestamp without time zone,
    receiver_id integer,
    sender_id integer
);


ALTER TABLE public.message OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    payment_name character varying(100) NOT NULL,
    sending_time timestamp without time zone NOT NULL,
    amount integer NOT NULL,
    comment character varying(200),
    method character varying(50) NOT NULL,
    receiver_id integer NOT NULL,
    user_id integer NOT NULL,
    category character varying(50)
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_id_seq OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: payment_limitation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_limitation (
    id integer NOT NULL,
    amount integer NOT NULL,
    set_date date NOT NULL,
    effective_days integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.payment_limitation OWNER TO postgres;

--
-- Name: payment_limitation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_limitation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_limitation_id_seq OWNER TO postgres;

--
-- Name: payment_limitation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_limitation_id_seq OWNED BY public.payment_limitation.id;


--
-- Name: time_span_spending; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.time_span_spending AS
 SELECT a.id AS user_id,
    a.name AS username,
    a.email,
    p.payment_name,
    p.sending_time,
    p.amount AS limitation_amount,
    c.name AS company_name,
    c.headline,
    c.location
   FROM public.company c,
    public.account a,
    public.payment p
  WHERE ((a.id = p.user_id) AND (c.id = p.receiver_id));


ALTER TABLE public.time_span_spending OWNER TO postgres;

--
-- Name: transfer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer (
    id integer NOT NULL,
    transfer_name character varying(20) NOT NULL,
    sending_time timestamp with time zone NOT NULL,
    amount integer NOT NULL,
    comment character varying(200) NOT NULL,
    receiver_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.transfer OWNER TO postgres;

--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_id_seq OWNER TO postgres;

--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_id_seq OWNED BY public.transfer.id;


--
-- Name: transfer_limitation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_limitation (
    id integer NOT NULL,
    amount integer NOT NULL,
    set_date date NOT NULL,
    effective_days integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.transfer_limitation OWNER TO postgres;

--
-- Name: transfer_limitation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_limitation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_limitation_id_seq OWNER TO postgres;

--
-- Name: transfer_limitation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_limitation_id_seq OWNED BY public.transfer_limitation.id;


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- Name: complaint id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint ALTER COLUMN id SET DEFAULT nextval('public.complaint_id_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Name: payment_limitation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_limitation ALTER COLUMN id SET DEFAULT nextval('public.payment_limitation_id_seq'::regclass);


--
-- Name: transfer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer ALTER COLUMN id SET DEFAULT nextval('public.transfer_id_seq'::regclass);


--
-- Name: transfer_limitation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_limitation ALTER COLUMN id SET DEFAULT nextval('public.transfer_limitation_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (id, name, email, join_date, age, gender, education, profession) FROM stdin;
1	wboundy0	ssimenon0@posterous.com	2021-06-28	7	Genderfluid	Transport and Telecommunication Institute	Operator
2	rbrealey1	kgirtin1@va.gov	2020-10-05	8	Male	Université de Kairouan	Business Systems Development Analyst
3	bhearst2	itrussman2@cocolog-nifty.com	2022-09-06	6	Female	Tokyo Women's College of Physical Education	Assistant Media Planner
4	swilshaw3	wlampart3@ycombinator.com	2022-04-01	6	Female	Omdurman Islamic University	Occupational Therapist
5	ehands4	etapsfield4@jiathis.com	2022-06-03	3	Male	Jimma University	Data Coordiator
6	bsmitton5	mfraczkiewicz5@noaa.gov	2022-05-12	8	Male	Institute of Teachers Education, Kota Bharu	Geologist II
7	rhalfhead6	mbaldrey6@intel.com	2020-07-26	3	Male	Ho Chi Minh City Open University	Associate Professor
8	gkaye7	rbagge7@cam.ac.uk	2022-02-20	7	Male	University College of Technology & Innovation (UCTI)	Teacher
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company (name, headline, location, followers, connections, about, id) FROM stdin;
Dell Technologies	Information Technology & Services	Round Rock, Texas	3597845	194140	Dell Technologies is a unique family of businesses that provides the essential infrastructure for organizations to build their digital future, transform IT and protect their most important asset, information.	1
AT&T	Telecommunications	Dallas, TX	1337906	224793	We understand that our customers want an easier, less complicated life.  \n \nWe’re using our network, labs, products, services and people to create a world where everything works together seamlessly, and life is better as a result.  How will we continue to drive for this excellence in innovation?\n \nWith you.\n \nOur people, and their passion to succeed, are at the heart of what we do. Today, we’re poised to connect millions of people with their world, delivering the human benefits of technology in ways that defy the imaginable.\n \nWhat are you dreaming of doing with your career?\n  \nFind stories about our talent, career advice, opportunities, company news, and innovations here on LinkedIn.\n \nTo learn more about joining AT&T, visit: http://www.att.jobs\n \nTo explore AT&T Labs, Foundry, and more, visit: https://www.linkedin.com/company/at&tinnovation\n \nTo follow AT&T Small Business community, visit: https://bizcircle.att.com\n\nWe provide in some of our posts links to articles or posts from third-party websites unaffiliated with AT&T.  In doing so, AT&T is not adopting, endorsing or otherwise approving the content of those articles or posts.  AT&T is providing this content for your information only.	2
Allianz	Financial Services	Munich	554353	141747	Founded in 1890 in Berlin, Allianz Group is a global leader and employer in insurance and financial services in more than 70 countries worldwide. With Allianz SE as headquarters, our many different insurance and financial service companies are present on all continents. Further high quality services are offered globally by Allianz Asset Management (Allianz Global Investors & PIMCO), Allianz Global Corporate & Specialty (corporate and specialty risks), Allianz Technology, Euler Hermes (credit insurance) and Allianz Partners (assistance services).\n\nAllianz is the HOME for those who DARE – a supportive place where you can take the initiative to grow and to actively strengthen our global leadership position. By truly caring about people – both its 85 million private and corporate customers and more than 142,000 employees – Allianz fosters a culture where its employees are empowered to collaborate, perform, embrace trends and challenge the industry. Our main ambition is to be our customers’ trusted partner, instilling them with the confidence to grow. \n\nAre you a daring mind who wants to make a difference ? We are looking for those who dare to challenge the status quo and pioneer our industry with us. If you dare, join us at Allianz Group.\n\nCredits: https://www.allianz.com/en_GB/credits-allianz-se.html\nFollow us: fb.com/Allianz  fb.com/AllianzCareers\nTwitter: twitter.com/Allianz twitter.com/AllianzCareers\nAllianz Data Privacy Statement:  https://www.allianz.com/en_GB/privacy-statement.html\nAllianz Careers Data Privacy Statement: https://careers.allianz.com/en_EN/footer/data-privacy.html \nLinkedIn Privacy Policy https://www.linkedin.com/legal/privacy-policy\nLinkedIn General Terms https://www.linkedin.com/legal/user-agreement	3
American Honda Motor Company, Inc.	Automotive	Torrance, CA	219092	8427	American Honda Motor Company, Inc., is a North American subsidiary of Honda Motor Company, Ltd. The company combines product sales, service and coordinating functions of Honda in North America, and is responsible for distribution, marketing and sales of Honda and Acura brand automobiles, Honda power sports products, including motorcycles, scooters and all-terrain vehicles, and Honda power equipment products, including lawnmowers, tillers, string trimmers, snow blowers, generators, small displacement general-purpose engines and marine outboard engines.	4
Huawei	Telecommunications	Shenzhen, Guangdong	3939371	149444	Huawei is a leading global provider of information and communications technology (ICT) infrastructure and smart devices. With integrated solutions across four key domains – telecom networks, IT, smart devices, and cloud services – we are committed to bringing digital to every person, home and organization for a fully connected, intelligent world.\n\nHuawei's end-to-end portfolio of products, solutions and services are both competitive and secure. Through open collaboration with ecosystem partners, we create lasting value for our customers, working to empower people, enrich home life, and inspire innovation in organizations of all shapes and sizes.\n\nAt Huawei, innovation focuses on customer needs. We invest heavily in basic research, concentrating on technological breakthroughs that drive the world forward. We have more than 180,000 employees, and we operate in more than 170 countries and regions. Founded in 1987, Huawei is a private company fully owned by its employees.\n\nHouse Rules\nThis page is for ICT professionals with an interest in Huawei and our industry to engage in open discussions.\nTo facilitate dialogue, please follow these rules:\n- Huawei holds the right to delete comments that are offensive, misleading, false, unlawful, off-topic and in violation of any regulations.\n- Repeated violations of any of the above will be removed and users may be blocked.\n- Huawei does not necessarily endorse the information shared by members.\n- Please be familiar with and follow LinkedIn's User Agreement.\n- By publicly uploading a photograph or comment, you give Huawei permission to feature your content. This will always be credited.\n\nPlease visit the below portals for career or customer service queries.\nCareer page: http://bit.ly/2rdljD7\nCustomer service: http://bit.ly/2a4mXNY\n\nThank you for visiting us & we hope you enjoy your time on our page.	5
Philips	Hospital & Health Care	Amsterdam, Noord-Holland	1796631	83422	We are a leading health technology company focused on improving people's health and enabling better outcomes across the health continuum from healthy living and prevention, to diagnosis, treatment and home care. \n\nWe leverage advanced technology and deep clinical and consumer insights to deliver integrated solutions. Headquartered in the Netherlands, the company is a leader in diagnostic imaging, image-guided therapy, patient monitoring and health informatics, as well as in consumer health and home care. \n\nVisit our website: http://www.philips.com/\nFollow our social media house rules http://philips.to/1tr9eIZ	6
SAP	Computer Software	Walldorf, BW	2271944	117257	At SAP, our purpose is to help the world run better and improve people’s lives. Our promise is to innovate to help our customers run at their best. SAP is committed to helping every customer become a best-run business. We engineer solutions to fuel innovation, foster equality, and spread opportunity across borders and cultures. Together, with our customers and partners, we can transform industries, grow economies, lift up societies, and sustain our environment. #TheBestRun\n\nSAP privacy statement for followers: www.sap.com/sps	7
Volkswagen AG	Automotive	Wolfsburg, Niedersachsen	953839	100627	The Volkswagen Group with its headquarters in Wolfsburg is one of the world’s leading automobile manufacturers and the largest carmaker in Europe. The Group is made up of twelve brands from seven European countries: Volkswagen, Audi, SEAT, ŠKODA, Bentley, Bugatti, Lamborghini, Porsche, Ducati, Volkswagen Commercial Vehicles, Scania and MAN.\n\nThe Group operates 120 production plants in 20 European countries and a further eleven countries in the Americas, Asia and Africa. Each working day, around 630,000 employees worldwide produce some 43,000 vehicles, are involved in vehicle-related services or work in the other fields of business. The Volkswagen Group sells its vehicles in 153 countries.\n\nOur goal is to make mobility sustainable for us and for future generations. Our promise: With electric drive, digital networking and autonomous driving, we make the automobile clean, quiet, intelligent and safe. At the same time, our core product becomes even more emotional and offers a completely new driving experience. It is also becoming part of the solution when it comes to climate and environmental protection. In this way, the car can continue to be a cornerstone of contemporary, individual and affordable mobility in the future. #Shapingmobility\n\nLegal notice: https://www.volkswagen.de/de/mehr/rechtliches/legal-notices-social-media.html\n\nImprint: https://www.volkswagenag.com/en/meta/provider-identification.html	8
McDonald's	Restaurants	Chicago, Illinois	1342969	329016	McDonald’s is the world’s leading global foodservice retailer with over 37,000 locations in over 100 countries.  More than 90% of McDonald’s restaurants worldwide are owned and operated by independent local business men and women.\n \nMcDonald's & our franchisees employ 1.9 million people worldwide.\n\nWe serve the world some of its favorite foods - World Famous Fries, Big Mac, Quarter Pounder, Chicken McNuggets and Egg McMuffin. \n\nTo learn more about the company, please visit www.aboutmcdonalds.com and follow us on Twitter at www.twitter.com/mcdonaldscorp	9
Honeywell	Electrical & Electronic Manufacturing	Charlotte, North Carolina	1820788	106622	Honeywell is a Fortune 100 company that invents and manufactures technologies to address tough challenges linked to global macrotrends such as safety, security, and energy. With approximately 110,000 employees worldwide, including more than 19,000 engineers and scientists, we have an unrelenting focus on quality, delivery, value, and technology in everything we make and do.	10
Hyundai Motor Company	Automotive	Seoul	63325	6072	Established in 1967, Hyundai Motor Company is committed to becoming a lifetime partner in automobiles and beyond, offering a range of world-class vehicles and mobility services in over 200 countries.\n\nEmploying more than 120,000 staff worldwide, Hyundai has sold about 4.6 million vehicles globally. Hyundai Motor continues to enhance its product line-up with vehicles built on solutions for a more sustainable future, such as NEXO -- the world’s first dedicated hydrogen-powered SUV.\n\nFurther information about Hyundai Motor and its products is available at \n  - http://www.hyundai.com.\n  - http://worldwide.hyundai.com\n\nCareer website: http://recruit.hyundai.com (Korean)	11
Kia Motors America	Automotive	Irvine, CA	91939	2899	Kia Motors America is headquartered in Irvine, California and is a subsidiary of Kia Motors Corporation. Kia’s technology-rich product lineup of cars, SUVs, and alternative-powered vehicles are backed by the industry-leading Kia 10-year/100,000-mile warranty program. Kia vehicles are sold and serviced through more than 700 dealerships nationwide and nearly half of those sold in the U.S. are built at Kia Motors Manufacturing Georgia. Recent accolades for Kia include the highest ranked mass market brand in initial quality for six consecutive years according to J.D. Power and recognition as one of the 100 Best Global Brand by Interbrand.	12
BMW Group	Automotive	Munich	1716019	45835	The BMW Group at a Glance\nWith its four brands BMW, MINI, Rolls-Royce and BMW Motorrad, the BMW Group is the world’s leading premium manufacturer of automobiles and motorcycles and also provides premium financial and mobility services. The BMW Group production network comprises 31 production and assembly facilities in 15 countries; the company has a global sales network in more than 140 countries.\n\nIn 2020, the BMW Group sold over 2.3 million passenger vehicles and more than 169,000 motorcycles worldwide. The profit before tax in the financial year 2019 was € 7.118 billion on revenues amounting to € 104.210 billion. As of 31 December 2019, the BMW Group had a workforce of 126,016 employees.\n\nThe success of the BMW Group has always been based on long-term thinking and responsible action. The company has therefore established ecological and social sustainability throughout the value chain, comprehensive product responsibility and a clear commitment to conserving resources as an integral part of its strategy.\n\n\nContact us: bewerber.hotline@bmw.de\nApply here: www.bmwgroup.jobs/careers\n\nData privacy:\nhttps://www.bmwgroup.com/linkedin-privacy-policy\n\nImprint:\nhttps://www.bmwgroup.com/imprint	13
Mercedes-Benz USA	Automotive	Atlanta, GA	543997	7943	Mercedes-Benz USA, LLC (MBUSA), a Daimler Company, is responsible for the Distribution and Marketing of Mercedes-Benz and smart products in the United States.\n\nMBUSA was founded in 1965 and prior to that Mercedes-Benz cars were sold in the United States by Mercedes-Benz Car Sales, Inc., a subsidiary of the Studebaker-Packard corporation. Today MBUSA has over 300 dealerships with more than 1400 employees.\n\nFor employment opportunities please visit: http://bit.ly/2tFzlOV. \n\nFor information on how to get the most out of your Mercedes-Benz vehicle, visit the Owners'​ Support instructional videos section of our site: http://www.mbusa.com/mercedes/owners/videos	14
Siemens	Industrial Automation	Munich	4324366	251510	Siemens AG (Berlin and Munich) is a global technology powerhouse that has stood for engineering excellence, innovation, quality, reliability and internationality for more than 170 years. Active around the world, the company focuses on intelligent infrastructure for buildings and distributed energy systems and on automation and digitalization in the process and manufacturing industries. Siemens brings together the digital and physical worlds to benefit customers and society. Through Mobility, a leading supplier of intelligent mobility solutions for rail and road transport, Siemens is helping to shape the world market for passenger and freight services. Via its majority stake in the publicly listed company Siemens Healthineers, Siemens is also a world-leading supplier of medical technology and digital health services. In addition, Siemens holds a minority stake in Siemens Energy, a global leader in the transmission and generation of electrical power that has been listed on the stock exchange since September 28, 2020. \nIn fiscal 2020, which ended on September 30, 2020, the Siemens Group generated revenue of €57.1 billion and net income of €4.2 billion. As of September 30, 2020, the company had around 293,000 employees worldwide. Further information is available on the Internet at www.siemens.com.\n\nChairman of the Supervisory Board\nJim Hagemann Snabe\n\nManaging Board\nJoe Kaeser (President and CEO) \nRoland Busch\nKlaus Helmrich \nCedrik Neike\nRalf P. Thomas\nJudith Wiese\n\nImprint: https://new.siemens.com/global/en/general/legal.html\nData privacy notice: https://new.siemens.com/global/en/general/siemens-on-social-media.html	15
HSBC	Financial Services	London	2480854	200730	HSBC is one of the world’s largest banking and financial services organisations. We serve more than 40 million customers across a network that covers 64 countries and territories, via three global businesses:\n\n•\tCommercial Banking\n•\tWealth and Personal Banking \n•\tGlobal Banking and Markets\n\nWe aim to be where the growth is, connecting customers to opportunities, enabling businesses to thrive and economies to prosper, and ultimately helping people to fulfil their hopes and realise their ambitions. \n\nHSBC is listed on the London, Hong Kong, New York, Paris and Bermuda stock exchanges.\n\nTo view our social media terms and conditions please visit the following webpage: http://www.hsbc.com/social-TandCs	16
Tesco	Retail	Welwyn Garden City, Hertfordshire	459565	82736	One of the world’s largest retailers of consumer goods from food to fashion. Serving customers a little better every day in our stores and online is at the heart of everything we do.\n\nFounded in 1919 by Jack Cohen using the £30 he received on leaving the Royal Flying Corp, we’ve come a long way from his small market stall in East London. Today over 400,000 colleagues work across our stores, office,  distribution and customer engagement centres in the UK, Europe and Asia. \n\nShare our passion for the people, products and places that make us great, and we can offer the right support to develop your skills. If you’re looking for the perfect work-life balance, a collaborative culture and flexible ways of working, find your opportunity to get on at www.tesco-careers.com	17
MetLife	Insurance	New York, NY	597326	52009	We live in a time of unprecedented change. A time when economies, regulations, and social safety nets are all in flux.\n\nCustomers around the globe have told us they’re overwhelmed by the pace of change and are looking for a trusted partner to help them manage life’s twists and turns.\n\nMetLife is committed to being that partner. That’s why we’re transforming our business: Delivering greater value for the people we serve by becoming a simpler, more focused, and future-facing company. We’ll be introducing new ways to meet our customers’ evolving needs, with flexible products; simpler, more intuitive experiences and a range of new services. \n\nMetLife. Navigating life together.\n\nFor customer service: https://www.metlife.com/support-and-manage/contact-us/\n\nFor social media notices: https://www.metlife.com/about-us/terms-and-conditions/social-media/\n\nMetLife, Inc. (NYSE: MET), through its subsidiaries and affiliates (“MetLife”), is one of the world’s leading financial services companies, providing insurance, annuities, employee benefits and asset management to help its individual and institutional customers navigate their changing world. Founded in 1868, MetLife has operations in more than 40 markets globally and holds leading positions in the United States, Japan, Latin America, Asia, Europe and the Middle East.	18
Merck Group	Pharmaceuticals	Darmstadt	550079	20791	We are Merck, a vibrant science and technology company. \n\nScience is at the heart of everything we do. It drives the discoveries we make and the technologies we create.\n\nThe passion of our curious minds makes a positive difference to millions of people’s lives every day. \n\nIn Healthcare, we discover unique ways to treat the most challenging diseases, such as multiple sclerosis and cancer. Our Life Science experts empower scientists by developing tools and solutions that help deliver breakthroughs more quickly. And in Performance Materials, we develop science that sits inside technologies and changes the way we access, store, process, and display information.\n\nEverything we do is fueled by a belief in science and technology as a force for good. A belief that has driven our work since 1668 and will continue to inspire us to find more joyful and sustainable ways to live.\n\nWe are curious minds dedicated to human progress.\n\nSound like something you'd like to be part of? Explore www.come2merck.com and bring your curiosity to life.\n\nThis channel is not intended for U.S. and Canadian visitors. Merck operates in the U.S. and Canada as EMD Serono in Healthcare, MilliporeSigma in Life Science and EMD Performance Materials in Performance Materials. An unaffiliated and unrelated company, Merck & Co., Inc., Kenilworth, NJ, US holds the rights in the trademark MERCK in the U.S. and Canada.\n\nLegal Disclaimer: www.merckgroup.com/en/legal-disclaimer.html\n\nData Privacy Declaration: www.merckgroup.com/en/privacy-statement	19
Cognizant	Information Technology & Services	Teaneck, New Jersey	3240380	282336	Cognizant (Nasdaq-100: CTSH) is one of the world's leading professional services companies, transforming clients'​ business, operating and technology models for the digital era. Our unique industry-based, consultative approach helps clients envision, build and run more innovative and efficient businesses. Headquartered in the U.S., Cognizant is ranked 194 on the Fortune 500 and is consistently listed among the most admired companies in the world. Learn how Cognizant helps clients lead with digital at www.cognizant.com or follow us @Cognizant.	20
Hewlett Packard Enterprise	Information Technology & Services	San Jose, California	3293276	187653	In 1939, Bill Hewlett and Dave Packard, college friends turned business partners, started the original Silicon Valley startup in the space of a rented Palo Alto garage. Starting with audio oscillators, the friends built the foundation for a company that would grow to become a global leader in enterprise technology.\n \nMore than 75 years later, our success is exemplified through our employees’ drive to advance ideas that bring meaningful innovations to life for our customers and partners around the globe. We are guided by our mission to help customers use technology to turn ideas into value, and empower them to transform industries, markets and lives. We simplify Hybrid IT, power the Intelligent Edge and provide the expertise to make it all happen.	21
VMware	Computer Software	Palo Alto, CA	1376184	31279	At VMware, we believe that software has the power to unlock new opportunities for people and our planet. We look beyond the barriers of compromise to engineer new ways to make technologies work together seamlessly. Our compute, cloud, mobility, networking and security offerings form a digital foundation that powers the apps, services and experiences that are transforming the world.\n\nSince our founding over two decades ago, our 24,000+ employee community and ecosystem of 75,000 partners have been behind the technology innovations transforming entire industries – from banking, healthcare, and government to retail, telecommunications, manufacturing, and transportation. \n\nEvery day, we work to solve our customers’ toughest challenges through disruptive technologies like edge computing, artificial intelligence, blockchain, machine learning, Kubernetes and more – to define the digital foundation that will accelerate the next wave of innovation.	22
ITC Limited	Consumer Goods	Kolkata, West Bengal	1816093	23203	ITC is one of India's foremost private sector companies with a Gross Sales Value of ₹ 76,097.31 crores and Net Profit of ₹ 15,136.05 crores (as on 31.03.2020). ITC has a diversified presence in FMCG, Hotels, Packaging, Paperboards & Specialty Papers and Agri-Business. ITC's aspiration to be an exemplar in sustainability practices is manifest in its status as the only company in the world, of its size and diversity, to be carbon, water and solid waste recycling positive. In addition, ITC's businesses and value chains create sustainable livelihoods for more than 6 million people, a majority of whom represent the poorest in rural India.	23
Boeing	Aviation & Aerospace	Chicago, IL	2225253	129616	We are the world’s largest aerospace company and leading provider of commercial airplanes, defense, space and security systems, and global services. Building on a legacy of aerospace leadership, Boeing continues to lead in technology and innovation, deliver for its customers, and invest in its people and future growth.\nWith us you can create and contribute to what matters most in your career, in your community and around the world. Our team members are supported to explore their professional interests and pursue new opportunities that will deepen their knowledge of our business. Join us in building the future of aerospace: boeing.com/careers\nBoeing is an Equal Opportunity Employer. Employment decisions are made without regard to race, color, religion, national origin, gender, sexual orientation, gender identity, age, physical or mental disability, genetic factors, military/veteran status or other characteristics protected by law.	24
eBay	Internet	San Jose, CA	463433	25465	eBay Inc. is a global commerce leader that connects millions of buyers and sellers around the world. We exist to enable economic opportunity for individuals, entrepreneurs, businesses and organizations of all sizes. Our portfolio of brands includes eBay Marketplace and eBay Classifieds Group, operating in 190 markets around the world.\n \nWe offer sellers the ability to grow a business with little barrier to entry regardless of size, background or geographic location. We never compete with our sellers. We win when our sellers succeed. Buyers who shop on our Marketplace and Classifieds platforms enjoy a highly personalized experience with an unparalleled selection at great value.	25
Uber	Internet	San Francisco, CA	1777648	91777	At Uber, we ignite opportunity by setting the world in motion. We take on big problems to help drivers, riders, delivery partners, and eaters get moving in more than 10,000 cities around the world.\n\nWe welcome people from all backgrounds who seek the opportunity to help build a future where everyone and everything can move independently. If you have the curiosity, passion, and collaborative spirit, work with us, and let’s move the world forward, together.	26
Electronic Arts (EA)	Computer Games	Redwood City, CA	744976	22971	At Electronic Arts, we exist to Inspire the World to Play. In a time when we need to stay physically apart, it’s amazing to see how people are using games as a way to connect. We create extraordinary new game experiences for our millions of players everywhere by bringing together talented people that combine creativity, innovation, and passion. We immerse our employees into an inclusive culture, and provide opportunities for learning and leading that allow them to do the most impactful and rewarding work of their careers. We believe in creating games and experiences for our global player community that are a reflection of our diverse world.\n\nJoin us in connecting people together in play.	27
Aflac	Insurance	Columbus, GA	128113	20255	Over 50 Million people worldwide have chosen Aflac because of our commitment to providing customers with the confidence that comes from knowing they have assistance in being prepared for whatever life may bring. \r\n\r\nWith Aflac, whether you're a large business or a small one, you can provide your employees with the kind of benefits they’d expect from a bigger company, helping your business stand out from the crowd. Hundreds of thousands of businesses across the United States already make Aflac available to their employees—at no direct cost to their company.\r\n\r\nChoose from a wide range of products that can help your employees with health events—from accidents, to disability, to cancer, to life insurance. Your employees enjoy benefits from Aflac, all employee-paid.\r\n\r\nPlease check out aflac.com for more information.	28
Caterpillar Inc.	Machinery	Deerfield, IL	1198991	52519	Since 1925, Caterpillar Inc. has been helping our customers build a better world – making sustainable progress possible and driving positive change on every continent.\n\nWith 2019 sales and revenues of $53.8 billion, Caterpillar is the world’s leading manufacturer of construction and mining equipment, diesel and natural gas engines, industrial gas turbines and diesel-electric locomotives. Services offered throughout the product life cycle, cutting-edge technology and decades of product expertise set Caterpillar apart, providing exceptional value to help our customers succeed. The company principally operates through three primary segments – Construction Industries, Resource Industries and Energy & Transportation – and provides financing and related services through its Financial Products segment.	29
Pfizer	Pharmaceuticals	New York, New York	3924181	114864	Breakthroughs That Change Patients' Lives: Pfizer is a leading research-based biopharmaceutical company. We apply science and our global resources to deliver innovative therapies that extend and significantly improve lives. Every day, Pfizer colleagues work across developed and emerging markets to advance wellness, prevention, treatments and cures that challenge the most feared diseases of our time.To learn more, visit www.pfizer.com.  \n\nFor additional information on our guidelines, please visit  http://www.pfizer.com/community-guidelines\n\nBeware of scams from individuals, organizations and Internet sites claiming to represent Pfizer in recruitment activities. A formal Pfizer recruitment process is required for all authorized positions posted by Pfizer prior to issuing an offer of employment. This Pfizer process includes an interview and never requires payment or fees from job applicants. If you receive a suspicious email message or phone call about recruiting on behalf of Pfizer, do not provide any personal information or pay any fees. Interested candidates should apply to current openings through this Pfizer website. Pfizer accepts no responsibility for any costs or charges incurred as a result of fraudulent activity.	30
Chevron	Oil & Energy	San Ramon, CA	3193017	70719	Our greatest resource is our people. Their ingenuity, creativity and collaboration have met the complex challenges of energy’s past. Together, we’ll take on the future.\n\nWe support the LinkedIn Terms of Use (User Agreement), and we expect visitors to our page to do the same. \n\nWe encourage open, lively conversation with a few simple rules: \n--We reserve the right to correct factual errors. \n--We will reply to comments when appropriate.\n--If we disagree with other opinions, we will do so respectfully.\n--You may not post anything that is spam or that is abusive, profane, or defamatory toward a person, entity, belief, or symbol.\n--We will delete any posts that contain personal information such as email addresses, phone numbers and physical addresses, and other third party intellectual property material, when that information does not belong to the author of the post. \n--You may not post job listings for non-Chevron positions.\n--While we support lively, open discussion, we reserve the right to delete comments.	31
Cigna	Health, Wellness & Fitness	Bloomfield, CT	287982	31409	At Cigna, we're more than a health insurance company. We are your partner in total health and wellness. And we’re here for you 24/7 – caring for your body and mind.\n\nAs a global health service company, Cigna's mission is to improve the health, well-being, and peace of mind of those we serve by making health care simple, affordable, and predictable.\n\nOur values are the core of our culture. Our values guide how all 74,000 of us around the world work together, serve our customers, patients, clients, communities, and deliver on our mission.	32
Exelon	Utilities	Chicago, IL	111969	24925	Exelon Corporation (Nasdaq: EXC) is a Fortune 100 energy company with the largest number of electricity and natural gas customers in the U.S. Exelon does business in 48 states, the District of Columbia and Canada and had 2019 revenue of $34 billion. Exelon serves approximately 10 million customers in Delaware, the District of Columbia, Illinois, Maryland, New Jersey and Pennsylvania through its Atlantic City Electric, BGE, ComEd, Delmarva Power, PECO and Pepco subsidiaries. Exelon is one of the largest competitive U.S. power generators, with more than 31,000 megawatts of nuclear, gas, wind, solar and hydroelectric generating capacity comprising one of the nation's cleanest and lowest-cost power generation fleets. The company's Constellation business unit provides energy products and services to approximately 2 million residential, public sector and business customers, including three fourths of the Fortune 100.	33
Biogen	Biotechnology	Cambridge, MA	469253	9687	Through cutting-edge science and medicine, Biogen discovers, develops and delivers innovative therapies worldwide for people living with serious neurological and neurodegenerative diseases. \n\nFounded in 1978, Biogen is a pioneer in biotechnology and today the Company has the leading portfolio of medicines to treat multiple sclerosis, has introduced the first and only approved treatment for spinal muscular atrophy, and is at the forefront of neurology research for conditions including Alzheimer’s disease, Parkinson’s disease and amyotrophic lateral sclerosis. Biogen also manufactures and commercializes biosimilars of advanced biologics. \n\nWith approximately 7000 people worldwide, we are truly a global organization, headquartered in Cambridge, Massachusetts, which is also home to our research operations. Our international headquarters are based in Zug, Switzerland and we have world-class manufacturing facilities in North Carolina and Denmark. We offer therapies globally through direct affiliate presence in 30 countries and a network of distribution partners in over 50 additional countries.\n\nFor more information, please visit www.biogen.com. Follow us on social media – Twitter, LinkedIn, Facebook, YouTube.	34
Fiserv	Information Technology & Services	Brookfield, Wisconsin	331908	28505	Fiserv, Inc. (NASDAQ: FISV) is a leading global technology provider serving the financial services industry, driving innovation in payments, processing services, risk and compliance, customer and channel management, and business insights and optimization. For more information, visit www.fiserv.com.	35
ViacomCBS	Entertainment	New York, New York	81050	19847	Driven by iconic consumer brands, its portfolio includes CBS, Showtime Networks, Paramount Pictures, Nickelodeon, MTV, Comedy Central, BET, CBS All Access, Pluto TV and Simon & Schuster, among others. The company delivers the largest share of the U.S. television audience and boasts one of the industry’s most important and extensive libraries of TV and film titles. In addition to offering innovative streaming services and digital video products, ViacomCBS provides powerful capabilities in production, distribution and advertising solutions for partners on five continents.	36
Ford Motor Company	Automotive	Dearborn, Michigan	2984710	164072	Ford Motor Company (NYSE: F) is a global company based in Dearborn, Michigan. The company designs, manufactures, markets and services a full line of Ford trucks, utility vehicles, and cars – increasingly including electrified versions – and Lincoln luxury vehicles; provides financial services through Ford Motor Credit Company; and is pursuing leadership positions in electrification; mobility solutions, including self-driving services; and connected vehicle services.  Ford employs approximately 186,000 people worldwide. For more information regarding Ford, its products and Ford Motor Credit Company, please visit corporate.ford.com.\n\nView us on Facebook: www.facebook.com/FordMotorCompanyCareers\n\nPrivacy Policy: https://www.ford.com/help/privacy/	37
Best Buy	Retail	Richfield, Minnesota	394893	65161	Best Buy is a leading provider of technology products, services and solutions. The company offers expert service at an unbeatable price more than 1.5 billion times a year to the consumers, small business owners and educators who visit our stores, engage with Geek Squad agents or use BestBuy.com or the Best Buy app. The company has operations in the U.S and Canada, where more than 70 percent of the population lives within 15 minutes of a Best Buy store, as well as in Mexico where Best Buy has a physical and online presence.\r\n\r\nAs for our workforce, our employees’ knowledge, passion and commitment are recognized through pay, benefits and other rewards that are among the best in the industry, including an industry-leading employee discount on the latest and greatest products.\r\n\r\nTo learn more about opportunities at Best Buy follow us on twitter @bestbuy_careers and check out our career site http://www.bestbuy-jobs.com/	38
Salesforce	Internet	San Francisco, CA	2607160	48728	We bring companies and customers together on the #1 CRM. Sharing the news, events, and innovation you need to change the world for good. \n\nPrivacy Statement: http://www.salesforce.com/company/privacy/	39
Carrier	Building Materials	Palm Beach Gardens, Florida	99548	14583	As the leading global provider of healthy, safe and sustainable building and cold chain solutions, Carrier Global Corporation is committed to making the world safer, sustainable and more comfortable for generations to come. From the beginning, we’ve led in inventing new technologies and entirely new industries. Today, we continue to lead because we have a world-class, diverse workforce that puts the customer at the center of everything we do. For more information, visit www.Corporate.Carrier.com.	40
Colgate-Palmolive	Consumer Goods	New York, New York	1429035	27607	We are Colgate, a caring, innovative growth company that is reimagining a healthier future for all people, their pets, and our planet.\n\nWe are a leading global consumer products company with 34,000 people dedicated to improving the health and wellness of people and their pets. Focused on Oral Care, Personal Care, Home Care and Pet Nutrition and reaching more than 200 countries and territories, Colgate teams are developing, producing, distributing and selling health and hygiene products and pet nutrition offerings essential to society through brands such as Colgate, Palmolive, elmex, Tom’s of Maine, hello, Sorriso, Speed Stick, Softsoap, Irish Spring, Protex, Sanex, Filorga, eltaMD, PCA Skin, Ajax, Axion, Fabuloso, Soupline and Suavitel, as well as Hill’s Science Diet and Hill’s Prescription Diet. \n\nWe are also recognized for its leadership and innovation in promoting environmental sustainability and community wellbeing, including our achievements in saving water, reducing waste, promoting recyclability and improving the oral health of children through our Bright Smiles, Bright Futures program, which has reached more than one billion children since 1991. \n\nFor more information about our global business and how the we are building a future to smile about, visit http://www.colgatepalmolive.com.\n\nFollow @CP_News on Twitter for news about Colgate-Palmolive: \nhttps://twitter.com/CP_News\n\nFor information about joining our team, visit https://jobs.colgate.com/ and stay connected at:\n\nhttp://facebook.com/ColgatePalmoliveJobs\nhttps://twitter.com/ColgateCareers	41
Unilever	Consumer Goods	Blackfriars, London	12987786	127566	Be part of the world’s most successful, purpose-led business. Work with brands that are well-loved around the world, that improve the lives of our consumers and the communities around us. We promote innovation, big and small, to make our business win and grow; and we believe in business as a force for good. Unleash your curiosity, challenge ideas and disrupt processes; use your energy to make this happen. Our brilliant business leaders and colleagues provide mentorship and inspiration, so you can be at your best. \n\nOur portfolio ranges from nutritionally balanced foods to indulgent ice creams, affordable soaps, luxurious shampoos and everyday household care products. We produce world-leading brands including Lipton, Knorr, Dove, Axe, Hellmann’s and Omo, alongside trusted local names and innovative-forward thinking brands like Ben & Jerry’s, The Dollar Shave Club and Dermalogica. \n\nEvery individual here can bring their purpose to life through their work. Join us and you’ll be surrounded by inspiring leaders and supportive peers. Among them, you’ll channel your purpose, bring fresh ideas to the table, and simply be you. As you work to make a real impact on the business and the world, we’ll work to help you become a better you.	42
PACCAR	Automotive	Bellevue, WA	64686	3840	PACCAR is a global technology leader in the design, manufacture and customer support of premium light-, medium- and heavy-duty trucks under the Kenworth, Peterbilt and DAF nameplates. PACCAR also designs and manufactures advanced diesel engines, provides financial services, information technology, and distributes truck parts related to its principal business.\r\n\r\nKenworth Truck Company builds premium commercial vehicles for sale in the U.S., Canada, Mexico and Australia and for export throughout the world. Peterbilt Motors also designs, manufactures and distributes premium commercial vehicles in the US and Canada. DAF Trucks manufactures trucks in the Netherlands, Belgium, Brasil and the United Kingdom for sale throughout Western and Eastern Europe, and export to Asia, Africa, North and South America.\r\n\r\nPACCAR Parts operates a network of parts distribution centers offering aftermarket support to Kenworth, Peterbilt and DAF dealers and customers around the world. Aftermarket support includes customer call centers operating 24 hours a day throughout the year and technologically advanced systems to enhance inventory control and expedite order processing.\r\n\r\nPACCAR Financial Services provides finance, lease and insurance services to dealers and customers in 224 countries including a portfolio of more than 175,000 trucks and trailers and total assets in excess of $12 billion. The group includes PACCAR Leasing, a major full-service truck leasing company in North America, with a fleet of over 39,000 vehicles.\r\n\r\nEnvironmental responsibility is one of PACCAR’s core values. The company regularly develops new programs to help protect and preserve the environment and PACCAR has established ambitious goals to further reduce emissions and enhance fuel efficiency in its truck models.	43
Kroger	Retail	Cincinnati, Ohio	287350	66966	At The Kroger Co. (NYSE: KR), we are dedicated to our Purpose: to Feed the Human Spirit™. We are nearly half a million associates who serve over nine million customers daily through a seamless digital shopping experience and 2,765 retail food stores under a variety of banner names, serving America through food inspiration and uplift, and creating #ZeroHungerZeroWaste communities by 2025. To learn more about us, visit kroger.com or thekrogerco.com.	44
Charles Schwab	Financial Services	San Francisco, CA	198597	21276	Charles Schwab is a different kind of investment services firm – one that strives to disrupt the status quo of the traditional Wall Street approach on behalf of our clients. We believe today, as we did on Day 1, that when you find ways to improve the investing experience for your clients, then business results will follow. \n\nSocial Media Disclosures\n\nBrokerage Products: Not FDIC Insured • No Bank Guarantee • May Lose Value\n\nThe Charles Schwab Corporation provides a full range of brokerage, banking and financial advisory services through its operating subsidiaries. Its broker-dealer subsidiary, Charles Schwab & Co., Inc. (member SIPC), and its affiliates offer investment services and products. Its banking subsidiary, Charles Schwab Bank (member FDIC and an Equal Housing Lender), provides deposit and lending services and products. Access to Electronic Services may be limited or unavailable during periods of peak demand, market volatility, systems upgrade, maintenance, or for other reasons. The Charles Schwab Corporation does not endorse third-party comments.\n\nThis profile is designed for U.S. residents. Non-U.S. residents are subject to country-specific restrictions. Learn more about our services for non-U.S. residents.\n\n© 2018 Charles Schwab Corporation, All rights reserved. Unauthorized access is prohibited. Usage will be monitored. \n\nFor additional information and disclosure please visit: http://www.aboutschwab.com/social-media-at-schwab\n\n\n\n\n(#0116-BLSK)	45
John Deere	Machinery	Moline, IL	849594	39682	John Deere is a world leader in providing advanced products, technology and services for customers whose work is revolutionizing agriculture and construction — those who cultivate, harvest, transform, enrich and build upon the land to meet the world's increasing need for food, fuel, shelter and infrastructure.	46
\.


--
-- Data for Name: complaint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaint (id, user_id, content, urgency, resolved, created_on) FROM stdin;
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact (created_time, receiver_id, sender_id) FROM stdin;
2022-04-26 02:17:39-04	3	4
2022-07-02 17:14:33-04	5	2
2022-09-10 22:00:06-04	4	1
2022-07-26 21:25:00-04	5	6
2022-07-23 18:10:49-04	5	7
2022-02-05 10:12:29-05	5	3
2022-08-11 15:49:38-04	4	3
2022-08-09 16:38:54-04	5	1
2021-12-03 06:52:02-05	3	1
2022-06-29 00:37:28-04	7	1
2022-08-28 05:14:38-04	2	3
2022-08-23 11:12:20-04	2	7
2022-10-06 01:13:40-04	6	1
2022-08-10 22:32:25-04	3	6
2022-09-10 01:10:10-04	4	6
2021-12-10 09:58:58-05	6	7
2022-09-05 19:53:33-04	1	4
2022-08-22 07:06:14-04	3	7
2022-07-14 23:52:59-04	8	2
2022-06-10 08:32:47-04	4	2
2022-01-28 23:05:27-05	6	5
2022-05-19 01:24:53-04	1	5
2022-02-28 05:35:54-05	6	3
2022-03-05 22:02:09-05	2	4
2021-05-23 12:36:04.982-04	1	3
2022-02-25 15:45:53.09-05	4	8
2022-03-07 23:48:18.188-05	3	2
2021-03-22 12:37:16.949-04	8	3
2022-03-16 08:27:20.861-04	4	5
2021-03-09 06:38:26.559-05	4	7
2022-03-24 21:30:34.071-04	7	8
2022-03-25 04:13:37.693-04	8	5
2021-02-24 04:59:57.602-05	2	5
2022-02-24 19:27:45.963-05	7	6
2021-03-20 05:26:26.819-04	3	8
2021-02-26 10:34:02.947-05	1	8
2021-02-12 00:40:22.386-05	8	7
2021-02-16 18:19:18.666-05	8	6
2022-02-13 23:27:17.545-05	8	4
2022-02-16 23:55:19.468-05	6	4
2022-01-26 07:23:01.645-05	7	3
2022-02-10 12:11:14.303-05	1	6
2022-02-20 10:28:51.891-05	2	6
2022-01-03 04:31:06.911-05	1	7
2022-01-07 13:59:11.738-05	6	8
2021-01-29 20:08:44.718-05	6	2
2021-01-12 00:36:06.991-05	7	4
2022-01-27 23:41:52.153-05	8	1
\.


--
-- Data for Name: contact_limitation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_limitation (blocked_user_id, user_id) FROM stdin;
1	5
4	1
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (id, content, send_time, receiver_id, sender_id) FROM stdin;
2	pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed	2022-09-01 14:46:30	1	8
3	aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec	2022-07-29 00:31:05	6	1
4	metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce	2022-03-24 12:15:37	6	7
5	non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis	2022-05-03 08:44:20	3	2
6	cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel	2022-09-15 04:07:36	6	1
7	in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod	2022-06-29 18:00:45	2	6
8	non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum	2022-04-18 19:32:09	5	4
9	vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat	2022-01-29 15:35:59	4	1
10	duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel	2022-08-31 04:05:07	2	6
11	semper rutrum nulla nunc purus phasellus in felis donec semper sapien a	2022-10-13 23:45:34	4	2
12	amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan	2022-06-14 06:29:56	6	8
13	volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget	2022-04-12 16:12:59	1	5
14	libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor	2022-04-14 18:31:57	8	6
15	ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus	2022-08-21 12:33:04	2	7
17	vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id	2022-01-04 04:18:19	8	3
18	consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis	2022-05-15 18:15:53	3	2
19	eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis	2022-09-25 21:25:41	1	7
20	arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at	2021-12-19 06:32:16	1	7
21	vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac	2022-09-22 00:50:54	1	7
81	augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi	2022-10-04 16:31:49	1	5
22	est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget	2022-06-05 19:35:39	3	6
23	felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis	2021-12-28 11:31:00	7	1
24	aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut	2022-11-06 23:17:46	3	4
25	id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu	2022-02-26 07:47:44	1	8
26	sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet	2021-12-26 14:09:55	7	1
28	platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel	2022-04-26 09:05:09	3	1
29	consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris	2022-03-30 07:52:52	1	8
30	tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna	2021-12-27 10:59:07	5	8
31	nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis	2021-11-23 11:01:36	4	6
32	laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus	2022-10-30 04:53:49	6	2
33	platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non	2022-01-19 20:24:47	6	3
36	rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer	2022-01-20 09:28:55	4	1
37	odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis	2022-04-17 06:13:59	4	6
38	lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem	2021-11-28 17:55:29	4	7
39	vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin	2022-02-22 20:59:46	1	7
40	odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum	2022-07-18 00:47:44	1	3
41	ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices	2022-07-07 13:59:44	2	7
42	eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis	2022-05-07 05:22:46	4	2
43	ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy	2022-10-13 16:15:40	7	8
44	fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque	2022-07-28 13:48:59	7	5
45	quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede	2022-06-22 07:12:49	8	7
46	risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi	2022-03-05 00:40:37	3	2
47	maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices	2022-04-05 19:11:55	8	7
48	non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan	2022-02-28 10:10:14	6	1
49	justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus	2022-10-22 02:30:50	4	2
50	orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet	2022-02-19 02:36:08	5	6
51	duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem	2022-09-30 23:38:49	2	8
52	tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris	2022-10-25 23:51:58	2	6
54	proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut	2022-02-21 07:26:12	7	5
55	enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer	2022-09-26 08:23:33	2	5
56	luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae	2021-11-28 05:19:28	2	4
57	eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula	2022-04-02 10:10:53	7	4
58	est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus	2022-03-20 03:49:23	5	6
59	faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros	2022-01-18 18:23:22	8	4
60	ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in	2022-06-01 12:51:25	1	3
61	in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae	2022-09-08 01:11:42	7	3
62	amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa	2022-11-10 23:49:29	1	8
64	ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris	2022-05-11 17:34:46	1	4
65	lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices	2022-05-07 16:10:42	8	1
66	faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non	2022-01-24 17:26:04	2	3
67	massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec	2022-09-11 12:55:32	3	4
68	neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo	2022-08-04 13:45:15	3	4
69	nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis	2022-08-27 06:29:19	3	4
70	ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim	2021-11-25 14:59:28	7	8
71	ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla	2021-12-17 01:23:42	7	8
72	risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id	2022-09-04 12:12:31	5	2
73	metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci	2022-04-23 10:22:49	6	3
75	donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac	2022-01-08 01:59:09	5	4
76	sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet	2022-04-13 19:30:04	5	4
77	nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget	2022-03-16 03:06:40	5	2
78	habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi	2022-01-11 13:31:00	7	1
79	rutrum ac lobortis vel dapibus at diam nam tristique tortor eu pede	2022-11-02 08:56:21	2	6
80	duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non	2022-05-22 21:50:57	6	1
83	duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique	2022-09-13 18:13:44	6	2
84	viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero	2022-03-25 21:24:59	5	2
85	eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea	2022-07-27 05:53:54	3	5
87	nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere	2022-01-01 06:02:26	8	3
88	augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui	2022-04-01 19:51:35	7	3
89	ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus	2022-08-18 20:09:09	3	8
90	nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer	2022-05-08 11:38:07	8	6
91	ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in	2022-03-01 05:47:52	3	1
92	pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus	2022-09-20 06:48:11	6	2
93	dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque	2022-04-06 12:57:33	5	2
94	dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut	2022-09-19 20:28:57	2	7
95	mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue	2022-10-09 15:11:58	7	3
96	commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo	2022-01-19 22:38:46	6	8
97	porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum	2022-06-20 15:45:42	4	3
98	praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit	2022-10-07 01:36:43	1	7
99	quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus	2022-06-10 01:42:38	4	8
100	turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in	2021-12-24 05:42:47	2	6
101	vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum	2021-12-07 19:14:04	4	8
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, payment_name, sending_time, amount, comment, method, receiver_id, user_id, category) FROM stdin;
2	ut	2022-09-21 00:00:00	2221	\N	posuere	1	3	\N
3	maecenas	2022-05-19 00:00:00	3955	\N	consequat	6	8	aenean
4	pede justo	2022-05-28 00:00:00	1844	aliquam non mauris morbi non lectus aliquam sit	quis	5	6	nec molestie
5	semper rutrum	2022-05-02 00:00:00	8412	\N	at ipsum	4	3	vestibulum
6	phasellus	2022-05-04 00:00:00	6545	\N	vivamus metus	8	8	luctus
7	nisi	2021-12-06 00:00:00	4818	viverra diam vitae quam suspendisse potenti nullam porttitor lacus at	pellentesque	5	5	et
8	faucibus orci	2022-09-02 00:00:00	6679	\N	condimentum neque	1	8	euismod scelerisque
9	ut	2022-02-17 00:00:00	2402	\N	molestie hendrerit	3	5	condimentum
10	et magnis	2022-05-29 00:00:00	7935	\N	in hac	8	5	quis justo
11	a	2022-08-18 00:00:00	6406	\N	vivamus in	3	1	elementum
12	condimentum	2022-09-07 00:00:00	6811	\N	vehicula	8	1	dui
13	enim blandit	2022-10-27 00:00:00	6258	\N	eu	4	7	sapien iaculis
14	diam in	2021-12-07 00:00:00	9511	\N	semper sapien	2	8	amet
15	tellus in	2022-09-01 00:00:00	1182	mattis odio donec vitae nisi nam ultrices libero non mattis	elit sodales	8	2	\N
16	nisi	2022-05-24 00:00:00	3187	\N	vestibulum	6	1	duis
17	quisque arcu	2022-04-24 00:00:00	7267	\N	aliquet	8	2	velit vivamus
18	amet	2022-01-30 00:00:00	5652	elit proin interdum mauris non ligula pellentesque ultrices phasellus	nulla	1	6	ipsum aliquam
19	massa volutpat	2022-11-15 00:00:00	4254	\N	sit amet	7	6	varius integer
20	pharetra magna	2022-07-16 00:00:00	9816	amet lobortis sapien	risus auctor	8	6	luctus nec
21	ultrices	2022-06-16 00:00:00	5155	\N	eget	5	4	\N
22	adipiscing	2022-09-20 00:00:00	3367	\N	primis in	4	6	ultricies
23	sit	2022-03-23 00:00:00	6349	\N	semper sapien	4	3	dui
24	enim lorem	2021-12-27 00:00:00	8423	\N	in	6	1	aenean
25	adipiscing molestie	2022-04-13 00:00:00	8085	integer a nibh in quis justo	augue vestibulum	8	4	ipsum ac
26	pede justo	2022-03-09 00:00:00	3147	at velit vivamus vel nulla	donec dapibus	2	3	elementum ligula
27	donec	2022-09-04 00:00:00	7446	amet diam in magna bibendum imperdiet nullam orci pede venenatis	non	6	7	augue
28	ipsum primis	2022-07-22 00:00:00	7158	\N	duis bibendum	4	3	duis bibendum
29	nulla dapibus	2022-03-06 00:00:00	7536	\N	dolor	2	7	posuere nonummy
30	at turpis	2021-12-08 00:00:00	4479	ultrices libero non	ipsum	3	1	volutpat dui
31	nam nulla	2022-11-15 00:00:00	3616	\N	ac nibh	8	7	diam
32	habitasse	2022-01-24 00:00:00	2085	cras non velit nec nisi	pellentesque eget	3	4	mauris lacinia
33	sapien	2022-07-04 00:00:00	4449	\N	suspendisse	2	1	interdum
34	a	2022-07-13 00:00:00	6198	est quam pharetra magna ac consequat metus	erat	6	7	augue quam
35	eu nibh	2022-04-21 00:00:00	2013	\N	pharetra	4	3	adipiscing elit
36	suscipit	2022-10-17 00:00:00	1543	\N	congue risus	8	7	parturient montes
37	donec	2022-11-04 00:00:00	5899	\N	consectetuer eget	6	1	ultricies
38	porttitor pede	2022-04-01 00:00:00	7913	\N	enim leo	2	1	purus sit
39	curae nulla	2021-11-29 00:00:00	5098	\N	hac	4	8	blandit
40	amet	2022-01-02 00:00:00	2045	\N	eleifend	3	3	\N
41	suspendisse potenti	2022-04-07 00:00:00	3865	a nibh in quis justo maecenas rhoncus aliquam	proin	6	8	dapibus duis
42	etiam faucibus	2022-11-14 00:00:00	6348	\N	condimentum curabitur	8	2	quis
43	metus sapien	2022-08-05 00:00:00	2121	\N	at	5	8	ante
44	iaculis	2022-10-30 00:00:00	6043	\N	duis ac	1	2	massa
45	sapien arcu	2022-08-26 00:00:00	5148	\N	risus	1	3	odio
46	sem	2021-11-28 00:00:00	6590	\N	augue	8	3	sit amet
47	urna	2021-12-10 00:00:00	6109	\N	luctus	3	2	curae mauris
48	sapien	2022-02-11 00:00:00	7026	\N	leo odio	3	2	morbi ut
49	consequat dui	2022-02-07 00:00:00	1178	\N	massa	3	8	augue
50	vestibulum ante	2022-04-29 00:00:00	1799	\N	arcu	4	1	faucibus
51	ut	2022-10-04 00:00:00	3347	\N	purus	1	6	ut rhoncus
52	at lorem	2022-01-16 00:00:00	4276	\N	platea dictumst	6	8	diam nam
53	ac	2022-10-05 00:00:00	1549	\N	vivamus	5	1	vel dapibus
54	eget	2022-11-13 00:00:00	1556	\N	leo	7	3	rhoncus aliquam
55	nisl aenean	2022-07-20 00:00:00	9002	urna ut tellus	et	7	8	phasellus in
56	duis	2022-09-10 00:00:00	9286	\N	luctus	3	2	praesent
57	condimentum	2022-01-14 00:00:00	3670	libero rutrum ac lobortis vel dapibus at diam	tellus nulla	2	7	faucibus orci
58	primis	2021-12-27 00:00:00	4757	\N	aliquam	4	5	id
59	tincidunt	2021-12-08 00:00:00	9592	nibh fusce lacus purus aliquet	cursus	5	6	quis odio
60	ipsum ac	2022-11-06 00:00:00	6348	justo pellentesque viverra	ut	5	1	augue vestibulum
61	sed augue	2022-04-26 00:00:00	962	\N	quis justo	2	3	in
62	turpis	2022-07-10 00:00:00	6566	\N	lectus	5	7	vestibulum sit
63	eu	2022-04-16 00:00:00	6234	\N	sapien	7	5	turpis
64	consequat	2022-11-14 00:00:00	9668	\N	nam congue	6	8	sed
65	cras	2022-01-28 00:00:00	6719	\N	ultrices	6	5	erat
66	lorem ipsum	2022-06-26 00:00:00	3746	quis libero nullam sit amet turpis elementum ligula	sit amet	5	6	amet sem
67	interdum	2022-09-06 00:00:00	87	\N	quam	5	3	est et
68	ut	2022-09-02 00:00:00	6646	quis tortor id nulla ultrices aliquet	turpis sed	7	4	odio curabitur
69	nisl	2021-12-23 00:00:00	3792	morbi non quam nec dui	amet	1	4	at
70	semper	2021-12-15 00:00:00	3911	\N	id massa	5	6	ante vel
71	in	2022-06-08 00:00:00	865	aliquet ultrices erat	nisi nam	2	1	bibendum
72	interdum venenatis	2022-05-21 00:00:00	7769	nullam varius nulla facilisi cras non	ultrices enim	7	4	suspendisse potenti
73	consequat	2022-11-12 00:00:00	9201	\N	nulla sed	7	4	mollis
74	nulla	2022-07-24 00:00:00	6250	\N	elementum pellentesque	7	3	at nibh
75	pede ac	2022-09-13 00:00:00	3893	\N	proin	5	5	\N
76	semper rutrum	2022-01-11 00:00:00	1813	tellus nisi eu	viverra diam	5	6	eu
77	ac	2022-09-13 00:00:00	7597	\N	quam	6	7	\N
78	sit amet	2022-05-14 00:00:00	9110	suspendisse potenti nullam porttitor lacus at turpis	montes nascetur	6	3	sapien varius
79	luctus ultricies	2022-04-03 00:00:00	9036	\N	commodo vulputate	5	7	nullam molestie
80	ante vestibulum	2022-02-07 00:00:00	2362	cum sociis natoque penatibus et magnis	lorem	6	8	a feugiat
81	cursus	2021-12-13 00:00:00	1020	\N	nonummy integer	8	7	\N
82	integer	2021-12-03 00:00:00	2460	\N	natoque	5	2	in
83	mauris sit	2022-07-26 00:00:00	4407	\N	nunc purus	6	7	\N
84	habitasse platea	2022-07-29 00:00:00	4934	\N	donec	6	3	adipiscing
85	sapien	2022-01-29 00:00:00	5996	rutrum rutrum neque aenean auctor gravida sem praesent id	odio curabitur	2	6	ultrices
86	mauris	2022-03-20 00:00:00	5023	\N	mus	8	2	nulla ultrices
87	ultrices	2022-04-08 00:00:00	5383	convallis morbi odio odio elementum eu interdum eu tincidunt	cras	5	5	vestibulum
88	pede	2022-01-05 00:00:00	8805	\N	suspendisse potenti	4	4	sit amet
89	erat curabitur	2022-08-17 00:00:00	8858	\N	quam fringilla	4	2	vel sem
90	montes	2022-02-09 00:00:00	1131	\N	maecenas	3	1	sit
91	sollicitudin	2022-01-06 00:00:00	9840	\N	ultrices mattis	1	2	sit
92	non	2022-09-27 00:00:00	9823	\N	integer tincidunt	2	1	cum
93	sit	2022-02-28 00:00:00	3271	\N	nulla neque	2	2	ultrices libero
94	ut at	2022-10-19 00:00:00	2677	\N	nulla sed	3	8	ut
95	ligula suspendisse	2022-02-09 00:00:00	4212	\N	aenean	7	8	donec
96	est quam	2022-09-01 00:00:00	1135	\N	turpis eget	5	1	vel ipsum
97	at	2022-06-26 00:00:00	9659	\N	non	4	1	fusce
98	dapibus augue	2022-06-14 00:00:00	9945	\N	nibh in	7	8	maecenas
99	sit	2022-08-20 00:00:00	5458	\N	imperdiet	2	8	rhoncus sed
100	quis augue	2022-03-24 00:00:00	3244	\N	bibendum morbi	4	3	consequat morbi
101	enim	2022-07-30 00:00:00	4151	\N	non lectus	2	3	\N
102	est	2022-01-24 00:00:00	8688	nunc proin at turpis	a	2	5	dapibus dolor
103	curabitur convallis	2022-07-12 00:00:00	4606	neque sapien	nulla	1	8	nisi
104	rutrum	2022-06-15 00:00:00	523	\N	aenean fermentum	8	4	cum
105	et	2022-04-09 00:00:00	1791	morbi porttitor lorem id ligula suspendisse ornare consequat	auctor gravida	15	7	aliquam erat
106	rutrum at	2022-03-25 00:00:00	7336	\N	tincidunt ante	8	1	sapien sapien
107	orci luctus	2022-04-27 00:00:00	5028	\N	lacus at	21	2	vitae
108	lacus	2022-06-22 00:00:00	2231	\N	eget rutrum	28	5	sit amet
109	luctus	2022-11-13 00:00:00	3204	\N	integer	33	1	turpis
110	viverra eget	2022-07-15 00:00:00	2662	\N	curabitur	20	1	\N
111	ante	2022-05-14 00:00:00	3487	\N	cursus	25	3	nec euismod
112	tortor duis	2022-02-23 00:00:00	4947	\N	vitae	41	5	odio
113	neque libero	2022-10-04 00:00:00	7101	\N	ligula	38	2	nec sem
114	imperdiet	2022-01-08 00:00:00	5780	rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet	proin at	10	5	ultrices aliquet
115	risus	2022-02-19 00:00:00	8901	\N	felis eu	13	7	ligula suspendisse
116	non velit	2022-06-08 00:00:00	4688	\N	nulla	13	7	non pretium
117	quam	2022-03-25 00:00:00	9254	\N	rutrum	40	4	ultrices
118	rutrum	2021-12-20 00:00:00	7965	quisque porta volutpat erat quisque erat eros viverra	est	43	1	libero
119	at	2022-04-10 00:00:00	7516	metus aenean fermentum donec	sit	32	2	suspendisse potenti
120	curae nulla	2022-10-20 00:00:00	8261	\N	erat fermentum	29	8	quisque erat
121	ligula sit	2022-07-09 00:00:00	1678	\N	bibendum	13	7	suscipit
122	in	2022-09-11 00:00:00	6533	nisi at nibh in hac habitasse platea dictumst	turpis elementum	32	5	amet turpis
123	maecenas	2022-11-17 00:00:00	9238	\N	at	35	3	nisi volutpat
124	dui vel	2022-02-27 00:00:00	2381	\N	ac diam	41	7	donec ut
125	sollicitudin	2022-03-23 00:00:00	4488	\N	duis	20	2	interdum mauris
126	orci	2022-09-09 00:00:00	9942	curae mauris viverra diam	adipiscing lorem	11	3	in
127	eu orci	2021-12-02 00:00:00	3319	\N	sollicitudin	31	6	nulla
128	luctus	2022-01-27 00:00:00	389	curabitur at ipsum ac tellus	vulputate	13	8	vulputate vitae
129	id luctus	2022-02-03 00:00:00	5816	ut mauris eget massa tempor convallis nulla	habitasse	12	1	lorem id
130	tortor	2022-04-10 00:00:00	8868	\N	cursus	30	2	vestibulum velit
131	risus	2022-11-17 00:00:00	7246	sit amet lobortis sapien sapien non mi integer ac neque	fringilla	8	1	interdum mauris
132	curabitur	2022-10-30 00:00:00	4087	\N	dui	31	2	eu felis
133	sapien urna	2022-11-19 00:00:00	2588	\N	lacus	24	8	luctus
134	vitae ipsum	2022-09-26 00:00:00	1823	\N	consequat	17	7	justo
135	enim leo	2022-10-04 00:00:00	4422	cubilia curae nulla dapibus dolor vel	in	37	5	\N
136	in	2022-01-09 00:00:00	5883	sit amet justo morbi	nisl nunc	31	5	ac enim
137	magna vulputate	2021-12-02 00:00:00	1122	rutrum rutrum	et ultrices	12	2	varius
138	arcu	2021-12-22 00:00:00	6463	augue a suscipit nulla elit ac nulla sed vel enim	enim	6	6	\N
139	eget massa	2022-06-27 00:00:00	6727	proin at	lorem ipsum	9	2	eros
140	convallis eget	2022-10-14 00:00:00	5576	\N	ipsum praesent	19	6	vel
141	enim	2022-04-20 00:00:00	8337	\N	ut blandit	19	6	at feugiat
142	pellentesque ultrices	2022-10-30 00:00:00	9626	luctus et ultrices	ultrices	29	3	mattis
143	tincidunt	2022-05-05 00:00:00	7513	\N	augue	33	3	est
144	porta volutpat	2021-12-05 00:00:00	5380	arcu libero rutrum ac lobortis vel dapibus	id consequat	9	2	nulla
145	etiam	2021-12-23 00:00:00	7964	\N	nibh ligula	11	1	\N
146	vestibulum ante	2022-08-31 00:00:00	6239	odio elementum eu interdum eu tincidunt in leo maecenas	praesent blandit	3	7	\N
147	proin interdum	2022-10-09 00:00:00	2698	\N	adipiscing elit	41	4	lobortis vel
148	faucibus	2022-10-24 00:00:00	8243	felis eu sapien cursus vestibulum proin eu mi nulla	placerat	43	1	rutrum neque
149	at	2022-10-08 00:00:00	213	\N	duis	22	6	velit nec
150	pulvinar nulla	2022-08-27 00:00:00	8250	\N	nulla	35	6	\N
151	vitae nisi	2022-09-04 00:00:00	7132	\N	iaculis congue	46	8	sit amet
152	sed	2022-10-03 00:00:00	9978	\N	ultrices posuere	11	8	nam
153	pretium quis	2022-05-24 00:00:00	7490	\N	iaculis congue	3	7	\N
154	dictumst	2022-10-28 00:00:00	6362	\N	vestibulum sagittis	29	2	faucibus orci
155	amet justo	2021-12-05 00:00:00	1905	felis eu sapien cursus vestibulum proin eu mi	eget massa	43	6	vel nulla
156	in	2022-06-05 00:00:00	8404	\N	lacinia	15	5	lacinia
157	vivamus in	2022-11-06 00:00:00	5527	sit amet diam in	donec	9	7	\N
158	enim lorem	2022-11-07 00:00:00	8616	\N	ut	33	5	eget
159	donec quis	2022-10-23 00:00:00	7660	\N	quam sollicitudin	19	2	\N
160	imperdiet	2022-04-15 00:00:00	6011	\N	quam turpis	45	4	mattis nibh
161	ridiculus mus	2022-01-18 00:00:00	2892	\N	sodales sed	32	7	congue vivamus
162	enim leo	2022-06-14 00:00:00	8989	eu sapien cursus vestibulum proin eu mi nulla ac enim	et	37	8	phasellus
163	id pretium	2021-12-16 00:00:00	6076	\N	cubilia curae	31	7	lorem
164	tincidunt nulla	2022-02-09 00:00:00	5893	\N	morbi non	10	6	montes
165	rutrum	2022-02-17 00:00:00	379	\N	est quam	26	3	risus
166	non velit	2022-11-13 00:00:00	2408	non mauris morbi non lectus	imperdiet nullam	18	5	dictumst
167	nec	2022-08-07 00:00:00	5077	\N	id	32	6	interdum eu
168	vivamus tortor	2022-09-10 00:00:00	9882	\N	id	23	7	nulla pede
169	vel sem	2022-05-20 00:00:00	9638	\N	faucibus orci	5	5	vel
170	pede	2022-07-09 00:00:00	1128	\N	dui	27	1	tempus
171	sit	2022-11-13 00:00:00	375	pellentesque quisque porta volutpat erat quisque erat eros viverra eget	convallis	20	6	turpis
172	diam	2022-04-13 00:00:00	6072	proin at turpis a pede	dolor sit	10	4	auctor gravida
173	dui	2022-07-31 00:00:00	2699	\N	ut	10	2	nisi eu
174	enim leo	2021-12-17 00:00:00	5698	rhoncus mauris enim leo rhoncus sed	amet	35	1	in eleifend
175	nam	2022-01-18 00:00:00	9317	amet	nulla	12	2	placerat
176	at velit	2021-12-29 00:00:00	7432	semper porta volutpat quam	in imperdiet	25	1	magna
177	lobortis vel	2022-05-05 00:00:00	9504	\N	metus	28	8	\N
178	eu magna	2022-07-30 00:00:00	9903	in blandit ultrices enim lorem ipsum dolor sit amet	sociis	37	5	felis
179	neque duis	2022-03-20 00:00:00	2593	luctus cum sociis natoque	diam	30	4	duis faucibus
180	congue	2022-07-18 00:00:00	8535	\N	lectus	21	7	donec posuere
181	amet cursus	2022-08-20 00:00:00	265	non	eget	38	6	habitasse
182	augue vestibulum	2022-08-01 00:00:00	9154	\N	luctus tincidunt	29	7	vehicula
183	a suscipit	2022-10-06 00:00:00	2882	\N	diam id	11	7	nisi
184	metus	2022-10-20 00:00:00	3200	sapien dignissim	interdum	13	5	mauris non
185	blandit	2022-06-10 00:00:00	2142	\N	amet erat	15	5	velit donec
186	augue vestibulum	2022-06-05 00:00:00	1324	\N	eget congue	38	5	mauris
187	risus semper	2022-01-06 00:00:00	9630	\N	dolor morbi	18	6	nulla
188	quis orci	2022-08-05 00:00:00	1652	\N	nam	7	1	id
189	ac	2022-09-13 00:00:00	7954	lectus pellentesque eget nunc	vel sem	17	5	fermentum justo
190	vestibulum ante	2022-07-04 00:00:00	7409	\N	vestibulum ac	29	5	sit
191	accumsan	2022-10-02 00:00:00	5983	\N	congue	24	5	eget
192	non	2022-10-22 00:00:00	4195	\N	leo	45	2	nisl aenean
193	eu	2021-12-09 00:00:00	7557	\N	etiam	14	1	morbi vestibulum
194	tincidunt	2022-03-23 00:00:00	100	aenean fermentum donec ut mauris eget	amet	34	5	nisl
195	lobortis	2022-03-10 00:00:00	1907	vel lectus in quam fringilla rhoncus	tincidunt	28	1	vestibulum quam
196	risus semper	2022-02-16 00:00:00	8947	\N	cras	12	2	\N
197	eleifend donec	2022-03-30 00:00:00	3717	\N	vivamus	46	5	congue etiam
198	volutpat eleifend	2022-06-28 00:00:00	7795	\N	tortor	17	6	\N
199	augue	2022-02-13 00:00:00	7014	\N	justo	45	2	tincidunt
200	at velit	2022-03-27 00:00:00	8506	tellus in sagittis	integer	5	5	in
201	mattis pulvinar	2022-08-23 00:00:00	6235	suscipit nulla	eu pede	23	6	magna
\.


--
-- Data for Name: payment_limitation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_limitation (id, amount, set_date, effective_days, user_id) FROM stdin;
133	25233	2022-08-23	60	1
136	55615	2022-10-23	120	1
137	7190	2022-04-17	30	6
152	14085	2022-09-03	60	6
153	34141	2022-04-28	60	4
159	87884	2022-11-21	30	8
139	40512	2022-01-24	30	1
145	40521	2022-04-02	60	1
151	46284	2021-11-26	60	4
162	54863	2022-08-05	60	4
148	70672	2022-07-19	30	5
149	34507	2022-09-08	30	5
142	69184	2022-04-21	60	5
154	8162	2022-11-13	90	6
157	78668	2022-02-14	30	6
155	28220	2022-01-23	30	7
143	43311	2022-04-08	60	7
156	34030	2022-09-29	90	7
140	88613	2021-11-26	60	8
131	31558	2022-02-24	30	8
144	53120	2022-04-14	30	8
141	62983	2022-09-04	30	8
161	61285	2022-05-28	90	8
134	91988	2022-11-22	15	5
150	8934	2022-03-22	21	4
132	50283	2022-01-18	45	5
\.


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer (id, transfer_name, sending_time, amount, comment, receiver_id, user_id) FROM stdin;
\.


--
-- Data for Name: transfer_limitation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer_limitation (id, amount, set_date, effective_days, user_id) FROM stdin;
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_id_seq', 8, true);


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 46, true);


--
-- Name: complaint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaint_id_seq', 1, false);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_id_seq', 101, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_seq', 201, true);


--
-- Name: payment_limitation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_limitation_id_seq', 162, true);


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfer_id_seq', 1, false);


--
-- Name: transfer_limitation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfer_limitation_id_seq', 1, false);


--
-- Name: account account_name_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_name_email_key UNIQUE (name, email);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: complaint complaint_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint
    ADD CONSTRAINT complaint_pkey PRIMARY KEY (id);


--
-- Name: contact_limitation contact_limitation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_limitation
    ADD CONSTRAINT contact_limitation_pkey PRIMARY KEY (blocked_user_id, user_id);


--
-- Name: contact contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (receiver_id, sender_id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: message message_receiver_id_sender_id_send_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_receiver_id_sender_id_send_time_key UNIQUE (receiver_id, sender_id, send_time);


--
-- Name: payment_limitation payment_limitation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_limitation
    ADD CONSTRAINT payment_limitation_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment payment_user_id_receiver_id_sending_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_user_id_receiver_id_sending_time_key UNIQUE (user_id, receiver_id, sending_time);


--
-- Name: transfer_limitation transfer_limitation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_limitation
    ADD CONSTRAINT transfer_limitation_pkey PRIMARY KEY (id);


--
-- Name: transfer transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transfer transfer_user_id_receiver_id_sending_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT transfer_user_id_receiver_id_sending_time_key UNIQUE (user_id, receiver_id, sending_time);


--
-- Name: complaint complaint_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint
    ADD CONSTRAINT complaint_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- Name: contact_limitation contact_limitation_blocked_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_limitation
    ADD CONSTRAINT contact_limitation_blocked_user_id_fkey FOREIGN KEY (blocked_user_id) REFERENCES public.account(id);


--
-- Name: contact_limitation contact_limitation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_limitation
    ADD CONSTRAINT contact_limitation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- Name: contact contact_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.account(id);


--
-- Name: contact contact_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.account(id);


--
-- Name: message message_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.account(id);


--
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.account(id);


--
-- Name: payment_limitation payment_limitation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_limitation
    ADD CONSTRAINT payment_limitation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- Name: payment payment_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.company(id);


--
-- Name: payment payment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- Name: transfer_limitation transfer_limitation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_limitation
    ADD CONSTRAINT transfer_limitation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- Name: transfer transfer_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT transfer_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.account(id);


--
-- Name: transfer transfer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT transfer_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.account(id);


--
-- PostgreSQL database dump complete
--

