
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='PR-CORP-ALER' );
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='PR-CORP-MAIL' );
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='PR-CORP-WF' );
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='PR-CORP-WS' );
commit;

delete from tipopedd where abrev ='PR-CORP-ALER';
delete from tipopedd where abrev ='PR-CORP-MAIL';
delete from tipopedd where abrev ='PR-CORP-WF';
delete from tipopedd where abrev ='PR-CORP-WS';
commit; 


-------------------  ELIMINAR URL
DELETE operacion.constante WHERE CONSTANTE='TARGET-CORP';
   
------------------ ELIMINAR ACTION
DELETE operacion.constante WHERE CONSTANTE='ACT_PORTA_CORP';

-------------------ELIMINAR PR_PORT_CORP_CONF
delete from opedd
 where tipopedd in (select tipopedd
                      from tipopedd
                     where descripcion = 'PR_PORT_CORP_CONF');
--
delete from tipopedd where descripcion = 'PR_PORT_CORP_CONF';
--
commit;

--