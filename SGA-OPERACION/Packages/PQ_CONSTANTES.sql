CREATE OR REPLACE PACKAGE OPERACION.PQ_CONSTANTES IS
/******************************************************************************
 Para obtener los valores de las constantes y configuraciones del sistema
******************************************************************************/
function f_get_frr return number;
function f_get_numcircuitos return number;
function f_get_numtelefonos return number;
function f_get_cfg_wf return number;
function f_get_cfg_solot_auto_exe return number;
function f_get_cfg return char;
function f_get_cliatt return char;
function f_get_codpai return varchar2;
function f_get_size_pwd return number;

pragma restrict_references (f_get_frr,wnds,wnps);
pragma restrict_references (f_get_numcircuitos ,wnds,wnps);
pragma restrict_references (f_get_numtelefonos,wnds,wnps);



END;
/


