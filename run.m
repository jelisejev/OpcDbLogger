clear;
mysql('closeall');

logger = OpcDbLogger();
logger.connect('localhost', 'root', '', 'opc');

o = OpcListener();
o.connect('localhost', 'M2MOPC.OPC.1');
%o.listen('MSC:[test]DB1,*', 'log', @disp);
%o.listen('MSC:[RemSt_1]DB1,REAL2210', 'log', @disp);
o.listen('MSC:[RemSt_1]DB1,REAL2210', 'log', @logger.log);
o.run();