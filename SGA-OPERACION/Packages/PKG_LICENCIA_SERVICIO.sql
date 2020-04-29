CREATE OR REPLACE PACKAGE OPERACION.PKG_LICENCIA_SERVICIO IS

  PROCEDURE SGASS_VALIDA_LIC_CAB(AV_NUMSLC SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 AN_ERROR  OUT NUMBER,
                                 AV_ERROR  OUT VARCHAR2);
                                 
  PROCEDURE SGASS_CONSULTA_FILTROS(
      AC_LCABC_NUMSLC    OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_NUMSLC%TYPE, 
      AC_LCABC_CODCLI    OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_CODCLI%TYPE,
      AN_SERLN_CID       OPERACION.SGAT_CID_SERV_LICENCIA.SERLN_CID%TYPE, 
      AI_LICDI_CODPROV   OPERACION.SGAT_PROCESO_LIC_DET.LICDI_CODPROV%TYPE, 
      AI_LICSI_TIPO      OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_TIPO%TYPE,  
      AD_LICSD_FECINICIO OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECINICIO%TYPE,  
      AD_LICSD_FECFIN    OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECFIN%TYPE,  
      AC_CUR_LICSER      OUT SYS_REFCURSOR);
  
  PROCEDURE SGASS_OBTENER_FECHAS(ADT_FECHA_INI OUT DATE,
                                 ADT_FECHA_FIN OUT DATE);
                                 
  PROCEDURE SGASS_VALIDA_SOT (AN_SOLOT  OPERACION.SOLOT.CODSOLOT%TYPE,
                              AN_CID    OPERACION.SOLOTPTO.CID%TYPE,
                              AN_ERROR  OUT NUMBER,
                              AV_ERROR  OUT VARCHAR2);
  
  PROCEDURE SGASS_VALIDA_CID_SOT (AV_NUMSLC OPERACION.SOLOT.NUMSLC%TYPE,
                                   AN_CID    OPERACION.SOLOTPTO.CID%TYPE,
                                   AN_SOLOT  OPERACION.SOLOT.CODSOLOT%TYPE,
                                   AN_ERROR  OUT NUMBER,
                                   AV_ERROR  OUT VARCHAR2);
                                   
  PROCEDURE SGASS_CONSULTA_PROY(AV_NUMSLC                 OPERACION.SOLOT.NUMSLC%TYPE,
                                AV_CODCLI             OUT OPERACION.SOLOT.CODCLI%TYPE,
                                AV_NOMCLI             OUT MARKETING.VTATABCLI.NOMCLI%TYPE,
                                AV_PROCESO_CONTRATO   OUT VARCHAR2,
                                AV_FLAG_LICITACION    OUT VARCHAR2,
                                AV_GESTOR             OUT VARCHAR2,
                                AV_ASESOR             OUT VARCHAR2);
                                
  PROCEDURE SGASS_VALIDA_CID (AV_NUMSLC SALES.VTATABSLCFAC.NUMSLC%TYPE,
                              AN_CID    OPERACION.INSSRV.CID%TYPE,
                              AN_ERROR  OUT NUMBER,
                              AV_ERROR  OUT VARCHAR2);
                              
  PROCEDURE SGASS_OBTIENE_FECFIN (ADT_FECHA_INI     DATE,
                                  AN_PERIODO        NUMBER,
                                  ADT_FECHA_FIN OUT DATE,
                                  AN_ERROR      OUT NUMBER,
                                  AV_ERROR      OUT VARCHAR2);
  
  PROCEDURE SGASS_OBTIENE_UBICACION (AV_NUMSLC       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                     AN_CID           OPERACION.INSSRV.CID%TYPE,
                                     AV_CODEST     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODEST%TYPE,
                                     AV_CODPVC     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODPVC%TYPE,
                                     AV_CODUBI     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODDST%TYPE,
                                     AV_DIRECCION  OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDV_DIRECCION%TYPE,
                                     AN_ERROR      OUT NUMBER,
                                     AV_ERROR      OUT VARCHAR2);
                                     
  PROCEDURE SGASS_OBTIENE_PROV (AN_CODCON        OPERACION.CONTRATA.CODCON%TYPE,
                                AV_PROVEEDOR OUT OPERACION.CONTRATA.NOMBRE%TYPE,
                                AN_ERROR     OUT NUMBER,
                                AV_ERROR     OUT VARCHAR2);

  PROCEDURE SGASP_GRABAR_TRAZA_LICITACION(AV_NRO_LICITACION     BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_NRO_LICITACION%TYPE,
                                          AC_CODCLI             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISC_CODCLI%TYPE,
                                          AV_DETALLE_CAMBIO_OLD BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_DETALLE_CAMBIO_OLD%TYPE,
                                          AC_NUMSLC             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISC_NUMSLC%TYPE,
                                          AV_TIPO_REGISTRO      BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_TIPO_REGISTRO%TYPE,
                                          AV_CONCEPTO_CAMBIO    BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_CONCEPTO_CAMBIO%TYPE,
                                          AV_DETALLE_CAMBIO_NEW BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_DETALLE_CAMBIO_NEW%TYPE,
                                          AD_FECUSU             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISD_FECUSU%TYPE,
                                          AV_CODUSU             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_CODUSU%TYPE,
                                          AN_ERROR              OUT NUMBER,
                                          AV_ERROR              OUT VARCHAR2);                                    

  PROCEDURE SGASS_OBTIENE_FORMATO_CORREO(AN_TIPOMSJ    IN NUMBER,
                                         AC_CUR_FORCOR OUT SYS_REFCURSOR,
                                         AN_ERROR      OUT NUMBER,
                                         AV_ERROR      OUT VARCHAR2);   
                                        
  PROCEDURE SGASS_OBTIENE_CORREOS_CLIENTE(AC_CODCLI     IN MARKETING.VTATABCLI.CODCLI%TYPE,
                                          AV_EMAIL      OUT VARCHAR2,                                                                                               
                                          AN_ERROR      OUT NUMBER,
                                          AV_ERROR      OUT VARCHAR2);
                                          
  PROCEDURE SGASS_OBTIENE_CORREOS_LICENCIA(AI_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,
                                           AV_Cc    OUT VARCHAR2,                                                      
                                           AN_ERROR OUT NUMBER,
                                           AV_ERROR OUT VARCHAR2);                                        
                                          
  PROCEDURE SGASP_VALIDA_VEN_LIC_SOP(AN_TOTAL OUT NUMBER,
                                     AN_ERROR OUT NUMBER,
                                     AV_ERROR OUT VARCHAR2); 
                                     
  PROCEDURE SGASS_OBTENER_NOTIFICACIONES(AC_CUR_NOTIF OUT SYS_REFCURSOR,
                                         AN_ERROR      OUT NUMBER,
                                         AV_ERROR      OUT VARCHAR2); 
                                         
  PROCEDURE SGASP_GRABAR_NOTIFICACION_LOG(AN_CLINN_ID OPERACION.SGAT_NOTIFICACION_CLIENTE.CLINN_ID%TYPE,
                                          AN_CLINI_ID_LIC OPERACION.SGAT_NOTIFICACION_CLIENTE.CLINI_ID_LIC%TYPE,                                                        
                                          AN_ERROR      OUT NUMBER,
                                          AV_ERROR      OUT VARCHAR2);                                                                                                                                                                                    
                                          
  PROCEDURE SGASS_OBTENER_NOTIFICACION_CAB(AV_LCABC_NUMSLC OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_NUMSLC%TYPE,                                                          
                                           AN_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,                                                        
                                           AC_CUR_NOTCAB OUT SYS_REFCURSOR,                                                     
                                           AN_ERROR OUT NUMBER,
                                           AV_ERROR OUT VARCHAR2);                                         
                                           
  PROCEDURE SGASS_OBTENER_NOTIFICACION_DET(AN_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,
                                          AC_CUR_NOTDET OUT SYS_REFCURSOR,                                                     
                                          AN_ERROR OUT NUMBER,
                                          AV_ERROR OUT VARCHAR2);  
                                          
  FUNCTION SGAFUN_OBTIENE_TXT_PER_RENOV RETURN VARCHAR2;                                                                                                                                                                              
END;
/