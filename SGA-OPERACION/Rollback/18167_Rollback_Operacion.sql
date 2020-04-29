-- Drop columns 
alter table OPERACION.TRS_PPTO drop column N_REINTENTOS_PPTO;

-- Drop columns 
alter table OPERACION.SOLOTPTOEQU drop column FEC_VAL_DESP;
alter table OPERACION.SOLOTPTOEQU drop column COD_RPTA_VAL_DESP;
alter table OPERACION.SOLOTPTOEQU drop column MSG_RPTA_VAL_DESP;

-- Alter columns
alter table OPERACION.OPE_SINERGIA_FILTROS_TMP modify tipo varchar2(3);

-- Drop tables
drop table OPERACION.PIVOT_SOT_DESPACHO;
drop table OPERACION.PIVOT_SOT_DESPACHO_HIST;
drop table OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR;

-- Drop sequences
drop sequence OPERACION.SEC_PIVOT_SOT_DES_ERROR;
drop sequence OPERACION.SEC_PIVOT_SOT_DESPACHO;

-- Revoke grant
revoke SELECT,INSERT,UPDATE on OPERACION.MAESTRO_SERIES_EQU from WEBSERVICE;

-- Delete rows
declare 
v_tipopedd number;

begin
  
delete from OPERACION.CFG_ENV_CORREO_CONTRATA where fase = 'VALIDA_DESPACHO';
delete from OPERACION.CFG_ENV_CORREO_CONTRATA where fase = 'PRESUPUESTO_MASIVO';

select max(tipopedd) into v_tipopedd from operacion.tipopedd where ABREV = 'REINTENTOS_DESPACHO';
delete from operacion.opedd where tipopedd = v_tipopedd;
delete from operacion.tipopedd where tipopedd = v_tipopedd;

commit;

end;
/
 