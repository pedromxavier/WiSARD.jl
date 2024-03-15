function test_address()
    map = collect(1:9)
    wnn = WiSARD.WNN{Symbol}(3, 3, map)

    x = [1, 0, 0, 1, 0, 1, 0, 1, 0]

    @test WiSARD.address(wnn, x, 1) == WiSARD.WNNKEY{UInt}(1, UInt(1))
    @test WiSARD.address(wnn, x, 2) == WiSARD.WNNKEY{UInt}(2, UInt(5))
    @test WiSARD.address(wnn, x, 3) == WiSARD.WNNKEY{UInt}(3, UInt(2))

    return nothing
end