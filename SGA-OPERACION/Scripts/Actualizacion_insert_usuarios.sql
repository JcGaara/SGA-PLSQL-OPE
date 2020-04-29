declare
  cursor usuario is
    select t.usuario, t.estado
      from opewf.usuarioope t
     where t.usuario in ('C10723','C12292','C12798','C13807','C13973','C14017','C14504','C14576','C14696','C14697',
                         'C14700','C14701','C14711','C14725','C16128','C17221','C17333','C17686','C18564','C17733',
                         'C24482','C24641');
  l_usuario opewf.usuarioope.usuario%type;
  l_estado  opewf.usuarioope.estado%type;                         
  l_count   pls_integer;
begin

for c_usuario in usuario loop
    l_usuario := c_usuario.usuario;
    l_estado  := c_usuario.estado;
      
    if l_estado <> 1 then 
       update opewf.usuarioope t
       set t.estado = 1
       where t.usuario = l_usuario;
    end if;
      
    select count(1) into l_count from opewf.usuarioxareaope t
    where t.usuario = l_usuario
     and t.area in (select area from areaope where descripcion = 'SOPORTE OPERATIVO');
      
    if l_count = 1 then
       update opewf.usuarioxareaope t
       set t.permiso = 1
       where t.usuario = l_usuario
       and t.area in (select area from areaope where descripcion = 'SOPORTE OPERATIVO');
    else
       insert into opewf.usuarioxareaope  (area,usuario,permiso) 
       select area,l_usuario, 1 from areaope where descripcion = 'SOPORTE OPERATIVO' ;
    end if;            
      
end loop ;

commit;

end;
/
