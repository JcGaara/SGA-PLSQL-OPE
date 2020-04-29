TRUNCATE TABLE OPERACION.SGAT_VISITA_PROTOTYPE;

-- Add/modify columns 
alter table OPERACION.SGAT_VISITA_PROTOTYPE modify tipequ number;
alter table OPERACION.SGAT_VISITA_PROTOTYPE add tip_eq VARCHAR2(100);
alter table OPERACION.SGAT_VISITA_PROTOTYPE add accion number;
alter table OPERACION.SGAT_VISITA_PROTOTYPE add iddet number;
alter table OPERACION.SGAT_VISITA_PROTOTYPE add codtipequ VARCHAR2(15);
-- Add comments to the columns 
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.tip_eq
  is 'Tipo de Equipo';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.tipo_accion
  is 'INSTALAR / RETIRAR / REFRESCAR';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.accion
  is '4 (INSTALAR) / 12 (RETIRAR) / 15 (REFRESCAR)';