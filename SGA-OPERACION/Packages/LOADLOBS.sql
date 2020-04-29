CREATE OR REPLACE PACKAGE OPERACION.loadlobs is   column blob;   end_of_lob binary_integer;   function beginload (classfile varchar2) return varchar2;   procedure appendpiece (piece raw, len binary_integer);   function endload (classfile varchar2) return varchar2;   function beginread (classfile varchar2, len out binary_integer)          return varchar2;   function getpiece (piece out raw, len in out binary_integer)          return varchar2;   function endread (classfile varchar2) return varchar2; end loadlobs;
/


