create or replace package operacion.pq_gestiona_bono is

  -- Author  : C14675
  -- Created : 19/07/2019 04:21:23 PM
  -- Purpose : Gestion de Bono

  P_TIPSRV_G    VTATABSLCFAC.TIPSRV%TYPE := '0061'; -- CAMBIADO
  P_CODCLI_G    VTATABSLCFAC.CODCLI%TYPE;
  P_CODINSSRV_NEW OPERACION.INSPRD.CODINSSRV%TYPE;

  cn_esttarea_cerrada         tareawfchg.esttarea%type := 4;
  cn_tareadef_activacion_serv tareawf.tareadef%type := 299;
  cc_tipsrv_internet  inssrv.tipsrv%type := '0006';

  --Variables constantes para idcomponentes:
  cn_idcomponente_adicinter sgacrm.ft_instdocumento.idcomponente%type := 24;

  procedure SGASI_GENERAR_CO_ID(ac_tip number,
                                ac_codrespuesta out number,
                        av_msgrespuesta out varchar2);

  procedure SGASI_GENERAR_INSBONO(an_co_id  number,
                           an_sncode varchar2,
                           an_customer_id  number,
                           an_estado varchar2,
                           an_seq          number,
                           an_codinsbono out number,
                           an_codrespuesta out number,
                           av_msgrespuesta out varchar2
                                       );

  procedure SGASS_OBTENER_BANWID( an_sncode       varchar2,
                                LN_BANWID   out TYSTABSRV.BANWID%TYPE,
                                an_codrespuesta out number,
                                av_msgrespuesta out varchar2);

 procedure SGASI_IDENTIFICAR_ACCION_BONO(a_idtareawf     number,
                                   a_idwf number,
                                   a_tarea number,
                                   a_tareadef number
                                   );


PROCEDURE SGASI_GENERAR_SOT (  AS_CODINSBONO     ATCCORP.SGAT_INSBONO.CODINSBONO%TYPE,
                               AN_SEQ        ATCCORP.SGAT_CO_ID.ID_SEQ%TYPE,
                               PO_CODERROR       OUT NUMBER,
                               PO_MSJERROR       OUT VARCHAR2);

PROCEDURE SGASI_GENERAR_VTATABPRECON(  S_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                                 S_CODCLI VTATABSLCFAC.CODCLI%TYPE,
                                 PO_CODERROR       OUT NUMBER,
                                 PO_MSJERROR       OUT VARCHAR2);


PROCEDURE SGASI_GENERAR_EF (  S_NUMSLC VTATABSLCFAC.NUMSLC%TYPE,
                              PO_CODERROR       OUT NUMBER,
                              PO_MSJERROR       OUT VARCHAR2);

PROCEDURE SGASU_ASIGNAR_ESTADOS_SERV(A_IDTAREAWF IN NUMBER,
                                     A_IDWF      IN NUMBER,
                                     A_TAREA     IN NUMBER,
                                     A_TAREADEF  IN NUMBER) ;

end pq_gestiona_bono;
/