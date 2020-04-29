DELETE FROM operacion.opedd o
 WHERE o.abreviacion = 'ACT_COMCNT'
   AND o.tipopedd =
       (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'VIS_NROCONTACT');
	   
DELETE FROM operacion.opedd o
 WHERE o.abreviacion = 'LST_COMCNT'
   AND o.tipopedd =
       (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'VIS_NROCONTACT');
       
DELETE FROM operacion.tipopedd t WHERE t.abrev = 'VIS_NROCONTACT';

commit;
/