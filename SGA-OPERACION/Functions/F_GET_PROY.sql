create or replace function      operacion.f_get_proy( a_proy sales.vtatabslcfac.numslc%type, 
                                                  a_orden number)
  return sales.vtatabslcfac.numslc%type is
    v_proy_ori  sales.vtatabslcfac.numslc%type;
    v_cnt_vm    number;
    v_cnt_cp    number;
  begin
    if a_orden = 1 then
      -- Consulta si la venta fue Realizada a travez de venta Menor
      select count(*)
        into v_cnt_vm
        from sales.regvtamentab a
       where a.numslc = a_proy;
  
      if v_cnt_vm > 0 then
        -- validamos si venta fue realizada por Cambio de Plan
        select count(*)
          into v_cnt_cp
          from sales.regvtamentab a,
               sales.instancia_paquete_cambio b
         where a.numslc      = b.numslc
           and a.numregistro = b.numregistro
           and a.numslc      = a_proy
           and exists ( select det.codigoc 
                          from tipopedd cab, 
                               opedd det 
                         where cab.tipopedd = det.tipopedd 
                           and cab.abrev = 'CONFIG_A_SGA_JANUS');
                           
        if v_cnt_cp > 0 then
          -- Cambio de Plan
          select distinct a.numslc_ori
            into v_proy_ori
            from sales.regvtamentab a,
                 sales.instancia_paquete_cambio b
           where a.numslc      = b.numslc
             and a.numregistro = b.numregistro
             and a.numslc      = a_proy
             and exists ( select det.codigoc 
                            from tipopedd cab, 
                                 opedd det 
                           where cab.tipopedd = det.tipopedd 
                             and cab.abrev = 'CONFIG_A_SGA_JANUS'); 
    
          select operacion.f_get_proy(v_proy_ori,1)
            into v_proy_ori 
            from dual;
            return v_proy_ori;
        else
          -- otros Casos TE, TI...etc
          select distinct a.numslc
            into v_proy_ori
            from sales.regvtamentab a,
                 sales.regdetsrvmen b
           where a.numregistro = b.numregistro
             and a.numslc      = a_proy
             and exists ( select det.codigoc 
                            from tipopedd cab, 
                                 opedd det 
                           where cab.tipopedd = det.tipopedd 
                             and cab.abrev = 'CONFIG_B_SGA_JANUS');
     
          return v_proy_ori;
        end if;
      else
        -- venta nueva
        return a_proy;
      end if;
    end if;
  exception 
    when others then 
      return a_proy;
  end;
/