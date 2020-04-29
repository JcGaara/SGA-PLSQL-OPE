--Clase de Proyecto
insert into operacion.tipopedd ( descripcion, abrev)
values ('Clases de Proyecto UT', 'CLAS_PROY_UBIT');

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'A', 'Administrativo', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'F', 'Red Fija', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'G', 'GSM', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'H', 'HFC', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'I', 'IT', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'L', 'LTE', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'N', 'NSS', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'P', 'Prepago', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'R', 'Red Internacional', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'S', 'SVA', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'T', 'Transmision', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'U', 'UMTS', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'W', 'Wi-Fi', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'X', 'Otros Ingenieria', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'Y', 'Solucion Single Ran', ( select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT' ));

--Tipo Site
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('Tipos de Site UT', 'TIPO_SITE_UBIT');

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'ST', 'SITIO CELULAR', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'RP', 'REPETIDOR', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CW', 'CELDA MOVIL', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'IX', 'INTERCONEXIONES', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CS', 'COSITE', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( 'CI', 'CELULAS INDOOR', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT' ));

INSERT INTO operacion.opedd
  (codigon, descripcion, abreviacion, tipopedd)
VALUES
  (13, 'REQUISICIONES RED MOVIL', 'REQ_REDMOVIL', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev = 'SINTIPUBITEC'));
  
INSERT INTO operacion.tipopedd
  (descripcion, abrev)
VALUES
  ('REQUISICIONES RED MÓVIL', 'REQ_RED_MOVIL');

INSERT INTO operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd)
VALUES
  ('MVPE', NULL, 'GRUPO AUTORIZACIONES', 'GRUPO_AUTORIZACIONES', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='REQ_RED_MOVIL'));

INSERT INTO operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd)
VALUES
  ('I', NULL, 'TIPO', 'TIPO', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='REQ_RED_MOVIL'));
  
INSERT INTO operacion.tipopedd (descripcion, abrev)
VALUES ('USUARIOS REQ. RED MOVIL', 'USU_REQ_RED_MOVIL');

INSERT INTO operacion.opedd (codigoc, codigon, descripcion, tipopedd)
VALUES ('EASTULLE', 1, 'Edilberto Astulle', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='USU_REQ_RED_MOVIL'));
  
COMMIT;
/
