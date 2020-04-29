CREATE OR REPLACE PROCEDURE OPERACION.P_Copia_Permisos (
   de   IN   VARCHAR2,
   a    IN   VARCHAR2
)
IS
/******************************************************************************
Copia los permisos del usuario DE al usuario A
Borra los permisos anteriores
******************************************************************************/
   tmpvar   NUMBER;
   l_cuenta number;

BEGIN


select count(*)
into l_cuenta
from OPERACION.USUARIOXCONTRATA where usuario = de;


   DELETE      accusudpt
         WHERE codusu = a;

   INSERT INTO accusudpt
               (codusu, coddpt, tipo, acceso, aprob, opcion,area)
      SELECT a, coddpt, tipo, acceso, aprob, opcion,area
        FROM accusudpt
       WHERE codusu = de;

   DELETE      preusufas
         WHERE codusu = a;

   INSERT INTO preusufas
               (codusu, coddpt, codfas, codeta, tipacc, acceso)
      SELECT a, coddpt, codfas, codeta, tipacc, acceso
        FROM preusufas
       WHERE codusu = de;

   DELETE      usuarioxareaope
         WHERE usuario = a;

   INSERT INTO usuarioxareaope
               (area, usuario, permiso)
      SELECT area, a, permiso
        FROM usuarioxareaope
       WHERE usuario = de;

   /*Modificación José Ramos REQ. 74778*/

   if(l_cuenta>0)then

     DELETE OPERACION.USUARIOXCONTRATA
       WHERE usuario = a;

     INSERT INTO OPERACION.USUARIOXCONTRATA (CODCON,USUARIO)
       SELECT codcon, a
       FROM OPERACION.USUARIOXCONTRATA
       WHERE usuario = de;

    end if;

    /*Fin REQ. 74778*/

END;
/


