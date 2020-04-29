insert into TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Estados Solicitud de Pedidos', 'EST_SOL_PED');
COMMIT;
INSERT INTO OPEDD (tipopedd , CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 0, 'Generado');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 1, 'Pendiente');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 2, 'Cerrado');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 3, 'Anulado');
commit;

insert into TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Sol.Ped. Imputacion', 'SOP_IMPUTACION');
COMMIT;
INSERT INTO OPEDD (tipopedd , Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 'Almacen');
INSERT INTO OPEDD (tipopedd, CODIGOC, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 'P', 'Proyecto');
INSERT INTO OPEDD (tipopedd, CODIGOC, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 'K', 'Centro de Costo');
INSERT INTO OPEDD (tipopedd, CODIGOC, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 'A', 'Activo');
commit;

insert into TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Tipo de Posicion', 'SOP_TIPO_POSICION');
COMMIT;
INSERT INTO OPEDD (tipopedd , CODIGOC, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), '102', 'Normal');
INSERT INTO OPEDD (tipopedd, CODIGOC, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), '101', 'Servicios');
commit;

insert into TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Grupos de Compra', 'SOP_GRUPO_COMPRA');
COMMIT;
INSERT INTO OPEDD (tipopedd , CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 189, 'RS');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 190, 'IS');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 191, 'DT');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 192, 'Soporte Operativo 1');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 193, 'Soporte Operativo 2');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 194, 'Soporte Operativo 3');
commit;


insert into TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Sol. Ped. Estado Aprobacion', 'SOL_PED_EST_APRO');
COMMIT;
INSERT INTO OPEDD (tipopedd , CODIGON, Descripcion) VALUES ((select max(tipopedd) from TIPOPEDD), 0, 'Generado');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd)  from TIPOPEDD), 1, 'En Proceso');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd)  from TIPOPEDD), 2, 'Aprobado');
INSERT INTO OPEDD (tipopedd, CODIGON, Descripcion) VALUES ((select max(tipopedd)  from TIPOPEDD), 3, 'Anulado');
commit;


alter table OPERACION.SOLOTPTOETAMAT
 add idspcab number;
 comment on column OPERACION.SOLOTPTOETAMAT.idspcab is 'ID de Solicitud de Pedidos';


alter table OPERACION.solotptoequ
 add idspcab number;
 comment on column OPERACION.solotptoequ.idspcab is 'ID de Solicitud de Pedidos';


alter table OPERACION.efptoetamat
 add idspcab number;
 comment on column OPERACION.efptoetamat.idspcab is 'ID de Solicitud de Pedidos';

 
alter table OPERACION.efptoequ
 add idspcab number;
 comment on column OPERACION.efptoequ.idspcab is 'ID de Solicitud de Pedidos';


commit;
