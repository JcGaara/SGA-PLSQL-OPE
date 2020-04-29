CREATE OR REPLACE PROCEDURE OPERACION.P_ORDENAR_EQUXCID (an_CID in  equxcid.cid%type)IS
tmpVar NUMBER;
/******************************************************************************
******************************************************************************/

cursor cur is
select cid, orden
	from equxcid
	where cid = an_cid and ordenpad is null
	order by cid, orden;

cursor cur_h (an_ordenpad in equxcid.orden%type) is
select cid, orden
	from equxcid
	where cid = cid and
		  ordenpad = an_ordenpad
	order by cid, orden;

l_orden number;
l_orden_p number;
old_cid number;

BEGIN
	l_orden := 0;
	for c in cur loop
	  	l_orden := l_orden + 1 ;

		update equxcid
			set orden = l_orden
      		where cid = c.cid and
				  orden = c.orden;

		l_orden_p := l_orden * 1000;

  		for d in cur_h (c.orden) loop
			l_orden_p := l_orden_p + 1 ;
			update equxcid
				set orden = l_orden_p
      			where cid = d.cid and
					  orden = d.orden;
	   end loop;
   end loop;

END;
/


