CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZA_WF(V_NUMSLC NUMBER) AS

cursor

  c1 is

   select codsolot from solot where numslc = V_NUMSLC;





l_contWF number;

l_contTMP number;

begin

   for reg in c1 loop

        select count(*) into l_contWF from wf where codsolot = reg.codsolot;



        if l_contWF > 0 then





              delete from tareawfcpy where idwf in (select idwf from wf where codsolot = reg.codsolot);

              delete from tareawfseg where idtareawf in (select idtareawf from tareawf where idwf in (select idwf from wf where codsolot = reg.codsolot));

              delete from tareawfchg where idtareawf in (select idtareawf from tareawf where idwf in (select idwf from wf where codsolot = reg.codsolot));

              delete from tareawfchgres where idtareawf in (select idtareawf from tareawf where idwf in (select idwf from wf where codsolot = reg.codsolot));

              delete from tareawf where idwf in (select idwf from wf where codsolot = reg.codsolot);

              delete from wf where idwf in (select idwf from wf where codsolot = reg.codsolot);



              commit;

        end if;





        commit;



        update solot

        set estsol = 11

        where codsolot = reg.codsolot;



        select count(*) into l_contTMP from tmp_solot_codigo where codsolot = reg.codsolot;



        if l_contTMP > 0 then

            update tmp_solot_codigo

            set estado = 3

            where codsolot = reg.codsolot;

        else

            insert into tmp_solot_codigo

            values

            (reg.codsolot,3,'MIGRACION',SYSDATE,NULL,NULL,NULL);

        end if;



        commit;



        operacion.p_ejecuta_workflow_sot;



        commit;

     end loop;

end;
/


