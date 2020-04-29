-- Create/Recreate indexes 
create index OPERACION.idk_proyectosap001 on OPERACION.PROYECTO_SAP (proyecto)
  tablespace OPERACION_IDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );


alter table OPERACION.UBI_TECNICA modify descripcion VARCHAR2(200);

alter table OPERACION.OPE_WS_SGASAP add fecactws date;
comment on column OPERACION.OPE_WS_SGASAP.fecactws  is 'Fecha Actualizacion del WS';