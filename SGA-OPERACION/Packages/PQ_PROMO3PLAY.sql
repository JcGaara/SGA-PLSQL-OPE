CREATE OR REPLACE PACKAGE OPERACION.PQ_PROMO3PLAY is
/******************************************************************************
   NAME:       operacion.PQ_PROMO3PLAY
   PURPOSE:    Manejo de las promociones a servicios de telefonia e internet
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/08/2008  ALBERTO.RAMOS       Creacion
   2.0        13/05/2009  Hector Huaman M     REQ-96260: Se  modifico el procedimiento F_PROMO3PLAY_SRVPROM para la gestion de  NCOS
******************************************************************************/


  procedure p_asigna_pomo3playcliente(ls_numslc in vtatabslcfac.numslc%type);


  PROCEDURE  P_PROMO3PLAY_INSERTAPRODUCTO(ls_codsolot in solot.codsolot%type,
                                        ls_codcli in solot.codcli%type ,
                                        ls_codsrv in tystabsrv.codsrv%type,
                                        ln_idproducto  in solot.idproducto%type,
                                        ln_pid_sga  in  promoplayxcliente.pid_sga%type,
                                        as_mensaje out varchar2,
                                        al_error out number);

  FUNCTION F_PROMO3PLAY_SRVPROM(ls_codsolot in solot.codsolot%type,
                                ls_codcli in solot.codcli%type ,
                                ls_codsrv in tystabsrv.codsrv%type,
                                ll_proceso  number ) RETURN VARCHAR2;



 PROCEDURE P_ACTUALIZA_PROMOPLAYXCLIENTE(as_mensaje out varchar2,
                                        al_proceso out number);





end;
/


