-- Add/modify columns 
alter table OPERACION.LOG_TRS_INTERFACE_IW add cod_id number;
-- Add comments to the columns 
comment on column OPERACION.LOG_TRS_INTERFACE_IW.cod_id
  is 'COD ID';

ALTER TABLE OPERACION.SOLOTPTOEQU ADD SPTOC_EST_DESPACHO CHAR(1);
COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.SPTOC_EST_DESPACHO IS 'Estado del despacho';
 
ALTER TABLE OPERACION.SOLOTPTOEQU ADD SPTON_DCTOSAP number(20);
COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.SPTON_DCTOSAP IS 'N�mero de despacho del webservice'; 
