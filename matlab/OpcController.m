classdef OpcController < OpcListener
    
  methods
      function write(this, target, value)
          grp = addgroup(this.Da, 'OpcControllerWrite');
          additem(grp, target);
          write(grp, value);
          removepublicgroup(this.Da, 'OpcControllerWrite');
      end
      
  end
    
end
