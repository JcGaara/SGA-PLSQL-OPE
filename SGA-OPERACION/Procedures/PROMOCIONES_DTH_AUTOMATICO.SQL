create or replace procedure operacion.PROMOCIONES_DTH_AUTOMATICO IS
/*Proceso de alineacion promociones*/
  v_fecha_inicio_vigencia date;
  v_idpromocion           number;
  v_dias_vigencia_bouquet number;
  v_control number;
  cursor x is
    select a.*
      from v_fac_aplicacion_promocion_rep a
     where a.idcupon in
           (select idcupon from cuponpago_dth where trunc(feccargo) > trunc(sysdate)-2);
begin
  for c in x loop
    begin

    select count(*)
      into v_control
      from OPERACION.BOUQUETXREGINSDTH_LOG
     where idcupon = c.idcupon;

if (v_control=0) then

    insert into OPERACION.BOUQUETXREGINSDTH_LOG
      select distinct a.idcupon,
                      a.numregistro,
                      a.estado,
                      a.fecha_inicio_vigencia,
                      a.fecha_fin_vigencia,null,null,null
        from bouquetxreginsdth a
       where a.tipo = 2
         and a.numregistro = c.numregistro
         and a.idcupon = c.idcupon;
commit;
end if;

    select fecha_inicio_vigencia
      into v_fecha_inicio_vigencia
      from OPERACION.BOUQUETXREGINSDTH_LOG
     where numregistro = c.numregistro and idcupon=c.idcupon and rownum=1;

    if (v_fecha_inicio_vigencia = c.feccargo) then

      update OPERACION.BOUQUETXREGINSDTH_LOG
         set valor = 'OK', flag=0
       where numregistro = c.numregistro;
	   commit;
    else
      select r.idpromocion, r.dias_vigencia_bouquet
        into v_idpromocion, v_dias_vigencia_bouquet
        from fac_promocion_en_linea_mae r
       where r.idpromocion = c.idpromocion;

      update bouquetxreginsdth
         set estado                = 1,
             fecha_inicio_vigencia = c.feccargo,
             fecha_fin_vigencia    = c.feccargo + v_dias_vigencia_bouquet
       where tipo = 2
         and numregistro = c.numregistro
         and idcupon = c.idcupon;

      update OPERACION.BOUQUETXREGINSDTH_LOG
         set valor = 'REGULARIZADO'
       where numregistro = c.numregistro;
      commit;
    end if;
    exception
      when  others then
        dbms_output.put_line(c.numregistro);
 end;
  end loop;

end PROMOCIONES_DTH_AUTOMATICO;
/
