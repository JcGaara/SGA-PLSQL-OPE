create or replace package operacion.PKG_SISACT is
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
          p_rpta             OUT VARCHAR2);
          
PROCEDURE P_VALIDA_ARCHIVOSOT
          (P_NRO_CONTRATO IN VARCHAR2, 
          P_EXISTE        OUT NUMBER);          

-- Ini 2.0
procedure p_informar_cierre (p_nrosec   in number,
                             p_cod_resp out integer,
                             p_msg_resp out varchar2);
-- Fin 2.0

end PKG_SISACT;
/
