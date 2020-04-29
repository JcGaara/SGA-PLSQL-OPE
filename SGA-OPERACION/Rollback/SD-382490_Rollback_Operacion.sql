alter table OPERACION.PLANO DROP COLUMN AREA;  
alter table OPERACION.PLANO DROP COLUMN FECREC;
alter table OPERACION.PLANO DROP COLUMN STAPLANO;
alter table OPERACION.PLANO DROP COLUMN PNI;
alter table OPERACION.PLANO DROP COLUMN FECINGPNI;
alter table OPERACION.PLANO DROP COLUMN FECENT;
alter table OPERACION.PLANO DROP COLUMN FECREV;
alter table OPERACION.PLANO DROP COLUMN IDENTIFICADOR;
alter table OPERACION.PLANO DROP COLUMN ESTREV;
alter table OPERACION.PLANO DROP COLUMN USUREC;
alter table OPERACION.PLANO DROP COLUMN PAQUETE;
alter table OPERACION.PLANO DROP COLUMN FECING ;
alter table OPERACION.PLANO DROP COLUMN FECRECING;
alter table OPERACION.PLANO DROP COLUMN USUOPEGIS;
alter table OPERACION.PLANO DROP COLUMN OPENIV;
alter table OPERACION.PLANO DROP COLUMN STACONTROL;
alter table OPERACION.PLANO DROP COLUMN USUSUPERV;
alter table OPERACION.PLANO DROP COLUMN CODSOLOTORI;

delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPAREA');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPIDENT');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPSPLA');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPPNI');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPOPENIV');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPSREV');
delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPEDIS');
delete from operacion.opedd where tipopedd=231 and CODIGON in (7,8,9,10);
delete from operacion.tipopedd where abrev in ('CPAREA','CPSPLA','CPIDENT','CPPNI','CPOPENIV','CPSREV','CPEDIS');


commit;
