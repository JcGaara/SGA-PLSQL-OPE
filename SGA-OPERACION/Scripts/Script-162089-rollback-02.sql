begin
  declare
    ln_contador number;
  
    cursor c_sga_intraway is
      select a.codcli,
             a.idproducto,
             a.macaddress_sga,
             a.macaddress_intraway,
             trunc(a.fecreg)
        from historico.actmacaddresspc_log a
       where trunc(a.fecreg) = sysdate
         and a.macaddress_sga <> a.macaddress_intraway;
  
  begin
    ln_contador := 0;
    for c1 in c_sga_intraway loop
      ln_contador := ln_contador + 1;
    
      --actualizamos la macaddress del sga con la macaddress de intraway
      update intraway.int_servicio_intraway i
         set i.macaddress = c1.macaddress_sga
       where i.id_cliente = c1.codcli
         and i.id_producto = c1.idproducto;
    
      --insertamos las actualizaciones en la tabla actmacaddresspc_log    
      insert into historico.actmacaddresspc_log
        (codcli, idproducto, macaddress_intraway, macaddress_sga)
      values
        (c1.codcli,
         c1.idproducto,
         c1.macaddress_intraway,
         c1.macaddress_sga);
    
      if mod(ln_contador, 1000) = 0 then
        commit;
      end if;
    end loop;
    commit;
  end;
end;
