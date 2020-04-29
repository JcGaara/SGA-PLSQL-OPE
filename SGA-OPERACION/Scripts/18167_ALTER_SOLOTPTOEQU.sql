-- Add/modify columns 
alter table OPERACION.SOLOTPTOEQU add FEC_VAL_DESP date;
alter table OPERACION.SOLOTPTOEQU add COD_RPTA_VAL_DESP VARCHAR2(1);
alter table OPERACION.SOLOTPTOEQU add MSG_RPTA_VAL_DESP VARCHAR2(255);
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTOEQU.FEC_VAL_DESP
  is 'Fecha de última validación previa al despacho.';
comment on column OPERACION.SOLOTPTOEQU.COD_RPTA_VAL_DESP
  is 'Codigo de Respuesta de Validacion de Despacho.';
comment on column OPERACION.SOLOTPTOEQU.MSG_RPTA_VAL_DESP
  is 'Mensaje de Respuesta de Validacion de Despacho.';