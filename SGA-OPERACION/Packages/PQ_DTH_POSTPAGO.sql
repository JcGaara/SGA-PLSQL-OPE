CREATE OR REPLACE PACKAGE OPERACION.PQ_DTH_POSTPAGO IS

 /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_DTH_POSTPAGO
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
   1.0     06/07/2015  Luis Flores Osorio                     SD-417723
  *******************************************************************************************************/

  procedure p_request_get(a_hora    in varchar2,
                          o_mensaje OUT VARCHAR2,
                          o_error   OUT NUMBER);
  procedure p_finalizar_request(o_mensaje  OUT VARCHAR2,
                                o_error    OUT NUMBER,
                                o_contador OUT NUMBER);
  procedure p_request_contract_list(a_hora    in varchar2,
                                    o_mensaje OUT VARCHAR2,
                                    o_error   OUT NUMBER);
  procedure p_planos_get(o_mensaje OUT VARCHAR2, o_error OUT NUMBER);
  procedure p_ejecuta_alta_dthpost(o_mensaje out varchar2,
                                   o_error   out number);

  procedure p_request_get_baja(a_hora    in varchar2,
                               o_mensaje out varchar2,
                               o_error   out number);

  procedure p_finalizar_request_baja(o_mensaje  out varchar2,
                                     o_error    out number,
                                     o_contador out number);

  procedure p_request_contract_list_baja(a_hora    in varchar2,
                                         o_mensaje out varchar2,
                                         o_error   out number);

  procedure p_planos_get_baja(o_mensaje out varchar2, o_error out number);

  procedure p_ejecuta_baja_dthpost(o_mensaje out varchar2,
                                   o_error   out number);
                                                     
  FUNCTION F_OBT_ACTION(P_CO_ID NUMBER, P_REQUEST NUMBER, P_FLAG NUMBER) RETURN NUMBER;
 
END PQ_DTH_POSTPAGO;
/

