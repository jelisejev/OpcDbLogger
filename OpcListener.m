classdef OpcListener < handle
    %OPCLISTENER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        Listeners
        GlobalListeners = struct('Read', [], 'ReadError', [])
        Da
        Grp
        ReadTimeout = 10
        AddTimeout = 10
    end
    
    properties
        Pause = 1;
    end
    
    methods
        
        % establishes a connection with a server
        function connect(this, host, serverId)
            this.Da = opcda(host, serverId);
            this.Da.Timeout = this.AddTimeout;
            connect(this.Da);
            this.Grp = addgroup(this.Da, 'OpcListenerGroup');
        end
        
        
        % adds an item to the listener group
        % optionally binds a callback function
        %
        % varargin = [eventType, callback]
        function nItems = bind(this, selector, varargin)
            
            % add items to the group
            items = this.additems(selector);
            
            % add item listeners if specified
            if nargin > 2
                for i = 1:numel(items)
                    this.additemcallback(items{i}, varargin{1}, varargin{2});
                end
            end
            
            % return the number of added items
            nItems = numel(items);
        end
        
        
        % binds a global event
        function bindglobal(this, eventType, callback)
            if isfield(this.GlobalListeners, eventType) == false
                this.GlobalListeners.(eventType) = [];
            end
            
            % add event callback
            i = length(this.GlobalListeners.(eventType)) + 1;
            this.GlobalListeners.(eventType){i} = callback;       
        end
        
        
        % starts listening to item events
        function run(this)
            
            % set the read timeout
            this.Da.Timeout = this.ReadTimeout;
            
            while(1)

                % try to read items and trigger the callbacks
                try
                    items = read(this.Grp);
                    for j = 1:numel(items)
                        item = OpcItem(items(j));
                        listener = this.Listeners.(genvarname(item.Data.ItemID));

                        %trigger the global Read event
                        this.trigger('Read', this.GlobalListeners.Read, item);

                        % trigger the Read event
                        this.trigger('Read', listener.Read, item);
                    end
                catch exception
                    
                    % a stop exception, exit quitely
                    if numel(strfind(exception.identifier, 'OpcListener:stop')) > 0;
                        break;
                    end                    
                    
                    % ctrl + c exception, rethrow it and don't trigger any
                    % more callbacks
                    if numel(strfind(exception.identifier, 'ctrlc')) > 0;
                        rethrow(exception);
                    end
                    
                    % trigger the global ReadError event
                    this.trigger('ReadError', this.GlobalListeners.ReadError, exception);
                    
                end
                    
                pause(this.Pause);
            end    
            
            delete(this.Grp);
                        
        end
    end
    
    methods (Access=private)
        
        function items = additems(this, selector)
            
            % add items that match a selector
            items = serveritems(this.Da, selector);
            if numel(items) > 0
                additem(this.Grp, items);
            % no matching items found, try to force an item
            else
                additem(this.Grp, selector);
                items = {selector};
            end
            
            % create item structures
            for i = 1:numel(items)
                itemId = items{i};
                key = genvarname(itemId);
                if isfield(this.Listeners, key) == false
                    
                    % define available events
                    this.Listeners.(key) = struct('Read', []);
                end
            end
        end
        
        
        function additemcallback(this, itemId, eventType, callback)
            
            % generate a valid varname
            key = genvarname(itemId);
            
            % add event callback
            i = length(this.Listeners.(key).(eventType)) + 1;
            this.Listeners.(key).(eventType){i} = callback;           
        end
        
        
        % for the ReadError event data is and instance of MException
        % for all other events and instance of OpcItem will be passed
        function trigger(this, eventType, callbacks, data)
            for i = 1:length(callbacks)
                callbacks{i}(data, eventType, this);
            end
        end
        
    end
    
end
