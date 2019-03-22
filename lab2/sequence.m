classdef sequence
	properties               %This first section of code was given
		data                 %and identifies a sequence as a new
		offset               %Matlab structure.
	end

	methods
		function s = sequence(data, offset)
			s.data = data;
			s.offset = offset;
		end

		function display(s)      %The display portion of the code is
			var = inputname(1);  %only there to make the output of
			if (isempty(var))    %sequence data more compact and
				disp('ans =');   %readable.
			else
				disp([var '=']);
			end
			switch length(s.data)
				case 0
					disp('    data: []')
				case 1
					disp(['    data: ', num2str(s.data)])
				otherwise
					disp(['    data: [' num2str(s.data) ']'])
			end
			disp(['  offset: ' num2str(s.offset)])
		end

		function y = flip(x)
			% FLIP Flip a Matlab sequence structure, x, so y = x[-n]
            z = x.data;      %Declare a new array.
            z(1:length(x.data)) = x.data(end : -1 : 1);
                             %This code stores the sequence into the array
                             %in the opposite order.
            y = sequence(z, -(x.offset + length(x.data) - 1));
                             %The sequence is reconstructed with a new
        end                  %offset based on the length and offset of
		                     %the original sequence.
		function y = shift(x, n0)
			% SHIFT Shift a Matlab sequence structure, x, by integer amount n0 so that y[n] = x[n - n0]
            nf = x.offset + n0;       %This finction simply adds a shift value
            y = sequence(x.data, nf); %to the offset and reconstructs the
        end                           %sequence.

        function y = trim(x)             %This function was designed to
            indices = find(x.data);      %remove zeros from the upper and
            x.data(1:indices(1)-1) = []; %lower bounds of a sequence.
            x.data(indices(end) - indices(1) + 2 : end) = [];
            offset = x.offset + indices(1) - 1;
            y = sequence(x.data, offset);
        end

		function z = plus(x, y)
			% PLUS  Add x and y. Either x and y will both be sequence structures, or one of them may be a number.
            if(isa(x, 'sequence') & isa(y, 'sequence'))
                offset = 0;                 %Before two arrays can be added
                lpad = x.offset - y.offset; %they have to be padded with zeros
                                            %so they share the same length
                                            %and offset.
                rpad =  length(y.data) + y.offset - length(x.data) - x.offset;
                seq1 = [zeros(1, lpad) x.data zeros(1, rpad)];
                seq2 = [zeros(1, -lpad) y.data zeros(1, -rpad)];
                data = seq1 + seq2;    %the arrays can be added easily when
                if(x.offset < y.offset)%they are the same size.
                    offset = x.offset;
                else                   %Next the larger offset has to be
                    offset = y.offset; %found to be used in forming the
                end                    %resultant sequence.
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0); %Finally the sequence is trimmed
                else                    %and reconstructed. The if statement
                                        %is for the unlikely case that the
                    z = trim(sequence(data, offset));%resultant sequence is
                end                                  %null.
            elseif(isa(x, 'float'))
                data = y.data + x;   %If one of the inputs is a scalar instead
                                     %of a sequence a different code is
                                     %used.
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0); %This code is very simple since
                else                    %the scalar can just be added to
                    z = trim(sequence(data, y.offset));%all the elements
                end                     %of the data portion of the sequence.
            else
                data = x.data + y;
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, x.offset));
                end
            end

		end

		function z = minus(x, y)
			% MINUS Subtract x and y. Either x and y will both be sequence structures, or one of them may be a number.
            % The minus function is the same as the plus function, but the
            % second element in the array needs to be inverted.
            if(isa(x, 'sequence') & isa(y, 'sequence'))
                yneg = y.data .* -1;
                negseq = sequence(yneg, y.offset);
                z = x + negseq;
            elseif(isa(x, 'float'))
                data = -1 .* y.data + x;
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, y.offset));
                end
            else
                data = x.data - y;
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, x.offset));
                end
            end
		end

		function z = times(x, y)
			% TIMES Multiply x and y (i.e. .*) Either x and y will both be sequence structures, or one of them may be a number.
            % Multiplying is again very similar to the plus function, but
            % using the .* operator.
            if(isa(x, 'sequence') & isa(y, 'sequence'))
                offset = 0;
                lpad = x.offset - y.offset;
                rpad =  length(y.data) + y.offset - length(x.data) - x.offset;
                seq1 = [zeros(1, lpad) x.data zeros(1, rpad)];
                seq2 = [zeros(1, -lpad) y.data zeros(1, -rpad)];
                data = seq1 .* seq2;
                if(x.offset < y.offset)
                    offset = x.offset;
                else
                    offset = y.offset;
                end
                if (sum(data) == 0)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, offset));
                end
            elseif(isa(x, 'float'))
                data = y.data .* x;
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, y.offset));
                end
            else
                data = x.data .* y;
                if (sum(data) == 0) == length(data)
                    z = sequence(0, 0);
                else
                    z = trim(sequence(data, x.offset));
                end
            end
		end

		function stem(x)
			% STEM Display a Matlab sequence, x, using a stem plot.
            % Finally it is important to create a function for plotting the
            % results. This function simply creates the appropriate
            % abscissa using the ofset of the sequence.
            m = x.offset : x.offset + length(x.data) - 1 ;
            stem(m, x.data, 'filled');
            axis tight
            xlim([(m(1) - 1) (m(end)+1)]);
            ylim([(min(x.data) - 1) (max(x.data) + 1)]);
        end
        
        function y = even(x)
            %EVEN take matlab sequence object, x, which is possibly
            %complex, and create a matlab sequence structure, y, that
            %corresponds to the even part.
            y = times(0.5, plus(x, flip(x)));            
        end
        
        function y = odd(x)
            %ODD take matlab sequence object, y, which is possibly complex,
            %and create a matlab sequence structure, y, that corresponds to
            %the odd part.
            y = times(0.5, minus(x, flip(x)));
        end
        
        %This code performs convolution using the flip and shift method 
        %shown in the notes.
        function y = conv(x, h)       
            xarr = x.data;  %These variables hold the sequence array data.          
            harr = h.data;  %This is important so the commutativity
                            %property of convolution can be used to
                            %minimizethe matrix size.
            lx = length(x.data); %The length of each sequence is stored to     
            lh = length(h.data); %use in determining the size of the matrix.
            if(lx > lh)       %This if statement is used to identify the       
                xarr = h.data;%shorter sequence. This is critical in deciding
                harr = x.data;%how to perform the convolution operation.
                lx = length(h.data);
                lh = length(x.data);
            end
            hmat = zeros(lx, lh + lx - 1);%A zeros matrix is formed using the
            for(i = 1 : lx)               %lengths of the sequences. The for
                    hmat(i, i : i + lh -1) = harr;%loop populates the matrix
            end                           %with the appropriate sequence data.
            y = sequence(xarr*hmat, x.offset + h.offset);
        end
        
        
        %This function reverses the convolution operation given the result
        %and the transfer function.
        function x = deconv(y,h)  %order matters for the inputs here.
            len = length(y.data) - length(h.data) +1;%determines the size of
                     %the resulting sequence.
            y.data = y.data(1:len);%Any values of why can be chosen, but using
                                   %the first elements makes it simpler to
                                   %build the appropriate matrix.
            a = zeros(len, len);
            for n = 1:len
                b = [zeros(1, n-1) h.data zeros(1, len - (n-1))];
                a(n, 1:len) = b(1:len);
            end
        	x.data = y.data/a;%The y-values are multiplied by the inverse
                              %of the h-matrix.
            x = sequence(x.data, y.offset - h.offset);
        end                   %The sequence is built with the new array
                    %and the difference of the input offsets.
                                    
    end
    
end

