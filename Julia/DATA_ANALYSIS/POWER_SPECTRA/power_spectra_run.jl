include("power_spectra_modules.jl")

import Main.PowerSpectra

println("Rodando power_spectra_run.jl")

mkpath("DATA/POWER_SPECTRA_STATIONARY")
mkpath("DATA/POWER_SPECTRA_STATIONARY_FIT")

mVectorSizes = [180, 2100]
MaxRand = 10
maximumBlockSize =  5
types = ["Random", "Prime", "Even", "Odd", "Pascal", "Oscilatory", "Linear"]

function main()
    i = 0
    Threads.@threads for type in types
        mkpath("DATA/POWER_SPECTRA_STATIONARY/PS_$(type)")
        mkpath("DATA/POWER_SPECTRA_STATIONARY_FIT/PS_FIT_$(type)")
        i += 1
        println("$(type), $(i/length(types))")
        if type == "Linear"
            BlockSizes = range(3,60, step = 1)
            logsum = 2000
            for BlockSize in BlockSizes
                epsilon = BlockSize*(BlockSize+1)/2
                mVectorSize = round(Int, logsum*BlockSize/epsilon)
                PowerSpectra.savingpowerspectrum(mVectorSize, MaxRand, BlockSize; type)
                PowerSpectra.savingfitPowerSpectra(mVectorSize, MaxRand, BlockSize; type)
            end
        elseif type == "Pascal"
            mVectorSize = 180
            BlockSizes = range(2, 6, step = 1)
            for BlockSize in BlockSizes
                PowerSpectra.savingpowerspectrum(mVectorSize, MaxRand, BlockSize; type)
                PowerSpectra.savingfitPowerSpectra(mVectorSize, MaxRand, BlockSize; type)
            end
        elseif type == "Oscilatory"
            logsum = 3000
            BlockSizes = range(2, 100, step = 2)
            for BlockSize in BlockSizes
                epsilon = round(Int,BlockSize^2/4+BlockSize)
                mVectorSize = round(Int, logsum*BlockSize/epsilon)
                PowerSpectra.savingpowerspectrum(mVectorSize, MaxRand, BlockSize; type)
                PowerSpectra.savingfitPowerSpectra(mVectorSize, MaxRand, BlockSize; type)
            end
        else
            for mVectorSize in mVectorSizes
                for j in 2:maximumBlockSize
                    BlockSize = j
                    PowerSpectra.savingpowerspectrum(mVectorSize, MaxRand, BlockSize; type)
                    PowerSpectra.savingfitPowerSpectra(mVectorSize, MaxRand, BlockSize; type)
                end
            end
        end
    end
end

main()
