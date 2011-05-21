classdef OpcDbLogger < handle
    %OPCLISTENER Summary of this class goes here
    %   Detailed explanation goes here
    % http://www.kxcad.net/cae_MATLAB/toolbox/opc/ug/f6-6042.html
       
    properties (Access=public)
        Conn
    end
    
    methods
        
        % connects to the database
        function connect(this, host, user, password, db)
            this.Conn = mysql('open', host, user, password);
            this.use(db);
        end
        
        % choose a database
        function use(this, db)
            db = mysql(this.Conn, 'use', db);
        end
        
        % save date to the database
        function log(this, opcItem, eventType, opcListener)
            %throw(MException('OpcListener:stop', 'stop, please'));
            
            data = opcItem.Data;
            disp(data);
            % format timestamp
            time = opcItem.timestamp('yyyy-mm-dd HH:MM:SS');
            
            % escape all the data
            value = this.escape(num2str(data.Value));
            itemId = this.escape(data.ItemID);
            quality = this.escape(data.Quality);
            error = this.escape(data.Error);
            
            % insert data
            query = ['INSERT INTO PlcLog (item, value, quality, timestamp, error, service) VALUES ("', itemId, '","', value, '","', quality, '","', time, '","', error, '","matlab");'];
            mysql(this.Conn, query);
        end
    end
    
    
    methods (Access=private)
        
        % escape special mysql characters with "\"
        function v = escape(this, v)
            v = strrep(v, '\', '\\');
            v = strrep(v, '"', '\"');
            v = strrep(v, char(39), ['\',char(39)]);
        end
    end
    
    
end
