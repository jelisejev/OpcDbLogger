clear;
import java.util.*;
mysql('closeall');

logger = OpcDbLogger();
%logger.connect('dzin.datateks.lv', 'plc', 'LkxF5Vug', 'plc');
logger.connect('localhost', 'root', '', 'opc');

o = OpcController();
o.connect('localhost', 'M2MOPC.OPC.1');
%count = o.bind('MicroWin.NewPLC.*', 'Read', @disp);
count = o.bind('MSC:[PLC]DB1,B4500');
count = o.bind('MSC:[PLC]DB1,B4502');
o.bindglobal('Read', @logger.log);
o.run();