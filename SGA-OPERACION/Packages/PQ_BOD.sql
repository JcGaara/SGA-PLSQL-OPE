CREATE OR REPLACE PACKAGE OPERACION.PQ_BOD AS
  /******************************************************************************
     NAME:       PQ_BOD
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        09/01/2006                   1. Created this package.
     2.0        27/08/2009  José Robles       REQ.87455
     3.0        22/01/2010  MEchevarria       Req.116056 se corrigió p_insert_insprd para evitar el retorno de 2 filas
     4.0        06/10/2010                      REQ.139588 Cambio de Marca
  ******************************************************************************/

  FUNCTION f_get_bwmax_inssrv(a_codinssrv in number) return number;

  PROCEDURE p_insert_inssrv(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  PROCEDURE p_insert_insprd(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  PROCEDURE p_asigna_permiso(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number);
  PROCEDURE p_crear_instancias(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  PROCEDURE p_crear_sot_incidencia(a_codincidence in number);

  PROCEDURE p_enviar_notificaciones(a_codincidence in number);

  PROCEDURE p_enviar_notificaciones_noc(a_tipo   in number,
                                        a_tiempo in number);

  PROCEDURE p_genera_sots_job;

  PROCEDURE p_asigna_permiso_RAT(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE p_configuraURLTVRAT(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number);

  PROCEDURE p_exporta_precios; --REQ. 87455

END PQ_BOD;
/


