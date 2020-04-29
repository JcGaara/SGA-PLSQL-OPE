CREATE OR REPLACE PROCEDURE OPERACION.P_CHG_BORNE_TAP(p_codinssrv in number,
                                                      p_tap       in varchar2,
                                                      p_borne     in number) is
begin
  UPDATE INSSRV
     SET BORNE = P_BORNE, TAP = P_TAP
   WHERE CODINSSRV = p_codinssrv;
end;
/


