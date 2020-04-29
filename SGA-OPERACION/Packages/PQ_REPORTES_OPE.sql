CREATE OR REPLACE PACKAGE OPERACION.PQ_REPORTES_OPE IS
/*********************************************************************************************************************/
-- Para obtener ciertos datos especificos con respecto a costos
/*********************************************************************************************************************/
function f_get_obs_pex_ef(a_codsolot in number) return varchar2;
function f_get_obs_ef(a_codsolot in number) return varchar2;
function f_get_etapa_pex_ef(a_codsolot in number, a_punto in number) return varchar2;
function f_get_fecha_contrato(a_numslc in char) return date;
function f_get_observa_ot_pex (a_codsolot in number) return varchar2;
function f_get_feccom_ot(a_codsolot in number, a_area in number) return date;
function f_get_fecha_servicio( a_codsolot in number, a_punto in number) RETURN date;
function F_GET_FECHA_PIN( a_codsolot in number, a_punto in number) RETURN date;

END;
/


