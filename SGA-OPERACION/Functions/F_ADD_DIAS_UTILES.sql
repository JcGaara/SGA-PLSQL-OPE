CREATE OR REPLACE FUNCTION OPERACION.F_ADD_DIAS_UTILES (
   a_fecha in date,
   a_dias  in number
) return date IS
/******************************************************************************
Calcula una nueva fecha
Fecha + dias utiles
Utiliza la tabla de feriados de Billing
******************************************************************************/
l_cont number;
l_ini date;
l_new date;
l_tmp number;
BEGIN
   l_ini := trunc(a_fecha);
   l_new := trunc(a_fecha);
   l_cont := 0;

   if a_dias is null then
     return l_new;
   end if;

   loop
      exit when l_cont >= a_dias;
      l_new := l_new + 1;
      if to_char(l_new,'d') in ('1', '7') then
         null;
         --l_new := l_new + 1;
      else
         select count(*) into l_tmp from tlftabfer
            where trunc(FECINI) = l_new;
         if l_tmp > 0 then -- Es feriado
            null;--l_new := l_new + 1;
         else
            --l_new := l_new + 1;
            l_cont := l_cont + 1;
         end if;
      end if;

   end loop;

   return l_new;
END;
/


