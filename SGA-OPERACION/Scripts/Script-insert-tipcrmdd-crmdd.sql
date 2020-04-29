declare
ln_tipatc number;

begin

INSERT INTO sales.tipcrmdd(tipcrmdd, descripcion, abrev)
VALUES((select max(tipcrmdd)+1 from sales.tipcrmdd),'Edicion de Cantidad - VtaMenor','EDITCANT_VTAMENOR');

commit;

INSERT INTO sales.tipcrmdd(tipcrmdd, descripcion, abrev)
VALUES((select max(tipcrmdd)+1 from sales.tipcrmdd),'Seleccion Serv. Vta Menor','SELSRVVTAMENOR');

commit;

select t.tipcrmdd 
into ln_tipatc 
from sales.tipcrmdd t
where t.abrev='EDITCANT_VTAMENOR';

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYA','CE en HFC - Presencia Web - Web Entry','Presencia-Cant');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYC','CE en HFC - Presencia Web - Business','Presencia-Cant');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYD','CE en HFC - Presencia Web - Elite Ecommerce','Presencia-Cant');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYE','CE - Presencia Web - Web Entry','Presencia-Cant');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYG','CE - Presencia Web - Business','Presencia-Cant');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYH','CE - Presencia Web - Elite Ecommerce','Presencia-Cant');
COMMIT;


       
select t.tipcrmdd 
into ln_tipatc 
from sales.tipcrmdd t
where t.abrev='SELSRVVTAMENOR';


INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AAQW','Office 365 - Paquete K1','Office');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AAQX','Office 365 - Paquete P1','Office1');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AAQY','Office 365 - Paquete E1','Office');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AAQZ','Office 365 - Paquete E3','Office');
commit;


INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AARA','CE Office 365 -Paquete K1','Office');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AARB','CE Office 365 -Paquete P1','Office1');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AARC','CE Office 365 -Paquete E1','Office');
commit;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'AARD','CE Office 365 -Paquete E3','Office');
commit;


INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYA','CE en HFC - Presencia Web - Web Entry','Presencia');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYC','CE en HFC - Presencia Web - Business','Presencia');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYD','CE en HFC - Presencia Web - Elite Ecommerce','Presencia');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYE','CE - Presencia Web - Web Entry','Presencia');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYG','CE - Presencia Web - Business','Presencia');
COMMIT;

INSERT INTO sales.crmdd (TIPCRMDD, CODIGOC, DESCRIPCION, ABREVIACION)
VALUES (ln_tipatc,'ABYH','CE - Presencia Web - Elite Ecommerce','Presencia');
COMMIT;



end;
/