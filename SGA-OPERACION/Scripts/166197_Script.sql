-- Add/modify columns 
alter table OPERACION.TRS_WS_SGA add ENDPOINTS VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add SERVICIOS VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add CALLFEATURES VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add SOFTSWITCH VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add TIPOACCION number;
alter table OPERACION.TRS_WS_SGA add RESPUESTAXML VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add ESQUEMAXML VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add FECMOD DATE;
alter table OPERACION.TRS_WS_SGA add RESULTADO number;
alter table OPERACION.TRS_WS_SGA add ERROR VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add RESULTADO_WS number;
alter table OPERACION.TRS_WS_SGA add ERROR_WS VARCHAR2(4000);

-- Add comments to the columns 
comment on column OPERACION.TRS_WS_SGA.ENDPOINTS
  is 'Arreglo 5';
comment on column OPERACION.TRS_WS_SGA.SERVICIOS
  is 'Arreglo 6';
comment on column OPERACION.TRS_WS_SGA.CALLFEATURES
  is 'Arreglo 7';
comment on column OPERACION.TRS_WS_SGA.SOFTSWITCH
  is 'Arreglo 8';
comment on column OPERACION.TRS_WS_SGA.TIPOACCION
  is 'Tipo de Accion';
comment on column OPERACION.TRS_WS_SGA.RESPUESTAXML
  is 'RESPUESTA XML';
comment on column OPERACION.TRS_WS_SGA.ESQUEMAXML
  is 'ESQUEMA XML';
comment on column OPERACION.TRS_WS_SGA.FECMOD
  is 'Fecha Modificacion';
comment on column OPERACION.TRS_WS_SGA.RESULTADO
  is 'RESULTADO';
comment on column OPERACION.TRS_WS_SGA.ERROR
  is 'Error';
comment on column OPERACION.TRS_WS_SGA.RESULTADO_WS
  is 'RESULTADO WS';
comment on column OPERACION.TRS_WS_SGA.ERROR_WS
  is 'Error WS';

