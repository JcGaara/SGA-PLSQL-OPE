CREATE OR REPLACE VIEW OPERACION.V_CONTACTO_TECNICO
AS 
SELECT  
         vtatabcntcli.codcnt   ,  
         vtatabcntcli.codcli,  
         vtatabcntcli.nomcnt nombre,  
         vtatabcntcli.carcnt cargo,  
         vtatabcntcli.estado estado,  
         a.numero    sin_definir,  
			B.numero 	Tel_Oficina_1 ,  
			C.numero 	Tel_Oficina_2,  
			D.numero 	Celular_1 ,  
			E.numero 	Fax_1 ,  
			F.numero 	email_1 ,  
			G.numero 	email_2 ,  
			H.numero 	Tel_Fax_1  
    FROM  
    vtatabcntcli    ,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '000'  
    and vtamedcomcnt.numcomcnt is not null ) a,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '001'  
    and vtamedcomcnt.numcomcnt is not null ) b,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '002'  
    and vtamedcomcnt.numcomcnt is not null ) c,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '003'  
    and vtamedcomcnt.numcomcnt is not null ) d,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '004'  
    and vtamedcomcnt.numcomcnt is not null ) e,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '008'  
    and vtamedcomcnt.numcomcnt is not null ) f,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '009'  
    and vtamedcomcnt.numcomcnt is not null ) g,  
(    SELECT vtamedcomcnt.codcnt,  
         vtamedcomcnt.numcomcnt numero  
    FROM vtamedcomcnt where   vtamedcomcnt.idmedcom = '010'  
    and vtamedcomcnt.numcomcnt is not null ) h  
    where  
    vtatabcntcli.tipcnt = '04'  
    and vtatabcntcli.codcnt = a.codcnt (+)  
    and vtatabcntcli.codcnt = b.codcnt (+)  
    and vtatabcntcli.codcnt = c.codcnt (+)  
    and vtatabcntcli.codcnt = d.codcnt (+)  
    and vtatabcntcli.codcnt = e.codcnt (+)  
    and vtatabcntcli.codcnt = f.codcnt (+)  
    and vtatabcntcli.codcnt = g.codcnt (+)  
    and vtatabcntcli.codcnt = h.codcnt (+);


