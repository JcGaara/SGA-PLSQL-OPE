CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_WORKFLOWAUTO is
CURSOR c1 IS
select * from OPERACION.TMP_SOLOT_CODIGO where estado = 0;

l_idwf wf.idwf%type;
l_wfdef wfdef.wfdef%type;
l_estsol solot.estsol%type;
l_estsol_des estsol.descripcion%type;
l_wf wf.idwf%type;
l_flg number(1);

begin
    FOR reg IN c1 LOOP
    
        --Obtenemos el estado de la SOT
        select estsol into l_estsol from solot where codsolot = reg.codsolot;
        
        --Actualizamos el codubi de la SOLOTPTO
        update inssrv i2
        set i2.codubi = (select c.codubi
        from vtatabcli c, inssrv i 
        where c.codcli = i.codcli
        and i2.codinssrv = i.codinssrv)
        where i2.codubi is null
        and i2.codinssrv in (select s3.codinssrv from solotpto s3 where s3.codsolot=reg.codsolot);

        --Actualizamos el codubi de la SOLOTPTO
        update solotpto s2
        set s2.codubi = (select c.codubi
        from vtatabcli c, inssrv i 
        where c.codcli = i.codcli
        and s2.codinssrv = i.codinssrv)
        where s2.codubi is null
        and s2.codsolot = reg.codsolot;
        
        --Validamos que el estado sea aprobado, caso contrario no se le asigna Work Flow
        if l_estsol = 11 then
            OPERACION.PQ_CUSPE_OPE.P_WORKFLOWAUTO_DETALLE(reg.codsolot);
         
         
             select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dual;
             -- Se selecciona el workflow automaticamente
             if l_flg = 1 then

                l_idwf := F_GET_WF_SOLOT(reg.codsolot,1);
                if l_idwf is not null then
                   PQ_WF.P_REACTIVAR_WF(l_idwf);
                else
                   l_wfdef := CUSBRA.F_BR_SEL_WF(reg.codsolot);
                   if l_wfdef is not null then
                      PQ_WF.P_CREAR_WF( l_wfdef, l_idwf  );
                      PQ_WF.P_SET_PARAM(l_idwf ,'CODSOLOT', reg.codsolot );
                      PQ_WF.P_ACTIVAR_WF( l_idwf );
                   end if;
                end if;
             end if;
             
             select idwf into l_wf from wf where codsolot = reg.codsolot;
             
                -- se hace el update al registro
            update solot set
            estsol = 17, fecini = sysdate
            where codsolot = reg.codsolot;
                      
            update OPERACION.TMP_SOLOT_CODIGO
            set estado = 1, fechaejecucion=sysdate, observacion='Se realizo la asignacion del WF - ' || l_wf || ' a la SOT'
            where codsolot = reg.codsolot;
        else
            select estsol.descripcion into l_estsol_des from estsol where estsol = l_estsol;
            
            update OPERACION.TMP_SOLOT_CODIGO
            set estado = 2, fechaejecucion=sysdate, observacion='El Estado de la SOT no esta en Aprobado. Se encuetra en estado - ' || l_estsol_des
            where codsolot = reg.codsolot;
        end if;
        
        commit;
    END LOOP;
    commit;
end;
/


