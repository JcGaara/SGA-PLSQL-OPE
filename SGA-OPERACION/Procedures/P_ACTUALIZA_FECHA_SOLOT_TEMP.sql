CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZA_FECHA_SOLOT_TEMP IS

vn_solot number(8);
vn_ot number(8);
vd_fecfin date;
vn_area number(8);
cursor r_solot_fecfin is
select  codot, codsolot, fecfin
   from ot where codsolot in (
   		select solot.codsolot
		   from solot,
   		   		ot
			where solot.codsolot = ot.codsolot
			  and solot.fecfin is null
		  	group by solot.codsolot
			having count(*) = 1
		minus
		select codsolot from wf)
		and ot.fecfin is not null
		and area = 22;

cursor r_solot_fecini is
select  codot, codsolot, fecini
   from ot where codsolot in (
   		select solot.codsolot
		   from solot,
   		   		ot
			where solot.codsolot = ot.codsolot
			  and solot.fecini is null
		  	group by solot.codsolot
			having count(*) = 1
		minus
		select codsolot from wf)
		and ot.fecini is not null
		and area = 22;

cursor r_solot_motivo is
select  codot, codsolot, codmotot
   from ot where codsolot in (
   		select solot.codsolot
		   from solot, ot
			where solot.codsolot = ot.codsolot
			  and solot.codmotot is null
		  	group by solot.codsolot
			having count(*) = 1
		minus
		select codsolot from wf)
		and ot.codmotot is not null
		and area = 22;

begin
     for r_cursor1 in r_solot_fecfin loop
 		update solot
       		set solot.fecfin = r_cursor1.fecfin
       		where solot.codsolot = r_cursor1.codsolot;
		commit;
     end loop;

     for r_cursor2 in r_solot_fecini loop
 		update solot
       		set solot.fecini = r_cursor2.fecini
       		where solot.codsolot = r_cursor2.codsolot;
		commit;
     end loop;

     for r_cursor3 in r_solot_motivo loop
 		update solot
       		set solot.codmotot = r_cursor3.codmotot
       		where solot.codsolot = r_cursor3.codsolot;
		commit;
     end loop;
end;
/


