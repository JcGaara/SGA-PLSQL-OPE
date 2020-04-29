create or replace package OPERACION.PKG_ALINEA_BSCS_IMS_UDB_LTE is
  /****************************************************************************************
   NOMBRE:       OPERACION.PKG_ALINEA_BSCS_IMS_UDB_LTE
   PROPOSITO:    solucion a desalineaciones BSCS-IMS-UDB para líneas LTE

     Ver        Fecha        Autor             Solicitado por    Descripcion
   ---------  ----------  ----------------  ----------------  ------------------------
   1.0        20/03/2018  Hitss             INC000001085123
  *****************************************************************************************/

  PROCEDURE SP_GENERA_DATA(lv_fecha in VARCHAR2,
                           ln_error out number,
                           lv_error out VARCHAR2);
  PROCEDURE SP_DELETE;

  PROCEDURE SP_LLENAR_PCRF(av_fecha in VARCHAR2,
                           an_error out number,
                           av_error out VARCHAR2);

  PROCEDURE SP_INTERGRATIS(an_error OUT NUMBER, av_error OUT VARCHAR2);

  PROCEDURE SP_LINEA_NOUDB(av_fecha in VARCHAR2,
                           an_error out number,
                           av_error out VARCHAR2);

  PROCEDURE SP_HFC_NOIMS(av_fecha in VARCHAR2,
                         an_error out number,
                         av_error out VARCHAR2);

  PROCEDURE SP_BSCS_DISCT_PCRF(av_fecha in VARCHAR2,
                               an_error out number,
                               av_error out VARCHAR2);

  PROCEDURE SP_REP_CICLO_FACTU_BSCS_DISTIN(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2);

  PROCEDURE SP_REP_ANTIG_CLIENT_LTE_INTERN(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2);

  PROCEDURE SP_REP_CLIENT_FACTU_NO_UDB(av_salida out sys_refcursor,
                                       an_error  OUT NUMBER,
                                       av_error  OUT VARCHAR2);

  PROCEDURE SP_REP_CLIENT_FACTU_NO_IMS_HFC(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2);

  PROCEDURE SP_REP_CLIENT_FACTU_NO_IMS_LTE(av_salida out sys_refcursor,
                                           an_error  OUT NUMBER,
                                           av_error  OUT VARCHAR2);
                                           
  PROCEDURE SP_RES_LINEA_NO_INS_ENIMS (  av_salida OUT sys_refcursor,
                                              an_error  OUT NUMBER,
                                              av_error  OUT VARCHAR2); 
                                              
  PROCEDURE SP_RES_LINEA_NO_UDB (  av_salida OUT sys_refcursor,
                                              an_error  OUT NUMBER,
                                              av_error  OUT VARCHAR2); 
                                              
  PROCEDURE SP_RES_BSCS_PCRF (  av_salida OUT sys_refcursor,
                                              an_error  OUT NUMBER,
                                              av_error  OUT VARCHAR2); 
                                              
  PROCEDURE SP_RES_INT_GRATIS (  av_salida OUT sys_refcursor,
                                              an_error  OUT NUMBER,
                                              av_error  OUT VARCHAR2); 
                                              
  PROCEDURE SP_REP_VAL_INCOGNITO(av_salida OUT sys_refcursor,
                                 an_error out number,
                                 av_error out varchar2);     

     
end PKG_ALINEA_BSCS_IMS_UDB_LTE;
/