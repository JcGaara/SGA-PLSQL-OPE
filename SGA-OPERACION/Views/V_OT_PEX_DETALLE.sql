CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_DETALLE
AS 
SELECT solotpto.codsolot numero_solicitud,  
         solotpto.punto punto,  
         solotpto.codsolot  codpre,  
         solotpto.punto idubi,  
         solotpto.codinssrv numero_SID,  
         solotpto.cid numero_CID,  
         solotpto.descripcion Descripcion_sede,  
         solotpto.direccion direccion_sede,  
         vtatabdst.nomdst distrito_sede,  
         v_pop.codpop codigo_pop,  
         v_pop.descripcion nombre_pop,  
         solotpto.puerta puerta_0,  
         estpreubi.descripcion estado,  
          tystabsrv.dscsrv Descripcion_servicio,  
         solotpto.bwnue ancho_banda,  
         preubi.PA_ATT_9,  
         preubi.PA_ATT_11,  
         preubi.PA_LDS_C,  
         preubi.PA_LDS_M,  
         preubi.PA_EN_C,  
         preubi.PA_EN_M,  
         preubi.PA_BELL,  
         preubi.PA_TELE,  
         preubi.PO_ATT_9,  
         preubi.PO_ATT_11,  
         tipfibra.ABREVI ,  
         preubi.CABLE_LONG,  
         preubi.ASIG_FIBRA,  
         preubi.feciniins,  
         preubi.fecfinins,  
         preubi.CABLE_DUCTO,  
         preubi.PA_ANCLA,  
         preubi.FECINILIQ,  
         preubi.FECFINLIQ  
    FROM preubi,  
         solotpto,  
         v_pop,  
         vtatabdst,  
         tystabsrv,  
         estpreubi,  
         tipfibra  
   WHERE ( solotpto.codubi = vtatabdst.codubi (+)) and  
         ( v_pop.pop (+) = solotpto.pop) and  
         ( solotpto.codsolot = preubi.codsolot ) and  
         ( solotpto.punto = preubi.punto ) and  
         ( solotpto.codsolot = tystabsrv.codsrv (+)) and  
         ( preubi.estubi = estpreubi.estpreubi (+)) and  
         preubi.CABLE_TIPO = tipfibra.codtipfibra (+);


