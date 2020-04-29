CREATE OR REPLACE PACKAGE OPERACION.PQ_CONSULTA_SIAC_PRE is
  /*****************************************************************************
       NOMBRE:       PQ_REPLICA_SIAC_PRE
       PROPOSITO:
       REVISIONES:

       Ver        Fecha        Autor            Descripcion
       ---------  ----------  ---------------  ------------------------------------

        1.0       04/10/2011  José Ramos       Paquete que contiene los procedimientos que utiliza el SIAC PREPAGO
                                               para consultar datos del SGA.
  ******************************************************************************/


  TYPE CUR_SGAT IS REF CURSOR;

  PROCEDURE P_DATOS_CLIENTE(P_CODRECARGA IN VARCHAR,
                            C_CUR_DATOS  OUT CUR_SGAT,
                            P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_INCIDENCIA(P_CODRECARGA IN VARCHAR,
                               C_CUR_DATOS  OUT CUR_SGAT,
                               P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_INCIDENCIA_FECHAS(P_CODRECARGA IN VARCHAR,
                                      C_CUR_DATOS  OUT CUR_SGAT,
                                      P_FECINI     IN VARCHAR,
                                      P_FECFIN     IN VARCHAR,
                                      P_ERROR      OUT VARCHAR);

  PROCEDURE P_SEGUIMIENTO_INCIDENCIA(P_CODINCIDENCE IN VARCHAR,
                                     C_CUR_DATOS    OUT CUR_SGAT,
                                     P_ERROR        OUT VARCHAR);

  PROCEDURE P_DATOS_ULTIMO_SERVICIO(P_CODRECARGA IN VARCHAR,
                                    C_CUR_DATOS  OUT CUR_SGAT,
                                    P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_SERVICIOS(P_CODRECARGA IN VARCHAR,
                              C_CUR_DATOS  OUT CUR_SGAT,
                              P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_SOLICITUD(P_CODRECARGA IN VARCHAR,
                              C_CUR_DATOS  OUT CUR_SGAT,
                              P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_SOLICITUD_FECHAS(P_CODRECARGA IN VARCHAR,
                                     P_FECINI     IN VARCHAR,
                                     P_FECFIN     IN VARCHAR,
                                     C_CUR_DATOS  OUT CUR_SGAT,
                                     P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_RECARGAS(P_CODRECARGA IN VARCHAR,
                             C_CUR_DATOS  OUT CUR_SGAT,
                             P_ERROR      OUT VARCHAR);

  PROCEDURE P_DATOS_RECARGAS_FECHAS(P_CODRECARGA IN VARCHAR,
                                    P_FECINI     IN VARCHAR,
                                    P_FECFIN     IN VARCHAR,
                                    C_CUR_DATOS  OUT CUR_SGAT,
                                    P_ERROR      OUT VARCHAR);

end PQ_CONSULTA_SIAC_PRE;
/


