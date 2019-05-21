nuum = xlsread('ToLetter.xls'); %filecontaining only the numerical values of notes

nuum = round(nuum);

for ii = 1:length(nuum),
   tres = nuum(ii);
   if ~isnan(tres),if ~isempty(tres),
       if tres > 89
           Results{ii} = 'A+'; nResults(ii) = 4.3;
       else
            if tres > 84,
               Results{ii} = 'A';nResults(ii) = 4;
            else
                if tres > 79,
                    Results{ii} = 'A-';nResults(ii) = 3.7;
                else
                    if tres > 76,
                        Results{ii} = 'B+';nResults(ii) = 3.3;
                    else
                        if tres > 72,
                            Results{ii} = 'B';nResults(ii) = 3;
                        else
                            if tres > 69,
                                Results{ii} = 'B-';nResults(ii) = 2.7;
                            else
                                if tres > 64,
                                    Results{ii} = 'C+';nResults(ii) = 2.3;
                                else
                                    if tres > 59,
                                            Results{ii} = 'C';nResults(ii) = 2;
                                    else
                                        if tres > 56,
                                            Results{ii} = 'C-';nResults(ii) = 1.7;
                                        else
                                            if tres > 53,
                                                Results{ii} = 'D+';nResults(ii) = 1.3;
                                            else
                                                if tres > 49,
                                                    Results{ii} = 'D';  nResults(ii) = 1; 
                                                else
                                                    if tres > 34,
                                                        Results{ii} = 'E';nResults(ii) = .5;
                                                    else
                                                        Results{ii} = 'F';nResults(ii) = 0;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
       end
       
       
   end;end
end

xlswrite('LettersGrade.xls',Results)
xlswrite('NumbersGrade', nResults)

%   90-100 A+
%   85-89  A
%   80-84  A-
%   77-79  B+
%   73-76  B
%   70-72  B-
%   65-69  C+
%   60-64  C
%   57-59  C-
%   54-56  D+
%   50-53  D
%   35-49 E
%   0-34  F
