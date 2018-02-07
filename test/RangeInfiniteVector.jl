using Base.Test
import InfiniteVector

@testset "RangeInfiniteVector tests" begin
    for rep = 1:10
        a, b = sort(rand(-100:100, 2))
        vals = rand(length(a:b))
        def = rand()
        v = InfiniteVector.RangeInfiniteVector(a:b, def, vals)

        for i = a:b
            @test v[i] == vals[i - a + 1]
        end

        for r = 1 : 10
            i = rand(Int)
            if i < a || i > b
                @test v[i] == def
            else
                @test v[i] == vals[i - a + 1]
            end
        end

        i = rand(a:b)
        newv = rand()
        v[i] = newv
        @test v[i] == newv

        @test_throws BoundsError v[a - 1] = 1.
        @test_throws BoundsError v[b + 10] = 1.
    end
end