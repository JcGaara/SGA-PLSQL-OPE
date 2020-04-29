CREATE OR REPLACE TRIGGER OPERACION.T_OTPTO_BU
 BEFORE UPDATE ON otpto
FOR EACH ROW
declare
 l_sol ot.codsolot%type;
--Nuevas variable segun el cambio
 TipoTrabajo ot.TIPTRA%type;
 AreaTrabajo ot.AREA%type;
 VARCID solotpto.CID%type null;
 TipoServicio tystipsrv.TIPSRV%type;

BEGIN
 if updating('POP') or updating('PUERTA') then

     select ot.codsolot into l_sol from ot where codot = :new.codot;

    update solotpto set
       pop = :new.pop,
       puerta = :new.puerta
      where
         codsolot = l_sol and
       punto = :new.punto ;

    end if;

--Modificaciones para enviar correo
 if :old.estotpto=1 and :new.estotpto =2 then--ESTADO ANTERIOR GENERADO Y ESTADO POSTERIOR EJECUTADO
        select ot.TIPTRA into TipoTrabajo
      from ot
     where ot.CODOT=:new.codot;

   if TipoTrabajo=1 or TipoTrabajo=3 then --TRABAJO DE INSTALACION
        select ot.AREA into AreaTrabajo
           from ot
       where ot.CODOT=:new.codot;

           if AreaTrabajo=41 then --IP DATA LOCAL SERVICE (NOC)
       select distinct solotpto.CID into VARCID
         from solotpto, ot
        where solotpto.CODSOLOT=ot.CODSOLOT and ot.CODOT=:new.codot and   solotpto.PUNTO=:new.PUNTO;

        if VARCID IS not null then
         select  tipsrv into TipoServicio
     from solot, ot
     where solot.codsolot = ot.codsolot and
        ot.codot=:new.codot;
             if TipoServicio='0005' or TipoServicio='0006' then
                    P_ENVIAR_CORREO_OT_EJECUTADO(:new.codot, :new.punto, VARCID, TipoTrabajo);
        end if;
        end if;
        end if;
     end if;
    end if;
--Fin de las modificacion

END;
/



