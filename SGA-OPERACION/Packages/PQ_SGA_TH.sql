CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_TH IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_SGA_TH
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       26/02/2016  Carlos Terán G.  Karen Velezmoro   SD-SGA-652670
     2.0       21/03/2016  Carlos Terán G.  Karen Velezmoro   SD-SGA-652670_1
     4.0       09/07/2017
  *******************************************************************************************************/
  cn_estcerrado      constant number := 4; --4.0
  cn_estnointerviene constant number := 8; --4.0

  TYPE typ_reg_transaccion_sga IS TABLE OF operacion.reg_transaccion_sga%ROWTYPE INDEX BY PLS_INTEGER; --2.0

  TYPE typ_LOG_ERROR_TRANSACCION_SGA IS TABLE OF historico.LOG_ERROR_TRANSACCION_SGA%ROWTYPE INDEX BY PLS_INTEGER; --2.0

  PROCEDURE p_asgWfBSCSSIAC_ln(an_tiptransacion number default null);

  PROCEDURE p_asgWfBSCSSIAC_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_genSOTBajaOAC_ln;

  PROCEDURE p_genSOTBajaOAC_bl(an_idproceso NUMBER, an_idtarea NUMBER);

  PROCEDURE p_genSOTSuspOAC_ln;
                                
 PROCEDURE p_genSOTSuspOAC_bl(an_idproceso NUMBER,
                             an_idtarea   NUMBER);                                
 
 PROCEDURE p_genSOTRecoOAC_ln; 

 PROCEDURE p_genSOTRecoOAC_bl(an_idproceso NUMBER,
                             an_idtarea   NUMBER);

 PROCEDURE p_alineaJANUS_ln;
                           
 PROCEDURE p_alineaJANUS_bl(an_idproceso NUMBER,
                             an_idtarea   NUMBER);
 
 PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                                av_password  VARCHAR2,
                                av_url       VARCHAR2,
                                av_nsp       VARCHAR2,
                                an_idproceso NUMBER,
                                an_hilos     IN NUMBER); --2.0
                                
 PROCEDURE p_updThcodsolot(an_idproceso NUMBER, an_idtarea NUMBER, an_codsolot NUMBER ); --2.0
             
 PROCEDURE p_updThcustomerId(an_idproceso NUMBER, an_idtarea NUMBER, an_customer_id NUMBER ); --2.0
                                                                                                             
 FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE) RETURN VARCHAR2;
 
 PROCEDURE p_regLogSGA( an_idproceso NUMBER, atyp_reg_transaccion_sga typ_reg_transaccion_sga, atyp_LOG_ERROR_TRANSACCION_SGA typ_LOG_ERROR_TRANSACCION_SGA );  --2.0
 
 PROCEDURE p_sndMail(an_idproceso NUMBER); --2.0
  
END;
/