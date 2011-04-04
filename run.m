clear;
import java.util.*;
%mysql('closeall');

logger = OpcDbLogger();
logger.connect('localhost', 'root', '', 'opc');

o = OpcListener();
o.connect('localhost', 'S7200.OPCServer');
%o.connect('localhost', 'M2MOPC.OPC.1');
%o.listen('MSC:[test]DB1,*', 'log', @disp);
%o.listen('MSC:[RemSt_1]DB1,REAL2210', 'log', @disp);
%o.listen('MSC:[RemSt_1]DB1,REAL2210', 'log', @disp);
%count = o.bind('MicroWin.NewPLC.*', 'Read', @disp);
count = o.bind('MicroWin.NewPLC.*');
o.bindglobal('Read', @logger.log);
o.bindglobal('ReadError', @disp);
%disp('Added item count:');
%disp(count);
o.run();