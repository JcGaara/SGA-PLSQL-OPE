CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHAS_CORTE RETURN number IS
  -- Devuelve:
  -- 1 si en la fecha actual se puede hacer corte.
  -- 0 si en la fecha actual no se puede hacer corte.
  /*****************************************************************************************************************
  Fecha        Responsable       Descripción
  ----------  ----------------  ------------------------------------------------------------------------------------
  20/11/2009   Joseph Asencios   REQ-107653: Función que determina si en la fecha actual se puede o no hacer corte.
  ******************************************************************************************************************/
l_dia number;
l_tmp number;
l_dia_corte number;
l_flg_corte number;

begin
  select to_number(to_char(sysdate,'d'))
  into l_dia
  from dual;

  select count(1)
  into l_tmp
  from tlftabfer
  where ((trunc(FECINI) = trunc(sysdate)) or (trunc(FECINI) = trunc(sysdate)+1));

  select count(1)
  into l_dia_corte
  from opedd
  where tipopedd = 250
  and codigon=l_dia;

  if ( l_dia_corte > 0 and l_tmp = 0) then
   l_flg_corte:=1;
  else
   l_flg_corte:=0;
  end if;
return l_flg_corte;
end;
/


