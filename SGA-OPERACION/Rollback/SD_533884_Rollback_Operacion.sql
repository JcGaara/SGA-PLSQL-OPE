alter table operacion.ope_sp_mat_equ_det  DROP COLUMN IND_MATSEV;
alter table operacion.ope_sp_mat_equ_det  DROP COLUMN IDCAPEX;
alter table operacion.ope_sp_mat_equ_det  DROP COLUMN IDOPEX;

DELETE FROM operacion.opedd WHERE tipopedd= (select tipopedd from operacion.tipopedd where abrev='CPAREA');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'REC','CPAREA',(select tipopedd from operacion.tipopedd where abrev='CPAREA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'PEC','CPAREA',(select tipopedd from operacion.tipopedd where abrev='CPAREA'));

DELETE FROM operacion.opedd WHERE  TIPOPEDD=(select TIPOPEDD from operacion.tipopedd where abrev='SINERGIA_IMPUTACION');

insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('A','ACTIVO FIJO','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));
insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('N','ALMACEN','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));
insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('K','CENTRO DE COSTO','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));
insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('P','PROYECTO-EQUIPAMIENTO','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));
insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('S','PROYECTO-SERVICIO','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));
insert into operacion.opedd(CODIGOC,descripcion,abreviacion,tipopedd) values ('U','SUMINISTRO','SINERGIA_IMPUTACION',(select tipopedd from operacion.tipopedd where abrev='SINERGIA_IMPUTACION'));

UPDATE operacion.ope_sp_mat_equ_det SET IMPUTACION='N' WHERE IMPUTACION=' ';
UPDATE operacion.ope_sp_mat_equ_det SET IMPUTACION='U' WHERE IMPUTACION='K';
UPDATE operacion.ope_sp_mat_equ_det SET IMPUTACION='K' WHERE IMPUTACION='F';
UPDATE operacion.ope_sp_mat_equ_det SET IMPUTACION='S' WHERE IMPUTACION='P';
UPDATE operacion.ope_sp_mat_equ_det SET IMPUTACION='P' WHERE IMPUTACION='Q';

DELETE FROM operacion.opedd WHERE ABREVIACION='OPEX';
DELETE FROM operacion.tipopedd WHERE abrev='OPEX';
DELETE FROM operacion.opedd WHERE ABREVIACION='CAPEX';
DELETE FROM operacion.tipopedd WHERE abrev='CAPEX';

COMMIT;
