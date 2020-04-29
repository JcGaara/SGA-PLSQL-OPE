CREATE OR REPLACE PACKAGE OPERACION.PKG_VALIDA_INCOGNITO_IMS IS
  /****************************************************************************************
   NOMBRE:      OPERACION.PKG_VALIDA_INCOGNITO_IMS
   PROPOSITO:   AUTOMATIZACION

     Ver        Fecha        Autor             Solicitado por    Descripcion
   ---------  ----------  ----------------  ----------------  ------------------------
   1.0        24/09/2018    Hitss
  *****************************************************************************************/

  PROCEDURE SP_INGRESA_DATA_TEMP (ln_error out number,
                                  lv_error out varchar2);


  PROCEDURE SP_NO_MAC_INCOGNITO(av_salida out sys_refcursor,
                                an_error  OUT NUMBER,
                                av_error  OUT VARCHAR2);



  PROCEDURE SP_NO_LINEA_INCOGNITO(av_salida out sys_refcursor,
                                  an_error  OUT NUMBER,
                                  av_error  OUT VARCHAR2);


 END PKG_VALIDA_INCOGNITO_IMS;

/
