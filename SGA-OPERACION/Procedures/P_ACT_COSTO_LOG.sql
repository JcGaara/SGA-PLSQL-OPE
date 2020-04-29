CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_COSTO_LOG IS

cursor cur_mat is
	select codmat from matope where flgcon = 0;

BEGIN

	for lc1 in cur_mat loop
		begin
		update matope
			set costo = ( select preprm_usd from almtabmat where codmat = lc1.codmat),
				descripcion = (select desmat from almtabmat where codmat = lc1.codmat)
			where codmat = lc1.codmat;

		exception
		     when others then
       		 RAISE_APPLICATION_ERROR (-20500,'No se pudo actualizar datos de almacen');
		end;
	 end loop;
END;
/


