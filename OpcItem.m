classdef OpcItem
    %OPCITEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
    end
    
    methods
        function this = OpcItem(data)
            this.Data = data;
        end
        
        % checks whether the signal quality is bad
        function bad = isbad(this)
            bad = numel(strfind(this.Data.Quality, 'Bad')) > 0;
        end
        
        function timestamp = timestamp(this, format)
            timestamp = datestr(this.Data.TimeStamp, format);
        end
    end
    
end

