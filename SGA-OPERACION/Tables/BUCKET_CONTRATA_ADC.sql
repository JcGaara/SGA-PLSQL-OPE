create table OPERACION.BUCKET_CONTRATA_ADC
(
  idbucket        VARCHAR2(32) not null,
  codcon          NUMBER(8) not null,
  estado          CHAR(1),
  flg_rec_subtipo CHAR(1) default '0',
  feccre          DATE default SYSDATE,
  usucre          VARCHAR2(30) default USER,
  fecmod          DATE,
  usumod          VARCHAR2(30),
  ipcre           VARCHAR2(30),
  ipmod           VARCHAR2(30)
)
TABLESPACE operacion_dat;

COMMENT ON COLUMN operacion.bucket_contrata_adc.idbucket IS 'Id del Bucket';
COMMENT ON COLUMN operacion.bucket_contrata_adc.codcon   IS 'Codigo de contrata';
COMMENT ON COLUMN operacion.bucket_contrata_adc.estado   IS 'Estado';
comment on column OPERACION.BUCKET_CONTRATA_ADC.flg_rec_subtipo
  is 'Flag para omitir la recepccion de SubTipo de Orden. 0 : No , 1 : Omitir';
COMMENT ON COLUMN operacion.bucket_contrata_adc.feccre   IS 'Fecha de creacion';
COMMENT ON COLUMN operacion.bucket_contrata_adc.usucre   IS 'Usuario de creacion';
COMMENT ON COLUMN operacion.bucket_contrata_adc.fecmod   IS 'Fecha de modificacion';
COMMENT ON COLUMN operacion.bucket_contrata_adc.usumod   IS 'Usuario que modifico';
COMMENT ON COLUMN operacion.bucket_contrata_adc.ipcre    IS 'IP que registro';
COMMENT ON COLUMN operacion.bucket_contrata_adc.ipmod    IS 'IP que modifico'; 
/
