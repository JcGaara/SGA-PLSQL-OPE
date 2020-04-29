CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_COSTO_OT(an_CODOT IN number) IS

ln_porcosmocli number;
ln_porcosmatcli number;
ln_cosmo number;
ln_cosmat number;
ld_area number;


BEGIN
-- Se identifiac el area // Modificacion por VVS
select area into ld_area from ot where codot = an_codot;
--
-- Inicializa los valores
update otptoeta set
cosmat = 0,
cosmo = 0,
cosmat_s = 0,
cosmo_s = 0
where codot = an_codot;

if ld_area <> 22 then --Linea ingresada por VVS
	-- Inicializa los valores si es por contrata
	update otptoeta set
	cosmat = (select nvl(sum(a.COSMAT),0)
	    FROM OTPTOETACON a
	   WHERE  a.CODOT = otptoeta.CODOT  AND
	          a.PUNTO = otptoeta.punto  AND
	          a.CODETA = otptoeta.codeta   ),
	cosmo = (select nvl(sum(a.COSmo),0)
	    FROM OTPTOETACON a
	   WHERE a.CODOT = otptoeta.CODOT  AND
	         a.PUNTO = otptoeta.punto  AND
	         a.CODETA = otptoeta.codeta   )
	where codot = an_codot and porcontrata = 1;

	-- se actualiza con el resto de los valores
	update otptoeta set
	cosmat = (select OTptoeta.cosmat + nvl(sum(a.COSto * a.cantidad),0)
	    FROM OTptoetamat a
	   WHERE a.CODOT = otptoeta.CODOT AND
	         a.PUNTO = otptoeta.punto AND
	         a.CODETA = otptoeta.codeta and
			 a.porcontrata = 0 ),
	cosmo =  (select otptoeta.cosmo + nvl(sum(a.COSto * a.cantidad),0)
	    FROM otptoetaact a
	   WHERE a.CODOT = otptoeta.CODOT AND
	         a.PUNTO = otptoeta.punto AND
	         a.CODETA = otptoeta.codeta and
			 a.porcontrata = 0 and a.moneda = 'D' ),
	cosmo_s =  (select otptoeta.cosmo + nvl(sum(a.COSto * a.cantidad),0)
	    FROM otptoetaact a
	   WHERE a.CODOT = otptoeta.CODOT AND
	         a.PUNTO = otptoeta.punto AND
	         a.CODETA = otptoeta.codeta and
			 a.porcontrata = 0 and a.moneda = 'S' )
	where codot = an_codot;
else --Linea ingresada por VVS
	update otptoeta set
	cosmat = (select nvl(sum(a.costo * a.cantidad * (fecfin - fecini) * 24),0)
		   	    FROM otptoetamat a
				WHERE a.codot = otptoeta.codot AND
	         		  a.punto = otptoeta.punto AND
	         		  a.codeta = otptoeta.codeta and
			 		  a.porcontrata = 0 ),
	cosmo =  (select nvl(sum(a.costo * a.cantidad * (fecfin - fecini) * 24),0)
	      	 	FROM otptoetaact a
	   			WHERE a.codot = otptoeta.codot AND
	         		  a.punto = otptoeta.punto AND
	         		  a.codeta = otptoeta.codeta and
			 		  a.porcontrata = 0 and
					  a.moneda = 'D' ),
	cosmo_s =  (select nvl(sum(a.COSto * a.cantidad * (fecfin - fecini)* 24),0)
	    	   	  FROM otptoetaact a
	   			  WHERE a.codot = otptoeta.codot AND
	         	  		a.punto = otptoeta.punto AND
	         			a.codeta = otptoeta.codeta and
			 			a.porcontrata = 0 and
						a.moneda = 'S' )
	where codot = an_codot;

	update otptoeta set
	cosmat = (select otptoeta.cosmat + nvl(sum(a.costo * a.cantidad ),0)
		   	    FROM otptoetamat a
				WHERE a.codot = otptoeta.codot AND
	         		  a.punto = otptoeta.punto AND
	         		  a.codeta = otptoeta.codeta and
			 		  a.porcontrata = 1 ),
	cosmo =  (select otptoeta.cosmo + nvl(sum(a.costo * a.cantidad ),0)
	      	 	FROM otptoetaact a
	   			WHERE a.codot = otptoeta.codot AND
	         		  a.punto = otptoeta.punto AND
	         		  a.codeta = otptoeta.codeta and
			 		  a.porcontrata = 1 and
					  a.moneda = 'D' ),
	cosmo_s =  (select otptoeta.cosmo_s + nvl(sum(a.costo * a.cantidad ),0)
	    	   	  FROM otptoetaact a
	   			  WHERE a.codot = otptoeta.codot AND
	         	  		a.punto = otptoeta.punto AND
	         			a.codeta = otptoeta.codeta and
			 			a.porcontrata = 1 and
						a.moneda = 'S' )
	where codot = an_codot;

end if; --Fin de la modificacion

/*
-- se actualiza con los valores que pagara el cliente y la empresa
update otptoeta set
cosmatcli = (select otptoeta.cosmat * a.porcosmatcli from etapa a where otptoeta.codeta = a.codeta) ,
cosmocli = (select otptoeta.cosmo * a.porcosmocli from etapa a where otptoeta.codeta = a.codeta)
where codot = an_codot;
*/
-- Costo por punto
update otpto set
cosmat = (select nvl(sum(a.COSMAT),0)
    FROM OTPTOETA a
   WHERE  a.CODOT = otpto.CODOT  AND
          a.PUNTO = otpto.punto ),
cosmo = (select nvl(sum(a.COSmo),0)
    FROM otptoeta a
   WHERE a.CODOT = otpto.CODOT  AND
         a.PUNTO = otpto.punto  ),
cosmat_s = (select nvl(sum(a.COSmat_s),0)
    FROM OTPTOETA a
   WHERE a.CODOT = otpto.CODOT  AND
         a.PUNTO = otpto.punto  ),
cosmo_s = (select nvl(sum(a.COSmo_s),0)
    FROM OTPTOETA a
   WHERE a.CODOT = otpto.CODOT  AND
         a.PUNTO = otpto.punto  ),
cosequ = (select nvl(sum(b.costo * b.cantidad * a.cantidad),0)
    from otptoequ a, otptoequcmp b
   where a.codot = otpto.codot  and
         a.punto = otpto.punto and
		 a.codot = b.codot  and
         a.punto = b.punto and
		 a.orden = b.orden )
where codot = an_codot;

update otpto set
cosequ = (select nvl(sum(a.COSto * a.cantidad),0) + cosequ
    FROM OTPTOequ a
   WHERE a.CODOT = otpto.CODOT  AND
         a.PUNTO = otpto.punto  )
where codot = an_codot;

-- Costo por orden
update ot set
cosmat = (select nvl(sum(a.COSMAT),0)
    FROM otpto a
   WHERE  a.CODOT = ot.CODOT ),
cosmo = (select nvl(sum(a.COSmo),0)
    FROM otpto a
   WHERE a.CODOT = ot.CODOT  ),
cosmat_s = (select nvl(sum(a.COSmat_s),0)
    FROM otpto a
   WHERE a.CODOT = ot.CODOT  ),
cosmo_s = (select nvl(sum(a.COSmo_s),0)
    FROM otpto a
   WHERE a.CODOT = ot.CODOT  ),
cosequ = (select nvl(sum(a.COSequ),0)
    FROM OTPTO a
   WHERE a.CODOT = ot.CODOT  )
where codot = an_codot;

END;
/


