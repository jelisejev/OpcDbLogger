classdef OpcItem
    %OPCITEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods
        function this = OpcItem(data)
            this.data = data;
        end
        
        % checks whether the signal quality is bad
        function bad = isBad(this)
            bad = numel(strfind(this.data.Quality, 'Bad')) > 0;
        end
        
        function timestamp = timestamp(this, format)
            timestamp = datestr(this.data.TimeStamp, format);
        end
    end
    
end

