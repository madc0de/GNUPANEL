
--------------------------------------------------------------------------------------------------------------
--
--GNUPanel es un programa para el control de hospedaje WEB 
--Copyright (C) 2006  Ricardo Marcelo Alvarez rmalvarezkai@gmail.com
--
--------------------------------------------------------------------------------------------------------------
--
--Este archivo es parte de GNUPanel.
--
--	GNUPanel es Software Libre; Usted puede redistribuirlo y/o modificarlo
--	bajo los t�rminos de la GNU Licencia P�blica General (GPL) tal y como ha sido
--	p�blicada por la Free Software Foundation; o bien la versi�n 2 de la Licencia,
--	o (a su opci�n) cualquier versi�n posterior.
--
--	GNUPanel se distribuye con la esperanza de que sea �til, pero SIN NINGUNA
--	GARANT�A; tampoco las impl�citas garant�as de MERCANTILIDAD o ADECUACI�N A UN
--	PROP�SITO PARTICULAR. Consulte la GNU General Public License (GPL) para m�s
--	detalles.
--
--	Usted debe recibir una copia de la GNU General Public License (GPL)
--	junto con GNUPanel; si no, escriba a la Free Software Foundation Inc.
--	51 Franklin Street, 5� Piso, Boston, MA 02110-1301, USA.
--
--------------------------------------------------------------------------------------------------------------
--
--This file is part of GNUPanel.
--
--	GNUPanel is free software; you can redistribute it and/or modify
--	it under the terms of the GNU General Public License as published by
--	the Free Software Foundation; either version 2 of the License, or
--	(at your option) any later version.
--
--	GNUPanel is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--	GNU General Public License for more details.
--
--	You should have received a copy of the GNU General Public License
--	along with GNUPanel; if not, write to the Free Software
--	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--
--------------------------------------------------------------------------------------------------------------

--CREATE OR REPLACE FUNCTION database_size (name) RETURNS bigint
--    AS '$libdir/dbsize', 'database_size'
--    LANGUAGE C WITH (isstrict);

--CREATE OR REPLACE FUNCTION relation_size (text) RETURNS bigint
--    AS '$libdir/dbsize', 'relation_size'
--    LANGUAGE C WITH (isstrict);

create user gnupanel with ENCRYPTED password 'PASAPORTE_GNUPANEL' CREATEDB CREATEUSER;
create user apache with ENCRYPTED password 'PASAPORTE_APACHE' NOCREATEDB NOCREATEUSER;
create user postfix with ENCRYPTED password 'PASAPORTE_POSTFIX' NOCREATEDB NOCREATEUSER;
create user pdns with ENCRYPTED password 'PASAPORTE_PDNS' NOCREATEDB NOCREATEUSER;
create user proftpd with ENCRYPTED password 'PASAPORTE_PROFTPD' NOCREATEDB NOCREATEUSER;
create user sdns with ENCRYPTED password 'PASAPORTE_SDNS' NOCREATEDB NOCREATEUSER;

grant all on database gnupanel to gnupanel;
GRANT CONNECT ON DATABASE gnupanel TO apache;
GRANT CONNECT ON DATABASE gnupanel TO pdns;
GRANT CONNECT ON DATABASE gnupanel TO postfix;
GRANT CONNECT ON DATABASE gnupanel TO sdns;
GRANT CONNECT ON DATABASE gnupanel TO proftpd;

grant select on gnupanel_apache_user to apache;
grant select on gnupanel_postfix_transport to postfix;
grant select on gnupanel_postfix_transport_listas to postfix;
grant select on gnupanel_postfix_mailuser to postfix;
grant select on gnupanel_postfix_virtual to postfix;
grant select on gnupanel_postfix_alias to postfix;
grant select on gnupanel_postfix_autoreply to postfix;
grant select on gnupanel_postfix_transport to sdns;
grant select on gnupanel_postfix_virtual to sdns;

grant select on gnupanel_pdns_supermasters to pdns;
grant all on gnupanel_pdns_domains to pdns;
grant all on gnupanel_pdns_records to pdns;

grant select on gnupanel_pdns_supermasters_nat to pdns;
grant all on gnupanel_pdns_domains_nat to pdns;
grant all on gnupanel_pdns_records_nat to pdns;

grant select,update on gnupanel_proftpd_ftpuser to proftpd;
grant select on gnupanel_proftpd_ftpgroup to proftpd;
grant select,insert,update on gnupanel_proftpd_ftpquotalimits to proftpd;
grant select,insert,update on gnupanel_proftpd_ftpquotatallies to proftpd;

SELECT setval('gnupanel_usuarios_dominios_secuencia_seq',10000000);

INSERT INTO apache_dominios_conf(id,configurar) values (1,0);

INSERT INTO apache_dominios_conf(id,configurar) values (2,0);

INSERT INTO apache_dominios_conf(id,configurar) values (3,0);

INSERT INTO apache_dominios_conf(id,configurar) values (4,0);

INSERT INTO gnupanel_temas (tema) values ('gnupanel');
INSERT INTO gnupanel_temas (tema) values ('pop');
INSERT INTO gnupanel_temas (tema) values ('light-blue');
INSERT INTO gnupanel_temas (tema) values ('office');
INSERT INTO gnupanel_temas (tema) values ('gnupanel2');
INSERT INTO gnupanel_temas (tema) values ('gnupanel3');
INSERT INTO gnupanel_temas (tema) values ('gnutransfer');
INSERT INTO gnupanel_temas (tema) values ('blueshine');

INSERT INTO gnupanel_servidores (servidor) values ('NOMBRE_SERVIDOR');

INSERT INTO gnupanel_server_data (id_servidor) values ((SELECT id_servidor FROM gnupanel_servidores WHERE servidor = 'NOMBRE_SERVIDOR'));

--INSERT INTO gnupanel_ips_servidor (ip_publica,usa_nat,id_servidor,es_ip_principal,esta_usada,es_dns) values ('IP_PRINCIPAL',0,(SELECT id_servidor FROM gnupanel_servidores WHERE servidor = 'NOMBRE_SERVIDOR'),1,0,1);

INSERT INTO gnupanel_admin (admin,pasaporte,correo) values ('admin','PASAPORTE_ENC','CORREO_ADMIN');

INSERT INTO gnupanel_lang (idioma,descripcion) values ('es','Espa&ntilde;ol');
INSERT INTO gnupanel_lang (idioma,descripcion) values ('en','English');
INSERT INTO gnupanel_lang (idioma,descripcion) values ('fr','Fran&#231;ais');
INSERT INTO gnupanel_lang (idioma,descripcion) values ('nl','Netherlands');
INSERT INTO gnupanel_lang (idioma,descripcion) values ('de','German');

INSERT INTO gnupanel_admin_lang (idioma,id_admin) values ('IDIOMA_ADMIN',(SELECT id_admin FROM gnupanel_admin WHERE admin = 'admin' ));

INSERT INTO gnupanel_admin_sets (id_admin,id_tema) values ((SELECT id_admin FROM gnupanel_admin WHERE admin = 'admin' ),(SELECT id_tema FROM gnupanel_temas WHERE tema = 'gnutransfer' ));

DELETE FROM gnupanel_monedas;
INSERT INTO  gnupanel_monedas VALUES(0,'USD');
INSERT INTO  gnupanel_monedas VALUES(1,'EUR');
INSERT INTO  gnupanel_monedas VALUES(2,'$AR');
INSERT INTO  gnupanel_monedas VALUES(3,'AUD');

DELETE FROM gnupanel_tipos_base;

INSERT INTO  gnupanel_tipos_base VALUES(0,'PostgreSQL');
INSERT INTO  gnupanel_tipos_base VALUES(1,'MySQL');

CREATE EXTENSION pgcrypto;

UPDATE gnupanel_admin SET pasaporte = crypt('PASAPORTE_ADMIN',gen_salt('md5'));

