CREATE OR REPLACE PROCEDURE OPERACION.P_TMP_EQUXCID IS
tmpVar NUMBER;
/******************************************************************************
******************************************************************************/

cursor cur is
select cid, orden from equxcid where estado = 'INSTALACION' order by cid, orden;

l_orden number;
old_cid number;

BEGIN

	old_cid := 0;
	for c in cur loop
   	if c.cid = old_cid then
      	l_orden := l_orden + 1 ;
      else
      	l_orden := 1;
      end if;

      old_cid := c.cid;
      update equxcid set orden = l_orden
      where cid = c.cid and orden = c.orden;

   end loop;


END;
/


