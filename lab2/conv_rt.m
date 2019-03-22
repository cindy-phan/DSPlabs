function y = conv_rt(x, h)
    M = length(x) + length(h) -1;
    z = zeros(size(x));
    a = [h zeros(1, length(x) + length(h))];
    y = x;                     %The function operates very similar to the 
    for n = 1:M                %other convolve function; however, it uses a
        z = circshift(z,[1,1]);%circular buffer to accept input signals one
        z(1) = a(n);           %at a time.
        y(n) = sum(x.*z);
    end
end