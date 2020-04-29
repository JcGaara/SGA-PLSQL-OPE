CREATE OR REPLACE VIEW OPERACION.V_OT_TIEMPO_ATENCION_REC
AS 
SELECT ot.codot,  
         ot.coddpt,  
         solot.recosi,  
         solot.tiprec,  
         motot.codmotot,  
         nvl(motot.grupodesc,'Varios') grupo,  
         motot.descripcion as motivo,  
         vtatabcli.nomcli,  
         ot.fecusu,  
         nvl((sum(otptoetainf.fecfin - otptoetainf.fecini) + decode(sign(min(otptoetainf.fecini) - ot.fecusu),-1,0, min(otptoetainf.fecini) - ot.fecusu ))*24 ,  
         (nvl(max(otptoetainf.fecfin),ot.fecfin) - ot.fecusu)*24 ) as duracion  
    FROM ot,  
         otptoetainf,  
         solot,  
         vtatabcli,  
         motot  
   WHERE ( ot.codot = otptoetainf.codot (+)) and  
         ( ot.codmotot = motot.codmotot ) and  
         ( solot.codsolot = ot.codsolot ) and  
         ( solot.codcli = vtatabcli.codcli ) and  
         ( solot.recosi is not null )  
GROUP BY ot.codot,  
         ot.coddpt,  
         solot.recosi,  
         solot.tiprec,  
         motot.codmotot,  
         motot.grupodesc,  
         motot.descripcion,  
         vtatabcli.nomcli,  
         ot.fecusu,  
         ot.fecfin;


