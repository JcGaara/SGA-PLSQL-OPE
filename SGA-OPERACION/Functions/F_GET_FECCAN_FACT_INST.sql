CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECCAN_FACT_INST ( a_codsolot in number ) RETURN date IS
tmpVar date;
/******************************************************************************

******************************************************************************/
BEGIN

	begin
		select f.feccan
	   into tmpVar
		from facprgfac a, facdetprg b, cxcdetfac c, cxctabfac f, solot
		where a.facprg_id = b.facprg_id and
		b.idfac = c.idfac and
		c.tipdet in ('B','D') and
		a.numpsp = solot.numpsp and
		c.idfac = f.idfac and
	   solot.codsolot = a_codsolot and rownum = 1 ;

   EXCEPTION
     WHEN OTHERS THEN
       return tmpvar;
	end;

   RETURN tmpVar;
END;
/


