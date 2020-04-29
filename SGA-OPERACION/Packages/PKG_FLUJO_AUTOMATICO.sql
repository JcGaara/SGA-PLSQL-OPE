CREATE OR REPLACE PACKAGE OPERACION.PKG_FLUJO_AUTOMATICO IS
  /****************************************************************************************
     REVISIONES:
     Version    Fecha        Autor           Solicitado por          Descripción
     --------   ------       -------         ---------------         ------------
       1.0     09/01/2020   Freddy Dick      
                            Salazar Valverde 

     /****************************************************************************************/

     procedure sgass_detalle_flujo(iv_transaccion   in varchar2,
                              iv_tecnologia    in varchar2,
                              in_idtransversal in number,
                              ib_param_envio   in clob,
                              on_idflujo       in out number,
                              ov_descripcion   out varchar2,
                              on_idtrs         out number,
                              oc_detflujo      out sys_refcursor,
                              oc_detcondicion  out sys_refcursor,
                              on_codResp       out number,
                              ov_msjRes        out varchar2);
                      
     procedure sgasi_crea_transaccion(in_idtransversal in number,
                    ib_param_envio   in clob,
                    in_idflujo       in number,
                    on_idtrs         out number);
                    
    procedure sgasu_registra_transaccion(in_idtrs         in number,
                                     ib_trama_cab     in clob,
                                     ib_trama_det     in clob,
                                     on_codResp       out number,
                                     ov_msjRes        out varchar2);
     procedure sgass_evalua_condicion(in_idflujo     in number,
                                   in_idcondicion in number,
                                   ib_valores     in clob,
                                   on_validacion  out number,
                                   on_codResp     out number,
                                   ov_msjRes      out varchar2);
    function sgafun_evalua_expresion(iv_valor1     in varchar2,
                                   iv_valor2     in varchar2,
                                   in_idexplog   in varchar2) return number;               
     FUNCTION sgafun_split(p_cadena clob, p_separador VARCHAR2, p_pos NUMBER)
    RETURN VARCHAR2;
    
    
end PKG_FLUJO_AUTOMATICO;
/