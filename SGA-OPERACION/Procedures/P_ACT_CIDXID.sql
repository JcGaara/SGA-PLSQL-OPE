CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_CIDXID (a_cid CIDXIDE.cid%type,a_ide CIDXIDE.ide%type,a_nsr CIDXIDE.NSR%type) IS
BEGIN
 update CIDXIDE set NSR = a_nsr where CID = a_cid and IDE = a_ide ;
END;
/


