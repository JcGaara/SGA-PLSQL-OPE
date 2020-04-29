CREATE OR REPLACE PROCEDURE OPERACION.P_GET_ANATEL_TAREAWF (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number,
a_tipesttar in number,
a_esttarea in number,
a_mottarchg in number,
a_fecini in date,
a_fecfin in date
) IS
tmp NUMBER;
cab varchar2(3);
ano number;
ano_act number;
seq number;
l_anatel varchar2(10);
l_tiptra number;
l_codsolot number;

/******************************************************************************
Funcion usada en las ventanas
Obtiene el contador ANATEL
XXX - Indicador Mudança Endereço
AA -  Ano
##### - seqüêncial numérico iniciada em 00001;
******************************************************************************/
BEGIN

	if a_tipesttar = 4 then
	   select solot.codsolot, nvl(tiptra,0) into l_codsolot, l_tiptra
	   		from solot, wf, tareawf
	   		where solot.codsolot = wf.codsolot and
	   		 wf.idwf = tareawf.idwf and tareawf.idtareawf = a_idtareawf;

	   if l_tiptra = 24 or l_tiptra = 25 then

		   select nvl(max(anatel),'IME0000000') into l_anatel from solot_adi;

		   cab := substr(l_anatel,1,3);
		   ano := to_number(substr(l_anatel,4,2));
		   seq := to_number(substr(l_anatel,6,5));

		   ano_act := to_number(to_char(sysdate,'yy'));

		   if ano = ano_act then
		   	  seq := seq + 1;
		   else
		   	  seq := 1;
		   end if;

		   l_anatel := cab || lpad(ano_act,2,'0') || lpad(seq,5,'0');

	   	   update solot_adi
		   	 set anatel = l_anatel
			 where codsolot = l_codsolot and anatel is null;

	   end if;
   end if;
   EXCEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20500,'No se pudo obtener el numero ANATEL');
END;
/


