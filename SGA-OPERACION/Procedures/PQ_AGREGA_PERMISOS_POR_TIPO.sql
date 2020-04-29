CREATE OR REPLACE PROCEDURE OPERACION.PQ_AGREGA_PERMISOS_POR_TIPO(tipo in number, de in varchar2, a in varchar2) is

/******************************************************************************
autor: Gustavo Ormeño.

Agrega los permisos POR TIPO, del usuario DE al usuario A
No borra los permisos anteriores
******************************************************************************/
   numPermiso  NUMBER;

      cursor c_permisos_de (usuario varchar2) is
       SELECT "ACCUSUDPT"."AREA",
             "ACCUSUDPT"."APROB",
             "ACCUSUDPT"."OPCION",
             "ACCUSUDPT"."TIPO",
             "ACCUSUDPT"."ACCESO",
             "ACCUSUDPT"."CODDPT"
        FROM "ACCUSUDPT"
       WHERE "ACCUSUDPT"."CODUSU" IN (de)
       AND "ACCUSUDPT"."TIPO" = tipo;

begin

  for c_de in c_permisos_de (de) loop
       -- verifico si el usuario a tiene el permiso
       select count(*) into numPermiso
       from accusudpt
       where tipo = c_de.tipo
       and opcion = c_de.opcion and area = c_de.area
       and codusu = a;
       -- si no tiene el permiso lo inserto
       if( numPermiso = 0 ) then
                dbms_output.put_line('c_de.coddpt'||' ' || c_de.coddpt ||' ' || 'c_de.tipo'||' ' || c_de.tipo ||' ' || 'c_de.acceso'||' ' || c_de.acceso ||' ' || 'c_de.aprob'||' ' || c_de.aprob ||' ' || 'c_de.opcion'||' ' ||c_de.opcion ||' ' || 'c_de.area'||' ' ||c_de.area);
                INSERT INTO accusudpt
                         (codusu, coddpt, tipo, acceso, aprob, opcion,area)
                values (a, c_de.coddpt, c_de.tipo, c_de.acceso, c_de.aprob, c_de.opcion, c_de.area);
       end if;
 	 end loop;


end PQ_AGREGA_PERMISOS_POR_TIPO;
/


