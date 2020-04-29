CREATE OR REPLACE PROCEDURE OPERACION.P_Agrega_Permisos(de IN VARCHAR2, a IN VARCHAR2) is
/******************************************************************************
autor: Gustavo Ormeño.

Agrega los permisos del usuario DE al usuario A
No borra los permisos anteriores
******************************************************************************/
   numPermiso  NUMBER;
   numPreusu  NUMBER;
   numArea  NUMBER;

   -- carga los permisos del usurio de
   cursor c_permisos_de (usuario varchar2) is
       SELECT coddpt, tipo, acceso, aprob, opcion,area
       FROM accusudpt
       WHERE codusu = usuario;

   cursor c_preusufas_de (usuariopre varchar2) is
       SELECT coddpt, codfas, codeta, tipacc, acceso
       FROM preusufas
       WHERE codusu = usuariopre;

   cursor c_ope_de (usuarioareaope varchar2) is
       SELECT area, permiso
       FROM usuarioxareaope
       WHERE usuario = usuarioareaope;

BEGIN
  for c_de in c_permisos_de (de) loop
       -- verifico si el usuario a tiene el permiso
       select count(*) into numPermiso
       from accusudpt
       where tipo = c_de.tipo
       and opcion = c_de.opcion and area = c_de.area
       and codusu = a;
       -- si no tiene el permniso lo inserto
       if( numPermiso = 0 ) then
                dbms_output.put_line('c_de.coddpt'||' ' || c_de.coddpt ||' ' || 'c_de.tipo'||' ' || c_de.tipo ||' ' || 'c_de.acceso'||' ' || c_de.acceso ||' ' || 'c_de.aprob'||' ' || c_de.aprob ||' ' || 'c_de.opcion'||' ' ||c_de.opcion ||' ' || 'c_de.area'||' ' ||c_de.area);
                INSERT INTO accusudpt
                         (codusu, coddpt, tipo, acceso, aprob, opcion,area)
                values (a, c_de.coddpt, c_de.tipo, c_de.acceso, c_de.aprob, c_de.opcion, c_de.area);
       end if;
 	 end loop;

  for c_pre_de in c_preusufas_de(de) loop
      -- verifico si el usuario a tiene el permiso
      select count(*) into numPreusu
      from preusufas
      where codfas = c_pre_de.codfas
      and codeta = c_pre_de.codeta
      and codusu = a;
      -- si no tiene el permniso lo inserto
      if( numPreusu = 0 ) then
                   INSERT INTO preusufas
                           (codusu, coddpt, codfas, codeta, tipacc, acceso)
                   VALUES (a, c_pre_de.coddpt, c_pre_de.codfas, c_pre_de.codeta, c_pre_de.tipacc, c_pre_de.acceso);
       end if;
 	 end loop;

   for c_area in c_ope_de(de) loop
       -- verifico si el usuario tiene el permiso
       select count(*) into numArea
       from usuarioxareaope
       where area = c_area.area
       and usuario = a ;
       -- si no tiene el permniso lo inserto
       if( numArea = 0 ) then
                    INSERT INTO usuarioxareaope
                             (area, usuario, permiso)
                    VALUES (c_area.area, a, c_area.permiso);
       end if;
 	 end loop;
end;
/


