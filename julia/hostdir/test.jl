using LinerAlgebra
function generate(n,c)
    A=Matrix(I,n,n)
    for i 1:n
        for j 1:n
            if i==j
                A[i,j]+=1
              elseif |i-j|==1
                A[i,j]-=1
            end
        end
    end
    A[1,1]=c
    return A
end
