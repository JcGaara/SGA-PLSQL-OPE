CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHA_UTIL( a_fecha in date, a_dias in number) RETURN date IS
ls_fecha solot.feccom%type;
l_fraccion number;
l_total number;
n_dia number;
l_tmp number; --<1.0>
 /************************************************************
  NOMBRE:     F_GET_FECHA_UTIL
  PROPOSITO: devuelve un dia laborable
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        26/05/2009  Hector Huaman M.
  2.0        06/09/2010  Alexander Yong   REQ-141639: error en la función que calcula los días hábiles
  ***********************************************************/


BEGIN
   --<1.0
     select count(distinct fecini)
       into l_tmp
       from tlftabfer
      where trunc(FECINI) between a_fecha and trunc(sysdate)
        and to_char(FECINI, 'd') not in (1, 7);
   --1.0>
    l_total := trunc(a_dias/5);
  l_fraccion := a_dias - trunc(a_dias/5)*5;
  select a_fecha + l_total*7 + l_fraccion + l_tmp into ls_fecha from dual; --<2.0>
  select to_number(to_char(ls_fecha, 'd')) into n_dia from dual;
  if n_dia = 1 then
    select ls_fecha + 1 into ls_fecha from dual;
  elsif n_dia = 7 then
    select ls_fecha + 2 into ls_fecha from dual;
  end if;

  --<1.0
  --ls_fecha:=(ls_fecha+l_tmp); <2.0>
  --1.0>

  return ls_fecha;
    exception
      when others then
      return null;
END;
/


