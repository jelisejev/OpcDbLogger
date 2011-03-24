classdef OpcListener < handle
    %OPCLISTENER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=public)
        listeners
        da
    end
    
    properties (Access=public)
        pause = 1;
    end
    
    methods
        
        function connect(this, host, serverId)
            this.da = opcda(host, serverId);
            connect(this.da);
        end
        
        function listen(this, selector, eventType, callback)
            key = numel(this.listeners)+1;
            this.listeners(key).eventType = eventType;
            this.listeners(key).callback = callback;
            this.listeners(key).selector = selector;
        end
        
        function run(this)
            
            while(1)
                for i = 1:numel(this.listeners)
                    listener = this.listeners(i);

                    % find matching items
                    grp = addgroup(this.da, 'ListenGroup');
                    items = serveritems(this.da, listener.selector);                    
                    additem(grp, items);
                    
                    % no matching items found, try to force an item
                    if numel(items) == 0
                        additem(grp, listener.selector);
                    end

                    % trigger callbacks
                    items = read(grp);
                    for j = 1:numel(items)
                        item = OpcItem(items(j));
                        %listener.callback(items(j));
                        listener.callback(item, listener.eventType, this);
                    end

                    delete(grp);
                end
                
                pause(this.pause);
            end
            
            
            
        end
        
        
        function items = readRecursive(this, grp, tries)
            items = read(grp);
            disp(tries);
            if tries > 1 && isstruct(items) && numel(strfind(items(1).Quality, 'Bad')) > 0 
                tries = tries - 1;
                items = this.readRecursive(grp, tries);
            end
        end
    end
    
    
end
