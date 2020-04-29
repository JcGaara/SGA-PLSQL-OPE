CREATE OR REPLACE PACKAGE OPERACION.PKG_PORTOUT_CORP AS
  /******************************************************************************
     NAME:       SOPFIJA.PKG_SIGCORP
     PURPOSE:
  
    VERSION     FECHA       AUTOR            SOLICITADO POR  DESCRIPCIÓN.
    ---------  ----------  ---------------   --------------  ---------------------------------
      1.0      01/02/2019  CONRAD AGÜERO     MARIO HIDALGO   PORT OUT 
	  1.1      13/03/2019  CONRAD AGÜERO     MARIO HIDALGO   MODIFICACIÓN SP  SGASS_VALIDA_NUMERO
      
  ******************************************************************************/

  PROCEDURE SGASS_VALIDA_NUMERO(PI_NUM    IN VARCHAR2,
                                PO_CODERR OUT NUMBER,
                                PO_MSJERR OUT VARCHAR2);
  FUNCTION SGAFS_CID(PI_NUM IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION SGAFS_OBT_MAIL(PI_RUC IN VARCHAR2, PI_TIP IN INTEGER)
    RETURN VARCHAR2;

  PROCEDURE SGASI_INSERT_LOG(PI_NUM        IN VARCHAR2,
                             PI_CLI        IN VARCHAR2,
                             PI_MAIL_ASESO IN VARCHAR2,
                             PI_MAIL_SUPER IN VARCHAR2,
                             PO_MSJERR     OUT VARCHAR2);

  PROCEDURE SGASS_OBT_ASESO(PO_CURSOR            OUT SYS_REFCURSOR,
                            PO_CODIGO_RESPUESTA  OUT INTEGER,
                            PO_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASS_NO_CARTE(PO_CURSOR               OUT SYS_REFCURSOR,
                           PO_MAIL_CAE             OUT VARCHAR2,
                           PO_MAIL_NO_CARTERIZADOS OUT VARCHAR2,
                           PO_CODIGO_RESPUESTA     OUT INTEGER,
                           PO_MENSAJE_RESPUESTA    OUT VARCHAR2);

  PROCEDURE SGASS_CARTERI(PI_EMAIL_CONSULTOR   IN VARCHAR2,
                          PO_CURSOR            OUT SYS_REFCURSOR,
                          PO_MAIL_CAE          OUT VARCHAR2,
                          PO_CODIGO_RESPUESTA  OUT INTEGER,
                          PO_MENSAJE_RESPUESTA OUT VARCHAR2);

END PKG_PORTOUT_CORP;
/