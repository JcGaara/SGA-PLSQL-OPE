CREATE OR REPLACE PROCEDURE OPERACION.P_RECONEXION_TELMEXTV(an_tipo in integer,
                                                            as_idfac in string,
                                                            as_codcli in string,
                                                            as_nomabr in string) is
  /****************************************************************************************
       NAME:       OPERACION.P_RECONEXION_TELMEXTV
       PURPOSE:    Envio al flujo automático de reconexiones para servicios de Telmex TV
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------
        1.0       24/04/2009  Edson Caqui      Creación. Req. 92633.
  ****************************************************************************************/

begin

  if an_tipo = 1 then
     OPERACION.PQ_CORTESERVICIO_CABLE.p_genera_transaccion_RECCLC(as_idfac,as_codcli,as_nomabr);
  end if;

  if an_tipo in (2,3) then
     OPERACION.PQ_CORTESERVICIO_CABLE.p_genera_transaccion_REC_CABLE(as_idfac,as_codcli,as_nomabr);
  end if;

end P_RECONEXION_TELMEXTV;
/


