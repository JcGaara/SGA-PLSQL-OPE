CREATE OR REPLACE FUNCTION OPERACION.F_ADD_DIAS_UTILES_SOT(
   a_fecha_ap in date,
   a_fecha_hoy  in date,
   a_fecha_link in date default null
) return number IS

/******************************************************************************
    NOMBRE:       		F_ADD_DIAS_UTILES_SOT
   	PROPOSITO:    		Calcula el numero de dias utiles cuando se le da la
						fecha de aprobacion y la fecha de hoy.
						Utiliza la tabla de feriados de Billing
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
  	 1.0        20/09/2004  Carmen Quilca
     2.0        29/11/2004  Victor Valqui   Se le agrego un parametro: a_fecha_link
******************************************************************************/

l_dias number;
l_apr date;
l_hoy date;
l_tmp number;
BEGIN
  if a_fecha_ap is null then
  return null;
  end if;
	if a_fecha_link is null then
	   l_hoy := trunc(a_fecha_hoy);
	else
	   l_hoy := trunc(a_fecha_link);
	end if;
   	l_apr := trunc(a_fecha_ap);
   	l_dias := 0;
   	loop
   	  exit when l_apr >= l_hoy;
	     l_apr := l_apr + 1;
      if to_char(l_apr,'d') in ('1', '7') then
         null;
      else
         select count(*) into l_tmp from tlftabfer
            where trunc(FECINI) = l_apr;
         if l_tmp > 0 then -- Es feriado
            null;
         else
            l_dias := l_dias + 1;
         end if;
      end if;
    end loop;

   return l_dias;
END;
/


