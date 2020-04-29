CREATE OR REPLACE FUNCTION OPERACION.F_VALIDA_USER_SEF(a_tipo_proy  IN  NUMBER,  a_userop IN VARCHAR2) RETURN NUMBER IS
/******************************************************************************
Valida si el usuario tiene permiso para usar la opcion "CRECIMIENTO DE INFRAESTRUCTURA"
al momento de generar una SEF.

Fecha             Autor             Descripcion
----------    ---------------      ------------------------
2008/10/28    Luis Ramos Galindo   Valida si usuario tiene permiso de usar la opción "CRECIMIENTO DE INFRAESTRUCTURA"

******************************************************************************/

  v_result NUMBER;
  v_numreg NUMBER;


  CURSOR c_user(a_userope IN VARCHAR2) IS
  SELECT  count(od.codigoc) FROM opedd od, usuarioope uo
  WHERE
          uo.usuario = a_userop
         AND uo.area    = od.codigoc
         AND od.Tipopedd = 194;



BEGIN
v_result := 0;

 IF  a_tipo_proy = 41 THEN
     OPEN c_user(a_userop);
     FETCH c_user INTO v_numreg;

     IF  v_numreg > 0  THEN
         v_result:= 0;
     ELSE
         v_result:= -1;
     END IF;
 ELSE
     v_result := 0;

 END IF;

     RETURN v_result;

EXCEPTION
 WHEN OTHERS THEN
    RETURN -1;

END F_VALIDA_USER_SEF;
/


