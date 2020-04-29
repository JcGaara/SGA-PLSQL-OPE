CREATE OR REPLACE PROCEDURE OPERACION.OPESI_CARGA_LOG_DESPACHO (
KCODSOLOT  NUMBER,
KTRAMAWEB  CLOB,
KTRAMARESP XMLTYPE,
KMENSERROR VARCHAR2)

IS
/******************************************************************************
NOMBRE:       OPESI_CARGA_LOG_DESPACHO
DESCRIPCION:  CARGA TABLA LOG PARA EL DESPACHO AUTOMATICO
 REVISIONS:
   Ver        Date        Author            Solicitado por   Description
   ---------  ----------  ---------------   --------------  ------------------------------------
   1.0        03/10/2013  Miriam Mandujano  Jose Velarde    Adicionar procesos para invocar al webservice de Despacho (SAP)
******************************************************************************/

BEGIN

    insert into HISTORICO.OPET_DESPACHO_LOG
    (DESPN_CODSOLOT,DESPV_TRAMAWEB,DESPV_TRAMARESP,DESPV_MENSERROR)
    values
    (KCODSOLOT,KTRAMAWEB,KTRAMARESP,KMENSERROR) ;


commit;
END;
/
