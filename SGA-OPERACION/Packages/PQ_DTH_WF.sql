CREATE OR REPLACE PACKAGE OPERACION.PQ_DTH_WF AS


procedure p_ejecuta_wf_corte_dth;
procedure p_ejecuta_wf_reconexion_dth(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);
PROCEDURE p_verif_sol_corte;
PROCEDURE p_verif_sol_reconexion;

END PQ_DTH_WF;
/


