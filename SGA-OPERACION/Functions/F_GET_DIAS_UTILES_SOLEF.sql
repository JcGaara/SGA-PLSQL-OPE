CREATE OR REPLACE FUNCTION OPERACION.f_get_dias_utiles_solef(a_codef number,a_codarea number)
return varchar is
ln_cantidad        number(5);
ls_dias_utiles     varchar2(50);
ls_horas_utiles    varchar2(50);
ls_tiempo_efectivo varchar2(100);
ln_DiasEfectivos1  number;
ln_DiasEfectivos2  number;
ln_DiasEfectivos3  number;
ln_DiasEfectivos4  number;
ln_DiasEfectivos5  number;
ln_HorasEfectivas1 number;
ln_HorasEfectivas2 number;
ln_HorasEfectivas3 number;
ln_HorasEfectivas4 number;
ln_HorasEfectivas5 number;

begin

--Cálculo de dias y horas efectivas
select sum(floor(dias)) , sum(ceil((dias-floor(dias))*24)) into ln_DiasEfectivos1, ln_HorasEfectivas1
from operacion.estsolef_dias_utiles
where codef = a_codef and
      codarea = a_codarea and
      fechafin is not null and
      flg_valido = 1;

select sum(floor(sysdate - fechaini)) ,
sum(ceil(((sysdate - fechaini)-floor(sysdate - fechaini))*24)) into ln_DiasEfectivos2, ln_HorasEfectivas2
from operacion.estsolef_dias_utiles
where codef = a_codef and
      codarea = a_codarea and
      fechafin is null and
      flg_valido = 1;

ln_DiasEfectivos3 :=  nvl(ln_DiasEfectivos1,0) + nvl(ln_DiasEfectivos2,0);

ln_HorasEfectivas3 := nvl(ln_HorasEfectivas1,0) + nvl(ln_HorasEfectivas2,0);

select trunc(ln_HorasEfectivas3/24) , mod(ln_HorasEfectivas3,24) into ln_DiasEfectivos4,ln_HorasEfectivas4
from dual;

ln_DiasEfectivos5 := ln_DiasEfectivos3 + ln_DiasEfectivos4;

ln_HorasEfectivas5 := ln_HorasEfectivas4;

select count(*) into ln_cantidad from operacion.estsolef_dias_utiles
where codef = a_codef and codarea = a_codarea and
      flg_valido = 1;

if ln_cantidad > 0 then
   if ln_DiasEfectivos5 = 0 or ln_DiasEfectivos5 > 1 then
      ls_dias_utiles := ln_DiasEfectivos5 || ' días ';
   else
      ls_dias_utiles := ln_DiasEfectivos5 || ' día ';
   end if;

   if ln_HorasEfectivas5 = 0 or ln_HorasEfectivas5 > 1 then
      ls_horas_utiles := ln_HorasEfectivas5 || ' horas ';
   else
      ls_horas_utiles := ln_HorasEfectivas5 || ' hora ';
   end if;
   ls_tiempo_efectivo := ls_dias_utiles || ' ' || ls_horas_utiles;
else
   ls_tiempo_efectivo := '' ;
end if;

return ls_tiempo_efectivo;
end ;
/


