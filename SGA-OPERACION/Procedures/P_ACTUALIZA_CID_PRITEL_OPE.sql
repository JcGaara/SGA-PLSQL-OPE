CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZA_CID_PRITEL_OPE
IS
  -- Author  : EDILBERTO ASTULLE
  -- Created : 26/08/2004 9:55:18 AM
  -- Purpose : Paquete para asignar las cids a pritel
/*****************************************************************************************
Actializa Los cid de pritel
*****************************************************************************************/
  cursor cursor_det is
  SELECT puertoxequipo.codpuerto ,
         puertoxequipo.puerto,
         tarjetaxequipo.slot,
         puertoxequipo.codequipo
    FROM puertoxequipo,
         tarjetaxequipo
   WHERE ( tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta)
   and puertoxequipo.CODEQUIPO = 519;
n_cont number;
n_cont_cid number;
n_cid number;
n_cid2 number;
n_cid3 number;
n_codinssrv number;

BEGIN
   -- Actualizar CID
   for r_cur in cursor_det loop
/*      select count(*) into n_cont from pritel
	  where pdtc = r_cur.slot and ckto = TO_NUMBER(r_cur.puerto);
--	  where to_number(pdtc) = to_number(r_cur.slot) and to_number(ckto) = to_number(r_cur.puerto);
	  if n_cont = 1 then
         select nvl(codinssrv,0) into n_codinssrv from pritel
	     where pdtc = r_cur.slot and ckto = TO_NUMBER(r_cur.puerto);
--	     where to_number(pdtc) = to_number(r_cur.slot) and to_number(ckto) = to_number(r_cur.puerto);

         select count(*) into n_cont_cid from inssrv where codinssrv = n_codinssrv;
		 if n_cont_cid = 1 then
            select nvl(cid,0) into n_cid from inssrv where codinssrv = n_codinssrv;
--			if n_cid > 0 then
--			   select nvl(cid,0) into n_cid2 from puertoxequipo where codpuerto = r_cur.codpuerto;
--			   if n_cid2 > 0 then

                  update puertoxequipo set cid = n_cid
                  where codpuerto = r_cur.codpuerto;
--			   end if;
--			end if;
		 end if;
	  end if;
      null;*/
	  select Count(*) into n_cont from pritel
      where pdtc = r_cur.slot and ckto = TO_NUMBER(r_cur.puerto);

      if n_cont = 1 then
         select NVL(codinssrv,0) into n_codinssrv from pritel
         where pdtc = r_cur.slot and ckto = TO_NUMBER(r_cur.puerto);

         select NVL(cid,0) into n_cid from inssrv where codinssrv = n_codinssrv;

	     IF n_cid > 0 THEN

  	        select nvl(cid,0) into n_cid2 from puertoxequipo where codpuerto = r_cur.codpuerto;
			IF n_cid2 = 0 then
               select count(*) into n_cid3 from puertoxequipo where cid = n_cid;
			   if n_cid3 = 0 then
                  update puertoxequipo set cid = n_cid, estado = 1, descripcion = ''
                  where codpuerto = r_cur.codpuerto;
			   end if;
			end if;
         END IF;
      END IF;

   end loop;
   COMMIT;
END;
/


