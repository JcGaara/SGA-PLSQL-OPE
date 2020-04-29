-- Drop columns 
alter table OPERACION.SGAT_VISITA_PROTOTYPE drop column accion;
alter table OPERACION.SGAT_VISITA_PROTOTYPE drop column iddet;
alter table OPERACION.SGAT_VISITA_PROTOTYPE drop column codtipequ;
alter table OPERACION.SGAT_VISITA_PROTOTYPE drop column tip_eq;
alter table OPERACION.SGAT_VISITA_PROTOTYPE modify tipequ VARCHAR2(50);