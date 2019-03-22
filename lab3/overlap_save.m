 function y = overlap_save(x, h, lc)
    % OVERLAP_SAVE	Convolve x and h using overlap-save method
    %               y = overlap_save(x, h, lc) 
    %               x and h are arrays, 
    %               lc is the chunk size (default 50)

    N = lc;         % N is length of chunk
    M = length(h);  % M is impulse response length

    if(N>=length(x))
        N = length(x);
        y = conv(x(1:N),h);
    else
        
        y = conv(x(1:N),h);
        y = y(1:end-(M-1));
        x = x(N-(M-1)+1:end);

        while(length(x) > N)
            xdiv = x(1:N);
            next = conv(xdiv,h);
            y = horzcat(y(1:end), next(1+(M-1):end-(M-1)));
            x = x(N-(M-1)+1:end);
        end

        last = conv(x(1:end),h);
        y = horzcat(y(1:end), last(1+(M-1):end));
    end
 end