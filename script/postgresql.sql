CREATE SEQUENCE public.country_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

ALTER SEQUENCE public.country_seq
OWNER TO postgres;


CREATE SEQUENCE public.city_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

ALTER SEQUENCE public.city_seq
OWNER TO postgres;


CREATE SEQUENCE public.employee_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

ALTER SEQUENCE public.employee_seq
OWNER TO postgres;


CREATE SEQUENCE public.meeting_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.meeting_seq
    OWNER TO postgres;


CREATE SEQUENCE public.person_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;


ALTER SEQUENCE public.person_seq
    OWNER TO postgres;


CREATE SEQUENCE public.product_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.product_seq
    OWNER TO postgres;


CREATE TABLE public.country
(
    cou_id integer NOT NULL DEFAULT nextval('country_seq'::regclass),
    cou_name character varying(28)  NOT NULL,
    CONSTRAINT country_pkey PRIMARY KEY (cou_id)
)

TABLESPACE pg_default;

ALTER TABLE public.country
    OWNER to postgres;


CREATE TABLE public.city
(
    cit_id integer NOT NULL DEFAULT nextval('city_seq'::regclass),
    cit_name character varying(28) NOT NULL,
    cou_id integer NOT NULL,
    CONSTRAINT cit_pkey PRIMARY KEY (cit_id),
    CONSTRAINT country_fk FOREIGN KEY (cou_id)
        REFERENCES public.country (cou_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.city
    OWNER to postgres;


CREATE TABLE public.employee
(
    emp_id integer NOT NULL DEFAULT nextval('employee_seq'::regclass),
    emp_name character varying(28)  NOT NULL,
    emp_last_name character varying(28)  NOT NULL,
    emp_dni integer NOT NULL,
    emp_email character varying(48)  NOT NULL,
    cit_id integer NOT NULL,
    CONSTRAINT employee_pkey PRIMARY KEY (emp_id),
    CONSTRAINT dni_ux UNIQUE (emp_dni),
    CONSTRAINT email_ux UNIQUE (emp_email),
    CONSTRAINT city_fk FOREIGN KEY (cit_id)
        REFERENCES public.city (cit_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.employee
    OWNER to postgres;


CREATE TABLE public.mobile
(
    emp_id integer NOT NULL,
    mob_number character varying (30) NOT NULL,
    mob_observation character varying (200)  NOT NULL,
    CONSTRAINT mobile_pkey PRIMARY KEY (emp_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.mobile
    OWNER to postgres;


CREATE TABLE public.meeting
(
    mit_id integer NOT NULL DEFAULT nextval('meeting_seq'::regclass),
    mit_subject character varying(128)  NOT NULL,
    mit_date time with time zone NOT NULL,
    CONSTRAINT meeting_pkey PRIMARY KEY (mit_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.meeting
    OWNER to postgres;


CREATE TABLE public.employee_meeting
(
    mit_id integer NOT NULL,
    emp_id integer NOT NULL,
    CONSTRAINT student_meeting_pkey PRIMARY KEY (mit_id, emp_id),
    CONSTRAINT mit_fk FOREIGN KEY (mit_id)
        REFERENCES public.meeting (mit_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT mit_fk2 FOREIGN KEY (emp_id)
        REFERENCES public.employee (emp_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.employee_meeting
    OWNER to postgres;


CREATE TABLE public.agents
(
    agent_code character(6) NOT NULL,
    agent_name character varying(40) ,
    working_area character varying(40) ,
    commission integer,
    phone_no character varying(15) ,
    country character varying(28) ,
    CONSTRAINT agents_pkey PRIMARY KEY (agent_code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.agents
    OWNER to postgres;


CREATE TABLE  customer
   (	cust_code character varying(6) NOT NULL PRIMARY KEY,
	cust_name character varying(40) NOT NULL,
	cust_city CHAR(35),
	workking_area character varying(35) NOT NULL,
	cust_country character varying(20) NOT NULL,
	grade integer,
	opening_amt integer NOT NULL,
	receive_amt integer NOT NULL,
	payment_amt integer NOT NULL,
	outstanding_amt integer NOT NULL,
	phone_no character varying(17) NOT NULL,
	agent_code character(6) NOT NULL REFERENCES public.agents
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.customer
    OWNER to postgres;


CREATE TABLE  orders
   (
        ord_num integer NOT NULL PRIMARY KEY,
	ord_amount integer NOT NULL,
	advance_amount integer NOT NULL,
	ord_date DATE NOT NULL,
	cust_code character varying(6) NOT NULL REFERENCES public.customer,
	agent_code character(6) NOT NULL REFERENCES public.agents,
	ord_description character varying(60) NOT NULL
   )
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.orders
    OWNER to postgres;


CREATE TABLE public.person
(
    per_id integer NOT NULL DEFAULT nextval('person_seq'::regclass),
    per_first_name character varying(50) NOT NULL,
    per_last_name character varying(50) NOT NULL,
    CONSTRAINT person_pkey PRIMARY KEY (per_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.person
    OWNER to postgres;


CREATE TABLE public.student
(
    per_id integer NOT NULL,
    per_first_name character varying(50) NOT NULL,
    per_last_name character varying(50) NOT NULL,
    st_school character varying(50) NOT NULL,
	st_career character varying(50) NOT NULL,
    CONSTRAINT student_pkey PRIMARY KEY (per_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.student
    OWNER to postgres;


CREATE TABLE public.teacher
(
    per_id integer NOT NULL,
    per_first_name character varying(50) NOT NULL,
    per_last_name character varying(50) NOT NULL,
    joining_date timestamp without time zone NOT NULL,
	department_name character varying(50) NOT NULL,
    CONSTRAINT teacher_pkey PRIMARY KEY (per_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.teacher
    OWNER to postgres;


CREATE TABLE public.product
(
    prod_id integer NOT NULL,
    prod_name character varying(50),
    prod_description character varying(50),
    prod_number character varying(50),
    prod_pin character varying(8),
    prod_limit integer,
    ent_discriminator character (1),
    expire timestamp without time zone,
    CONSTRAINT entity_pkey PRIMARY KEY (prod_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.product
    OWNER to postgres;


INSERT INTO AGENTS VALUES ('A007', 'Ramasundar', 'Bangalore', 15, '077-25814763', '');
INSERT INTO AGENTS VALUES ('A003', 'Alex ', 'London', 13, '075-12458969', '');
INSERT INTO AGENTS VALUES ('A008', 'Alford', 'New York', 12, '044-25874365', '');
INSERT INTO AGENTS VALUES ('A011', 'Ravi Kumar', 'Bangalore', 15, '077-45625874', '');
INSERT INTO AGENTS VALUES ('A010', 'Santakumar', 'Chennai', 14, '007-22388644', '');
INSERT INTO AGENTS VALUES ('A012', 'Lucida', 'San Jose', 12, '044-52981425', '');
INSERT INTO AGENTS VALUES ('A005', 'Anderson', 'Brisban', 13, '045-21447739', '');
INSERT INTO AGENTS VALUES ('A001', 'Subbarao', 'Bangalore', 14, '077-12346674', '');
INSERT INTO AGENTS VALUES ('A002', 'Mukesh', 'Mumbai', 11, '029-12358964', '');
INSERT INTO AGENTS VALUES ('A006', 'McDen', 'London', 15, '078-22255588', '');
INSERT INTO AGENTS VALUES ('A004', 'Ivan', 'Torento', 15, '008-22544166', '');
INSERT INTO AGENTS VALUES ('A009', 'Benjamin', 'Hampshair', 11, '008-22536178', '');


INSERT INTO CUSTOMER VALUES ('C00013', 'Holmes', 'London', 'London', 'UK', '2', 6000, 5000, 7000, 4000, 'BBBBBBB', 'A003');
INSERT INTO CUSTOMER VALUES ('C00001', 'Micheal', 'New York', 'New York', 'USA', '2', 3000, 5000, 2000, 6000, 'CCCCCCC', 'A008');
INSERT INTO CUSTOMER VALUES ('C00020', 'Albert', 'New York', 'New York', 'USA', '3', 5000, 7000, 6000, 6000, 'BBBBSBB', 'A008');
INSERT INTO CUSTOMER VALUES ('C00025', 'Ravindran', 'Bangalore', 'Bangalore', 'India', '2', 5000, 7000, 4000, 8000, 'AVAVAVA', 'A011');
INSERT INTO CUSTOMER VALUES ('C00024', 'Cook', 'London', 'London', 'UK', '2', 4000, 9000, 7000, 6000, 'FSDDSDF', 'A006');
INSERT INTO CUSTOMER VALUES ('C00015', 'Stuart', 'London', 'London', 'UK', '1', 6000, 8000, 3000, 11000, 'GFSGERS', 'A003');
INSERT INTO CUSTOMER VALUES ('C00002', 'Bolt', 'New York', 'New York', 'USA', '3', 5000, 7000, 9000, 3000, 'DDNRDRH', 'A008');
INSERT INTO CUSTOMER VALUES ('C00018', 'Fleming', 'Brisban', 'Brisban', 'Australia', '2', 7000, 7000, 9000, 5000, 'NHBGVFC', 'A005');
INSERT INTO CUSTOMER VALUES ('C00021', 'Jacks', 'Brisban', 'Brisban', 'Australia', '1', 7000, 7000, 7000, 7000, 'WERTGDF', 'A005');
INSERT INTO CUSTOMER VALUES ('C00019', 'Yearannaidu', 'Chennai', 'Chennai', 'India', '1', 8000, 7000, 7000, 8000, 'ZZZZBFV', 'A010');
INSERT INTO CUSTOMER VALUES ('C00005', 'Sasikant', 'Mumbai', 'Mumbai', 'India', '1', 7000, 11000, 7000, 11000, '147-25896312', 'A002');
INSERT INTO CUSTOMER VALUES ('C00007', 'Ramanathan', 'Chennai', 'Chennai', 'India', '1', 7000, 11000, 9000, 9000, 'GHRDWSD', 'A010');
INSERT INTO CUSTOMER VALUES ('C00022', 'Avinash', 'Mumbai', 'Mumbai', 'India', '2', 7000, 11000, 9000, 9000, '113-12345678','A002');
INSERT INTO CUSTOMER VALUES ('C00004', 'Winston', 'Brisban', 'Brisban', 'Australia', '1', 5000, 8000, 7000, 6000, 'AAAAAAA', 'A005');
INSERT INTO CUSTOMER VALUES ('C00023', 'Karl', 'London', 'London', 'UK', '0', 4000, 6000, 7000, 3000, 'AAAABAA', 'A006');
INSERT INTO CUSTOMER VALUES ('C00006', 'Shilton', 'Torento', 'Torento', 'Canada', '1', 10000, 7000, 6000, 11000, 'DDDDDDD', 'A004');
INSERT INTO CUSTOMER VALUES ('C00010', 'Charles', 'Hampshair', 'Hampshair', 'UK', '3', 6000, 4000, 5000, 5000, 'MMMMMMM', 'A009');
INSERT INTO CUSTOMER VALUES ('C00017', 'Srinivas', 'Bangalore', 'Bangalore', 'India', '2', 8000, 4000, 3000, 9000, 'AAAAAAB', 'A007');
INSERT INTO CUSTOMER VALUES ('C00012', 'Steven', 'San Jose', 'San Jose', 'USA', '1', 5000, 7000, 9000, 3000, 'KRFYGJK', 'A012');
INSERT INTO CUSTOMER VALUES ('C00008', 'Karolina', 'Torento', 'Torento', 'Canada', '1', 7000, 7000, 9000, 5000, 'HJKORED', 'A004');
INSERT INTO CUSTOMER VALUES ('C00003', 'Martin', 'Torento', 'Torento', 'Canada', '2', 8000, 7000, 7000, 8000, 'MJYURFD', 'A004');
INSERT INTO CUSTOMER VALUES ('C00009', 'Ramesh', 'Mumbai', 'Mumbai', 'India', '3', 8000, 7000, 3000, 12000, 'Phone No', 'A002');
INSERT INTO CUSTOMER VALUES ('C00014', 'Rangarappa', 'Bangalore', 'Bangalore', 'India', '2', 8000, 11000, 7000, 12000, 'AAAATGF', 'A001');
INSERT INTO CUSTOMER VALUES ('C00016', 'Venkatpati', 'Bangalore', 'Bangalore', 'India', '2', 8000, 11000, 7000, 12000, 'JRTVFDD', 'A007');
INSERT INTO CUSTOMER VALUES ('C00011', 'Sundariya', 'Chennai', 'Chennai', 'India', '3', 7000, 11000, 7000, 11000, 'PPHGRTS', 'A010');


INSERT INTO ORDERS VALUES('200100', 1000, 600, '08/01/2008', 'C00013', 'A003', 'SOD');
INSERT INTO ORDERS VALUES('200110', 3000, 500, '04/15/2008', 'C00019', 'A010', 'SOD');
INSERT INTO ORDERS VALUES('200107', 4500, 900, '08/30/2008', 'C00007', 'A010', 'SOD');
INSERT INTO ORDERS VALUES('200112', 2000, 400, '05/30/2008', 'C00016', 'A007', 'SOD');
INSERT INTO ORDERS VALUES('200113', 4000, 600, '06/10/2008', 'C00022', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200102', 2000, 300, '05/25/2008', 'C00012', 'A012', 'SOD');
INSERT INTO ORDERS VALUES('200114', 3500, 2000, '08/15/2008', 'C00002', 'A008', 'SOD');
INSERT INTO ORDERS VALUES('200122', 2500, 400, '09/16/2008', 'C00003', 'A004', 'SOD');
INSERT INTO ORDERS VALUES('200118', 500, 100, '07/20/2008', 'C00023', 'A006', 'SOD');
INSERT INTO ORDERS VALUES('200119', 4000, 700, '09/16/2008', 'C00007', 'A010', 'SOD');
INSERT INTO ORDERS VALUES('200121', 1500, 600, '09/23/2008', 'C00008', 'A004', 'SOD');
INSERT INTO ORDERS VALUES('200130', 2500, 400, '07/30/2008', 'C00025', 'A011', 'SOD');
INSERT INTO ORDERS VALUES('200134', 4200, 1800, '09/25/2008', 'C00004', 'A005', 'SOD');
INSERT INTO ORDERS VALUES('200108', 4000, 600, '02/15/2008', 'C00008', 'A004', 'SOD');
INSERT INTO ORDERS VALUES('200103', 1500, 700, '05/15/2008', 'C00021', 'A005', 'SOD');
INSERT INTO ORDERS VALUES('200105', 2500, 500, '07/18/2008', 'C00025', 'A011', 'SOD');
INSERT INTO ORDERS VALUES('200109', 3500, 800, '07/30/2008', 'C00011', 'A010', 'SOD');
INSERT INTO ORDERS VALUES('200101', 3000, 1000, '07/15/2008', 'C00001', 'A008', 'SOD');
INSERT INTO ORDERS VALUES('200111', 1000, 300, '07/10/2008', 'C00020', 'A008', 'SOD');
INSERT INTO ORDERS VALUES('200104', 1500, 500, '03/13/2008', 'C00006', 'A004', 'SOD');
INSERT INTO ORDERS VALUES('200106', 2500, 700, '04/20/2008', 'C00005', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200125', 2000, 600, '10/10/2008', 'C00018', 'A005', 'SOD');
INSERT INTO ORDERS VALUES('200117', 800, 200, '10/20/2008', 'C00014', 'A001', 'SOD');
INSERT INTO ORDERS VALUES('200123', 500, 100, '09/16/2008', 'C00022', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200120', 500, 100, '07/20/2008', 'C00009', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200116', 500, 100, '07/13/2008', 'C00010', 'A009', 'SOD');
INSERT INTO ORDERS VALUES('200124', 500, 100, '06/20/2008', 'C00017', 'A007', 'SOD');
INSERT INTO ORDERS VALUES('200126', 500, 100, '06/24/2008', 'C00022', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200129', 2500, 500, '07/20/2008', 'C00024', 'A006', 'SOD');
INSERT INTO ORDERS VALUES('200127', 2500, 400, '07/20/2008', 'C00015', 'A003', 'SOD');
INSERT INTO ORDERS VALUES('200128', 3500, 1500, '07/20/2008', 'C00009', 'A002', 'SOD');
INSERT INTO ORDERS VALUES('200135', 2000, 800, '09/16/2008', 'C00007', 'A010', 'SOD');
INSERT INTO ORDERS VALUES('200131', 900, 150, '08/26/2008', 'C00012', 'A012', 'SOD');
INSERT INTO ORDERS VALUES('200133', 1200, 400, '06/29/2008', 'C00009', 'A002', 'SOD');