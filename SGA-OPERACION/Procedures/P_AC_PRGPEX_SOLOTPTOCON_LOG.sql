CREATE OR REPLACE PROCEDURE OPERACION.P_AC_PRGPEX_SOLOTPTOCON_LOG(
	a_codsolot in number,
	a_punto in number,
	a_orden in number default 0,
	a_codcon_old in number,
	a_codcon_new in number,
	a_fecasig_old in date,
	a_motivo in varchar2
) IS

l_codigo number;

BEGIN
	 SELECT F_GET_SOLOTPTOCONTRATA_LOG INTO l_codigo FROM DUAL;
	 INSERT INTO SOLOTPTOCONTRATA_LOG (CODIGO,CODSOLOT,PUNTO,ORDEN,MOTIVO,CODCON_OLD,CODCON_NEW,FECASIG_OLD)
	 VALUES(l_codigo,a_codsolot,a_punto,a_orden,a_motivo,a_codcon_old,a_codcon_new,a_fecasig_old);

/*	 if a_orden = 0 then
	 	 UPDATE PREUBI SET CODCON = a_codcon_new, FECASIG = sysdate WHERE CODSOLOT = a_codsolot
		 AND PUNTO = a_punto;
	 else
	 	 UPDATE SOLOTPTOETA SET CODCON = a_codcon_new, FECCON = sysdate WHERE CODSOLOT = a_codsolot
		 AND PUNTO = a_punto AND ORDEN = a_orden;
	 end if;*/
END;
/


