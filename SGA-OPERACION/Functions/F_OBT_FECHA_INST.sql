CREATE OR REPLACE FUNCTION OPERACION.f_obt_fecha_inst(a_codinssrv in number,
                                                      a_codcli    in char)
  return date is
  /***************************************************************************************
    NOMBRE:     operacion.f_obt_fecha_inst
    PROPOSITO:
    PROGRAMADO EN JOB:  NO

    REVISIONES:
    Version      Fecha        Autor             Solicitado por          Descripción
    ---------  ----------  ---------------   --------------------    ------------------------
    1.0        29/09/2010  Edson Caqui       Cesar Rosciano          Req. 143408
  **************************************************************************************/
  l_fecha date;

begin
  begin
    select sp.fecinisrv
      into l_fecha
      from inssrv i, solotpto sp
     where i.codinssrv = a_codinssrv
       and i.codcli = a_codcli
       and i.codinssrv = sp.codinssrv
       and sp.fecinisrv is not null
       and sp.efpto = 1
       and sp.pid_old is null
       and rownum = 1;
    return l_fecha;
  exception
    when no_data_found then
      l_fecha := '';
      return l_fecha;
  end;
exception
  when others then
    null;
end;
/


