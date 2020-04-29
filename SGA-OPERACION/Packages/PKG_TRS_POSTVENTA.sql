CREATE OR REPLACE PACKAGE OPERACION.PKG_TRS_POSTVENTA IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_TRS_POSTVENTA
  PROPOSITO:  Ejecución de las transacciones Postventa
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      23/01/2020  Felipe Maguiña       Dante Sunohara      INICIATIVA-193 Reingeniería de Venta y PostVenta Fija   
  /************************************************************************************************/

  FUNCTION SGAFUN_GET_SERVICES(P_IDPROCESS NUMBER) RETURN OPERACION.PQ_SIAC_CAMBIO_PLAN.SERVICES_TYPE;
  PROCEDURE SGASS_VALIDACION_INICIAL_CP(P_IDPROCESS NUMBER,
                                        P_ERROR     OUT NUMBER,
                                        P_MENSAJE   OUT VARCHAR2);

  PROCEDURE SGASS_GENERA_VENTA_MENOR(P_IDPROCESS NUMBER,
                                     P_ERROR     OUT NUMBER,
                                     P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_GENERA_VENTA_MENOR_DET(P_IDPROCESS NUMBER,
                                         P_ERROR     OUT NUMBER,
                                         P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_GENERA_VENTA(P_IDPROCESS NUMBER,
                               P_ERROR     OUT NUMBER,
                               P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_GENERA_VENTA_DET(P_IDPROCESS NUMBER,
                                   P_ERROR     OUT NUMBER,
                                   P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_ACT_NUMSLC(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_REG_PIDBAJA(P_IDPROCESS NUMBER,
                              P_ERROR     OUT NUMBER,
                              P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_LOAD_INSTANCIA_CAMBIO(P_IDPROCESS NUMBER,
                                        P_ERROR     OUT NUMBER,
                                        P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_REG_PRECON(P_IDPROCESS NUMBER,
                             P_ERROR     OUT NUMBER,
                             P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_VALIDAR_TIPOSOL(P_IDPROCESS NUMBER,
                                  P_ERROR     OUT NUMBER,
                                  P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_VALIDAR_PROYECTO(P_IDPROCESS NUMBER,
                                   P_ERROR     OUT NUMBER,
                                   P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SGASS_PROYECTO_PREVENTA(P_IDPROCESS NUMBER,
                                    P_ERROR     OUT NUMBER,
                                    P_MENSAJE   OUT VARCHAR2);
  FUNCTION SGAFUN_GET_PRECON(P_IDPROCESS NUMBER) RETURN OPERACION.PQ_SIAC_CAMBIO_PLAN.PRECON_TYPE;
END;
/