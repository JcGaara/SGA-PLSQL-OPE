declare
begin
  for cur in (select area
              from areaope 
              where descripcion = 'PORTABILIDAD Y DESPACHO')
  loop

    update solot
    set areasol = null
    where areasol = cur.area;
  
    update tareawf
    set area = null
    where area =  cur.area;
    commit;
    
    update tareawfcpy
    set area = null
    where area =  cur.area;

    update solot
    set areasol = null
    where areasol =  cur.area;
    commit;
    
    delete from tareawfchgres
    where area =  cur.area;

    delete from accusudpt
    where area =  cur.area;
    commit; 
       
    update tareawfdef
    set area = null
    where area =  cur.area;
    
    delete from areaope where area =  cur.area and
      descripcion = 'PORTABILIDAD Y DESPACHO';
    commit;
  end loop;
end;
/

declare
 ln_var    number;
begin
  select codmotot into ln_var 
  from motot 
  where descripcion = 'Solicitud Cliente - Portabilidad';

  update solot
  set codmotot = null
  where codmotot = ln_var;
  
  delete from motot 
  where descripcion = 'Solicitud Cliente - Portabilidad' ;
  commit;
end;
/

