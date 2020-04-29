CREATE OR REPLACE VIEW OPERACION.V_OFERTA_COMERCIAL
AS 
select  
vtatabpspcli.NUMPSP,  
vtatabslcfac.NUMSLC,  
vtatabpspcli.FECPSP,  
vtatabpspcli.TITPSP,  
vtatabpspcli.NUMOFE,  
vtatabpspcli.DURCON,  
vtatabpspcli.OBSPSP,  
vtatabpspcli.ESTPSPCLI,  
vtatabpspcli.NRODOC,  
vtatabpspcli.NUMCRT,  
vtatabpspcli.IDOPC ,  
vtatabpspcli.NUMCNT,  
vtatabpspcli.ESTFACINS ,  
vtatabpspcli.ESTFACMES ,  
vtatabpspcli.TIPSRV,  
vtatabpspcli.FECACE,  
vtatabslcfac.CODCLI,  
vtatabpspcli.CODECT,  
vtatabpspcli.FECINISRV ,  
vtatabpspcli.FECENTEQU ,  
vtatabpspcli.FECINIFAC ,  
vtatabpspcli.FECVENFAC,  
vtatabpspcli.FLGCTA        ,  
vtatabpspcli.CODBAN       ,  
vtatabpspcli.CODCTACTE ,  
vtatabpspcli.TIPCTA   ,  
vtatabpspcli.CODMND,  
vtatabpspcli.NOMRPT ,  
vtatabpspcli.MONEDA_ID ,  
vtatabpspcli.FLGFNZ ,  
vtatabpspcli.FECAUT ,  
vtatabpspcli.FLGCMS,  
vtatabpspcli.TIPDOC  
from vtatabpspcli,  
vtatabslcfac,  
(select max(c.numpsp) numpsp, max(c.idopc) idopc  
from vtatabpspcli c group by c.numpsp) b  
where vtatabslcfac.numslc = vtatabpspcli.numslc (+) and  
vtatabpspcli.numpsp  = b.numpsp (+) and  
vtatabpspcli.idopc  = b.idopc (+);


