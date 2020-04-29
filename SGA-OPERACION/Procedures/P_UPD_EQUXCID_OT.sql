CREATE OR REPLACE PROCEDURE OPERACION.P_UPD_EQUXCID_OT ( a_codot in number, a_punto in number, a_orden in number, a_CID in number )IS
tmpVar NUMBER;
/******************************************************************************
Se pasa un equipoc/componentes que aparece en la Ot al inventario
******************************************************************************/

l_orden number(10);

l_FECINS date;
l_estado equxcid.estado%type;

BEGIN

	select nvl(max(orden),0) + 1 into l_orden from equxcid where cid = a_cid and nivel = 0;

	insert into equxcid (
   CID, ORDEN, ORDENPAD, TIPEQU, CANTIDAD, NIVEL, FECINS, ESTADO, RED,	NUMSERIE, PROPIETARIO, IOS, OBSERVACION)
   select
   a_CID, l_orden, null, TIPEQU,  CANTIDAD,  0,   FECINS, estado, TIPO, NUMSERIE,decode(tipprp, 0, 'FC',
																																	1, 'FC Alquiler',
																																	2, 'FC Venta',
																																	3, 'Cliente',
																																	4, 'Otros', null ),
																												 null,  OBSERVACION
   from otptoequ
   where
   codot = a_codot and
   punto = a_punto and
   orden = a_orden;

   select FECINS, estado
   into l_fecins, l_estado
   from otptoequ where
   codot = a_codot and
   punto = a_punto and
   orden = a_orden;

   /* componenetes */
	insert into equxcid (
   CID, ORDEN, 						ORDENPAD, TIPEQU, CANTIDAD, NIVEL, FECINS, ESTADO,						  NUMSERIE, PROPIETARIO, IOS, OBSERVACION)
   select
   a_CID, l_orden * 1000 + rownum, l_orden, TIPEQU,  CANTIDAD,  1,   nvl(FECINS,l_fecins), nvl(estado, l_estado ), NUMSERIE, null, null,  OBSERVACION
   from otptoequcmp
   where
   codot = a_codot and
   punto = a_punto and
   orden = a_orden;

   /* se actualiza el flag */
   update otptoequ set flginv = 1, fecinv = sysdate
   where
   codot = a_codot and
   punto = a_punto and
   orden = a_orden;

END;
/


