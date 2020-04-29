-- Add/modify columns 
alter table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA modify sgav_usureg not null;
alter table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA modify sgad_fecreg not null;
alter table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA modify sgav_usumod not null;
alter table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA modify sgad_fecmod not null;