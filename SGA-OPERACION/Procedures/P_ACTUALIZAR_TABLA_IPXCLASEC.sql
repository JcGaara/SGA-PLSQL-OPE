CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_TABLA_IPXCLASEC(p_clasec varchar2)
IS
/******************************************************************************
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
31/10/2007  Roy Concepcion   Se realizara el llenado actualizado de la tabla de IPXCLASEC
/*******************************************************************************/

l_1 NUMBER(3);
l_2 NUMBER(3);
l_3 NUMBER(3);
l_4 NUMBER(3);
A NUMBER(3);
B NUMBER(3);
C NUMBER(3);
D NUMBER(3);

CURSOR cur_ipxclasec IS
select clasec,numero,numero1,numero2,numero3,numero4
from ipxclasec
where clasec = p_clasec and numero1 is null;

BEGIN

    FOR r_ipxclasec IN cur_ipxclasec LOOP
      /*A:=r_ipxclasec.Numero1;
      B:=r_ipxclasec.Numero2;
      C:=r_ipxclasec.Numero3;
      D:=r_ipxclasec.Numero4;
      --Coger cada uno de los numeros que conforman el IP.
      \*************** PARA CAPTURAR EL PRIMER NUMERO DEL IP ***********\
      SELECT to_number(substr(CLASEC,1,instr(CLASEC,'.',1)-1))into l_num1 FROM IPXCLASEC WHERE CLASEC=r_ipxclasec.clasec AND NUMERO=r_ipxclasec.numero;
      \*************** PARA CAPTURAR EL SEGUNDO NUMERO DEL IP ***********\
      SELECT to_number(substr(CLASEC,instr(CLASEC,'.',1)+1,instr(CLASEC,'.',5)-instr(CLASEC,'.',1)-1)) into l_num2 FROM IPXCLASEC WHERE CLASEC=r_ipxclasec.clasec AND NUMERO=r_ipxclasec.numero;
      \*************** PARA CAPTURAR EL TERCER NUMERO DEL IP ***********\
      SELECT to_number(substr(CLASEC,instr(CLASEC,'.',5)+1,instr(CLASEC,'.',9)-instr(CLASEC,'.',5)-1)) into l_num3 FROM IPXCLASEC WHERE CLASEC=r_ipxclasec.clasec AND NUMERO=r_ipxclasec.numero;
      \*************** PARA CAPTURAR EL CUARTO NUMERO DEL IP ***********\
      SELECT to_number(substr(CLASEC,instr(CLASEC,'.',9)+1)) into l_num4  FROM IPXCLASEC WHERE CLASEC=r_ipxclasec.clasec AND NUMERO=r_ipxclasec.numero;

      --Sumar el numero al numero4 del IP (4to numero)
      l_num4 := l_num4 + r_ipxclasec.numero;

      --Meter cada uno de los numeros a las casillas: numero1,numero2,numero3,numero4
      UPDATE IPXCLASEC SET numero1 =l_num1 ,numero2 = l_num2 ,numero3 = l_num3 ,numero4 = l_num4
      WHERE  CLASEC = r_ipxclasec.CLASEC AND numero =r_ipxclasec.numero;*/

      metasolv.p_eval_ip(r_ipxclasec.clasec, l_1, l_2, l_3, l_4);
      --Sumar el numero al numero4 del IP (4to numero)
      l_4 := l_4 + r_ipxclasec.numero;

      --Meter cada uno de los numeros a las casillas: numero1,numero2,numero3,numero4
      UPDATE IPXCLASEC SET numero1 =l_1 ,numero2 = l_2 ,numero3 = l_3 ,numero4 = l_4
      WHERE  CLASEC = r_ipxclasec.CLASEC AND numero =r_ipxclasec.numero;

      COMMIT;

   END LOOP;


END;
/


