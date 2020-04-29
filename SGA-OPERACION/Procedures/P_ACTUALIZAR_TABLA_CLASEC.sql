CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_TABLA_CLASEC
IS
cursor cur_clasec is
     select * from clasec;
BEGIN
      for r_clasec in  cur_clasec loop
            P_ACTUALIZAR_TABLA_IPXCLASEC(r_clasec.clasec);
      end loop;
END;
/


