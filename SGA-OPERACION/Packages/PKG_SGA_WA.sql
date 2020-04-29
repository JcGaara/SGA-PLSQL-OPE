CREATE OR REPLACE PACKAGE OPERACION.PKG_SGA_WA IS
/*******************************************************************************************************
  NOMBRE:       OPERACION.PKG_SGA_WA
  PROPOSITO:    Paquete de objetos
  REVISIONES:
  Version    Fecha       Autor            Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    -----------------------------------------
   1.0       11/10/2017  Servicio Fallas-HITSS      INC000000892040
/*******************************************************************************************************/
 procedure P_ANULA_SOTS_RECHAZADAS;

 procedure P_ANULA_SOTS_APROBADAS;

 procedure P_ANULA_CONTRATO_BSCS(an_cod_id    solot.cod_id%type,
                                 an_codsolot  solot.codsolot%type,
                                 an_resultado out number,
                                 av_msg       out varchar2);
 procedure P_BAJA_JANUS_ANU(an_codsolot in number,
                            an_error    out number,
                            av_error    out varchar2);

procedure P_ASIG_BONO_FIJA_FULL_CLARO (MENSAJE OUT VARCHAR2) ;

procedure P_REPO_BONO_FIJA_FULL_CLARO (K_REPORTE_FIJAS OUT SYS_REFCURSOR,
                                 K_COD_RES OUT INTEGER,
                                 K_MENSAJE OUT VARCHAR2);

 Function F_RETORNA_SELECT(p_select in number) return varchar2;

 Function f_validar_estado_contrato(an_co_id number) return number;

 procedure PSGASS_DESACTIVA_BONO  (K_COD_RES OUT INTEGER,
                                   K_MENSAJE OUT VARCHAR2) ;

 PROCEDURE PSGASS_LISTAR_BONOS_ACTDES(K_REPORTE           INTEGER,
                                      K_REPORTE_FIJAS OUT SYS_REFCURSOR,
                                      K_COD_RES       OUT INTEGER,
                                      K_MENSAJE       OUT VARCHAR2);
                                      
PROCEDURE P_REPO_CONTROL (K_REPORTE_CAB OUT SYS_REFCURSOR,
                          K_REPORTE_DET OUT SYS_REFCURSOR,
                          K_COD_RES OUT INTEGER,
                          K_MENSAJE OUT VARCHAR2);
                          
 PROCEDURE PSGASS_SGAT_MESA_CONTROL(PI_F_INI                       IN VARCHAR2,
                                    PI_F_FIN                       IN VARCHAR2,
                                    PO_CURSO_SGAT_MESA_CONTROL    OUT SYS_REFCURSOR,
                                    PO_CURSO_SGAT_MESA_CONTROL_DET OUT SYS_REFCURSOR,
                                    PO_CODERROR                    OUT NUMBER,
                                    PO_MSJERROR                    OUT VARCHAR2);
end PKG_SGA_WA;
/