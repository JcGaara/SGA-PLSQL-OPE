create or replace package body operacion.PKG_SISACT is
  /************************************************************
  NOMBRE:     PKG_SISACT
  PROPOSITO:  Envio de activacion al SISACT

  REVISIONES:
   Ver        Fecha        Autor           Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    ----------
  1.0        30/08/2012  Hector Huaman                       PROY-3940:Mejoras en Proceso de Venta DTH Postpago 
  2.0        01/09/2014  Angel Condori    Manuel Gallegos    PROY-12688:Ventas Convergentes                  
  *************************************************************/
PROCEDURE SISACT_INSERT_ACTIVA_DTH
          (p_idtransaccion   IN  VARCHAR2,
          p_ipaplicacion     IN  VARCHAR2,
          p_aplicacion       IN  VARCHAR2,
          p_contrato         IN  INTEGER,
          p_servicio         IN  VARCHAR2,
          p_usuario          IN  VARCHAR2,
          p_rpta             OUT VARCHAR2)
IS
BEGIN

p_rpta := SALES.PQ_DTH_POSTVENTA.f_activarDTH_vc(p_idtransaccion, --2.0
                                                    p_ipaplicacion,
                                                    p_aplicacion,
                                                    p_contrato,
                                                 -- p_servicio, -- 2.0
                                                    p_usuario);
          
END SISACT_INSERT_ACTIVA_DTH;


PROCEDURE P_VALIDA_ARCHIVOSOT
(P_NRO_CONTRATO IN VARCHAR2, 
P_EXISTE        OUT NUMBER) 
is
begin
  select count('x') 
  INTO P_EXISTE
  from sales.int_vtacliente_aux a,
     sales.INT_LOTE_CAB b
  where a.idlote=b.idlote and 
      b.identidad=3 and
      substr(b.nomarchivo, 15) = P_NRO_CONTRATO;
      
end P_VALIDA_ARCHIVOSOT;

-- Ini 2.0
procedure p_informar_cierre (p_nrosec   in number,
                             p_cod_resp out integer,
                             p_msg_resp out varchar2)
is
begin
  PVU.SISACT_PKG_SGA.SP_INFORMAR_CIERRE@DBL_PVUDB(p_nrosec,p_cod_resp,p_msg_resp);
  commit;
end;
-- Fin 2.0
            
end PKG_SISACT;
/
