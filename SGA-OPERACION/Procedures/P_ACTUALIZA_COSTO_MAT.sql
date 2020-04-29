CREATE OR REPLACE PROCEDURE OPERACION.p_actualiza_costo_mat is
  --Author  : JOSE.RAMOS
  --Created : 16/10/2008
  --Actualiza los costos de la tabla MATOPE

cursor cur is
select codmat, costo from OPERACION.COSTO_MAT_CONTRATA;
l_cuenta number;
begin
  for c in cur loop
    BEGIN
      select count(*) into l_cuenta from matope where codmat = c.codmat;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_cuenta := 0;
    END;
      if l_cuenta > 0 then
        update matope set costo = c.costo where codmat = c.codmat;
      end if;
  end loop;
  commit;
END;
/


