CREATE OR REPLACE PROCEDURE OPERACION.P_GEN_OT_FIN_DEMO ( a_codsolot in number) IS

cursor cur_ot is
select CODOT, CODMOTOT, CODSOLOT, TIPTRA, ESTOT, CODDPT,  ORIGEN from ot
where codsolot = a_codsolot and estot <> 5 and origen = 'P' ;

l_tiptra ot.tiptra%type;

BEGIN

	for lc1 in cur_ot loop

      IF lc1.tiptra = 	1	 then L_TIPTRA := 	3	;
      ELSIF lc1.tiptra = 	7	 then L_TIPTRA := 	10	;
      ELSIF lc1.tiptra = 	19	 then L_TIPTRA := 	3	;
      ELSIF lc1.tiptra = 	63	 then L_TIPTRA := 	3	;
      ELSIF lc1.tiptra = 	67	 then L_TIPTRA := 	10	;
      ELSIF lc1.tiptra = 	71	 then L_TIPTRA := 	3	;
      ELSIF lc1.tiptra = 	9	 then L_TIPTRA := 	10	;
      ELSIF lc1.tiptra = 	10	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	87	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	86	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	85	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	88	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	89	 then L_TIPTRA := 	108	;
      ELSIF lc1.tiptra = 	109	 then L_TIPTRA := 	10	;
      ELSIF lc1.tiptra = 	110	 then L_TIPTRA := 	3	;
      ELSIF lc1.tiptra = 	113	 then L_TIPTRA := 	136	;
      ELSIF lc1.tiptra = 	116	 then L_TIPTRA := 	136	;
      ELSIF lc1.tiptra = 	133	 then L_TIPTRA := 	136	;
      ELSIF lc1.tiptra = 	136	 then L_TIPTRA := 	136	;
      else L_TIPTRA := 	108	;
      end if;

   	insert into OT (CODOT, CODMOTOT, CODSOLOT, TIPTRA, ESTOT, CODDPT,  ORIGEN)
      values ( null, 15, a_codsolot, l_tiptra, 1, lc1.coddpt, 'X' );

   end loop;

END;
/


