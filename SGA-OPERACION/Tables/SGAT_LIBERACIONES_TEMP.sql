-- Create table
create table OPERACION.SGAT_LIBERACIONES_TEMP
(
  ltempv_numero         VARCHAR2(15),
  ltempv_tecnologia     VARCHAR2(10),
  ltempv_tipoliberacion VARCHAR2(20),
  ltempv_estado         VARCHAR2(10),
  ltempv_observacion	VARCHAR2(100)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column OPERACION.SGAT_LIBERACIONES_TEMP.ltempv_numero
  is 'NUMERO A SER LIBERADO';
comment on column OPERACION.SGAT_LIBERACIONES_TEMP.ltempv_tecnologia
  is 'FECHA DE DESACTIVACION SGA';
comment on column OPERACION.SGAT_LIBERACIONES_TEMP.ltempv_tipoliberacion
  is 'TIPO LIBERACION';
comment on column OPERACION.SGAT_LIBERACIONES_TEMP.ltempv_estado
  is 'ESTADO LIBERACION';
comment on column OPERACION.SGAT_LIBERACIONES_TEMP.ltempv_observacion
  is 'OBSERVACION';