function y = overlap_add(x, h, lc)
    % OVERLAP_ADD   Convolve x and h using overla-add method
    %               y = overlab_add(x, h, lc)
    %               x and h are arrays
    %               lc is the chunk size (default 50)

    N = lc;         % N is length of chunk
    M = length(h);  % M is impulse response length
    numOfChunks = ceil(length(x)/lc);

    if(N>length(x))
        N = length(x);
    end

    y = conv(x(1:N),h);
    x = x(N+1:end);

    for i = 1:numOfChunks-1
        if length(x) >= N
            xdiv = x(1:N);
        else
            xdiv = x(1:end);
        end

        next = conv(xdiv, h);
        overlap = y(end-(M-1)+1:end) + next(1:M-1);
        y = horzcat(y(1:end-(M-1)), overlap, next((M-1)+1:end)); 
        x = x(N+1:end);
    end

end