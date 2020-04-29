create or replace procedure operacion.sp_procesa_sot_anula_adm(av_sot_anula operacion.solot.codsolot%type,
                                                               an_error     out number,
                                                               av_error     out varchar2) is
  cn_estsolot number(8);
begin

  SELECT S.ESTSOL
    INTO CN_ESTSOLOT
    FROM SOLOT S
   WHERE S.CODSOLOT = av_sot_anula;
  operacion.pq_solot.p_chg_estado_solot(av_sot_anula,
                                        13,
                                        CN_ESTSOLOT,
                                        'Anulación de Sot Automatica Duplicidad Migración');
  an_error := 1;
  av_error := 'OK';
exception
  when others then    
    an_error := sqlcode;
    av_error := sqlerrm;
    rollback;
end;
/
