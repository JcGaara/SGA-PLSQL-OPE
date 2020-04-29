-- Add/modify columns 
alter table OPERACION.OPE_CARGA_DIARIA_TMP add OBSERVACION VARCHAR2(500);
-- Add comments to the columns 
comment on column OPERACION.OPE_CARGA_DIARIA_TMP.OBSERVACION
  is 'Observación del registro si tiene errores, FLG_MANTENIMIENTO=9';

-- Add/modify columns 
alter table OPERACION.OPE_CARGA_INICIAL_TMP add OBSERVACION VARCHAR2(500);
-- Add comments to the columns 
comment on column OPERACION.OPE_CARGA_INICIAL_TMP.OBSERVACION
  is 'Observación del registro si tiene errores, FLG_MANTENIMIENTO=9';
/