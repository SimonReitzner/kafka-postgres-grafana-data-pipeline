CREATE TABLE public.shops (
	id INTEGER,
	name VARCHAR(200),
	city VARCHAR(50),
	latitude NUMERIC,
	longitude NUMERIC,
	PRIMARY KEY (id)
);
CREATE TABLE public.products (
	id INTEGER,
	name VARCHAR(100),
	price NUMERIC,
	cost NUMERIC,
	PRIMARY KEY (id)
);
CREATE TABLE public.orders (
	id VARCHAR(255),
	sub_id INTEGER,
	shop_id INTEGER,
	order_date TIMESTAMP,
	product_id INTEGER,
	PRIMARY KEY (id, sub_id),
	FOREIGN KEY (shop_id) REFERENCES shops (id),
	FOREIGN KEY (product_id) REFERENCES products (id)
);
INSERT INTO public.shops (id, name, city, latitude, longitude) VALUES
	(1,'Bahnhofstraße 1','Munich',48.14177271110128,11.55870077858733),
	(2,'Karlsplatz 8 - EKZ Stachus-Passagen','Munich',48.140410262697706,11.566606360081384),
	(3,'Leopoldstrasse 56','Munich',48.16091078077698,11.593900518884828),
	(4,'Odeonsplatz 15-16','Munich',48.14499209462924,11.582227545308513),
	(5,'Rosental 7','Munich',48.13479696122321,11.578107672281577),
	(6,'PEP EKZ','Munich',48.1033225824382,11.649561372857443),
	(7,'Pasinger Bahnhofsplatz 5','Munich',48.151429243277754,11.466562218361934),
	(8,'Platzl 3','Munich',48.13995205701101,11.58651907971157);
INSERT INTO public.products (id, name, price, cost) VALUES
    (1,'fresh orange juice',4.0,2.5),
    (2,'grapefruit juice',3.0,2.5),
    (3,'apple juice',3.0,1.5),
    (4,'tomato juice',3.0,2.0),
    (5,'watermelon agua fresca',6.0,4.0),
    (6,'green power juice',7.0,3.5),
    (7,'paris house drip',3.0,2.0),
    (8,'espresso',4.0,2.0),
    (9,'americano',4.0,1.5),
    (10,'cortado',5.0,2.0),
    (11,'cappuccino',5.0,2.5),
    (12,'latte',5.0,3.5),
    (13,'magnolia cold brew',4.0,2.5),
    (14,'hot teas',3.5,1.5);
