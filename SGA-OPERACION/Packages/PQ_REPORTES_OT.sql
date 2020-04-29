CREATE OR REPLACE PACKAGE OPERACION.PQ_REPORTES_OT IS
/******************************************************************************
 Para obtener ciertos datos especificos en los reportes de OT
******************************************************************************/
function f_get_fecfin_PI(a_codot in number, a_punto in number) return date;
function f_get_fecha_Asig_ot(a_codot in number, a_punto in number,a_etapa in number) return date;
function f_get_fecha_Asig_ot_de_PI(a_codot in number, a_punto in number) return date;
function f_get_fecha_Asig_ot_de_Com(a_codot in number, a_punto in number) return date;
function f_get_ult_post(a_codot in number, a_punto in number,a_etapa in number) return varchar2;
function f_get_ult_post_de_PI(a_codot in number, a_punto in number) return varchar2;
function f_get_ult_post_de_Com(a_codot in number, a_punto in number) return varchar2;

function f_get_fecha_cul_PE(a_codot in number, a_punto in number) return date;
function f_get_fecha_inst_equ_PI(a_codot in number, a_punto in number) return date;
function f_get_fecha_UM_PI(a_codot in number, a_punto in number) return date;

function f_get_fecha_contrato(a_proyecto in char) return date;

function f_get_fecha_ejecucion_ot(a_codot in number) return date;

function f_get_fecinisrv(a_codot in number, a_punto in number) return date;

function f_get_costo_ot_sin_permiso(a_codot in number) return number;
function f_get_costo_ot_con_permiso(a_codot in number) return number;
function f_get_costo_ot_con_permiso_m(a_codot in number, a_moneda in char) return number;
function f_get_costo_ot_SIN_permiso_m(a_codot in number, a_moneda in char) return number;

function f_get_contratista_etapa(a_codot in number, a_punto in number, a_etapa in number) return varchar2;
function f_get_num_postes(a_codot in number, a_punto in number, a_act in number) return number;

function f_get_obs_pex_ef(a_codot in number) return varchar2;
function f_get_obs_ef(a_codot in number) return varchar2;

function f_get_etapa_pex_ef(a_codot in number, a_punto in number) return varchar2;

function f_get_feccom_pex(a_codsolot in number) return date;

function f_get_diascom_OC(a_numpsp in char, a_idopc in char) return number;


pragma restrict_references (f_get_fecfin_PI,wnds,wnps);
pragma restrict_references (f_get_fecha_Asig_ot,wnds,wnps);
pragma restrict_references (f_get_fecha_Asig_ot_de_PI,wnds,wnps);
pragma restrict_references (f_get_fecha_Asig_ot_de_Com,wnds,wnps);
pragma restrict_references (f_get_ult_post,wnds,wnps);
pragma restrict_references (f_get_ult_post_de_PI,wnds,wnps);
pragma restrict_references (f_get_ult_post_de_Com,wnds,wnps);

pragma restrict_references (f_get_fecha_cul_PE,wnds,wnps);
pragma restrict_references (f_get_fecha_inst_equ_PI,wnds,wnps);
pragma restrict_references (f_get_fecha_UM_PI,wnds,wnps);

pragma restrict_references (f_get_fecha_contrato,wnds,wnps);

pragma restrict_references (f_get_fecha_ejecucion_ot,wnds,wnps);

pragma restrict_references (f_get_fecinisrv,wnds,wnps);

pragma restrict_references (f_get_contratista_etapa,wnds,wnps);
pragma restrict_references (f_get_num_postes,wnds,wnps);


pragma restrict_references (f_get_costo_ot_sin_permiso,wnds,wnps);
pragma restrict_references (f_get_costo_ot_con_permiso,wnds,wnps);
pragma restrict_references (f_get_costo_ot_sin_permiso_M,wnds,wnps);
pragma restrict_references (f_get_costo_ot_con_permiso_M,wnds,wnps);

pragma restrict_references (f_get_obs_pex_ef,wnds,wnps);
pragma restrict_references (f_get_obs_ef,wnds,wnps);
pragma restrict_references (f_get_etapa_pex_ef,wnds,wnps);

pragma restrict_references (f_get_feccom_pex,wnds,wnps);

pragma restrict_references (f_get_diascom_OC,wnds,wnps);

END;
/


