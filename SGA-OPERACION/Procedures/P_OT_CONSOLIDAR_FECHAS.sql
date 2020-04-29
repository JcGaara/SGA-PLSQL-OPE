CREATE OR REPLACE PROCEDURE OPERACION.P_OT_consolidar_fechas( an_codot in number) IS


ldt_fecini_inf date;
ldt_fecfin_inf date;
ldt_fecini_act date;
ldt_fecfin_act date;

ldt_fecini date;
ldt_fecfin date;

cursor cur_etapas is
select a.punto, a.codeta from otptoeta a where a.codot = an_codot;

BEGIN
   -- Por cada etapa
   for lcur_etapas in cur_etapas loop
      select min(fecini), max(fecfin) into ldt_fecini_inf, ldt_fecfin_inf from otptoetainf b
      where b.codot = an_codot and b.punto = lcur_etapas.punto and b.codeta = lcur_etapas.codeta;

      select min(fecini), max(fecfin) into ldt_fecini_act, ldt_fecfin_act from otptoetaact b
      where b.codot = an_codot and b.punto = lcur_etapas.punto and b.codeta = lcur_etapas.codeta;

      ldt_fecini := nvl(ldt_fecini_inf, ldt_fecini_act) ;
      if ldt_fecini > ldt_fecini_act then
         ldt_fecini := ldt_fecini_act;
      end if;

      ldt_fecfin := nvl(ldt_fecfin_inf, ldt_fecfin_act);
      if ldt_fecfin < ldt_fecfin_act then
         ldt_fecfin := ldt_fecfin_act;
      end if;

      update otptoeta a set a.fecini = nvl(ldt_fecini, a.fecini), a.fecfin = nvl(ldt_fecfin, a.fecfin)
      where a.codot = an_codot and a.punto = lcur_etapas.punto and a.codeta = lcur_etapas.codeta;

   end loop;

   update otpto a set (a.fecini, a.fecfin) =
          (select nvl(min(b.fecini),a.fecini), nvl(max(b.fecfin),a.fecfin) from otptoeta b
           where  a.codot = b.codot and a.punto = b.punto)
   where a.codot = an_codot;


   update ot a set (a.fecini, a.fecfin) =
          (select nvl(min(b.fecini),a.fecini), nvl(max(b.fecfin),a.fecfin) from otpto b
           where  a.codot = b.codot )
   where a.codot = an_codot;


END;
/


