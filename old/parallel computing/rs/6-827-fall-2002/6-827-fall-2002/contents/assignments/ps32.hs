{- 6.827 Problem Set 3, Problem 2.

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

import Array
import PHArray
import Complex

{- 

Your main job in this problem will be to incrementally replace array
indexing and the array data types with indexing operations and types
of your own.  

-}

type ComplexVector = Array Int (Complex Float)

twoPi :: Float
twoPi = 2.0 * pi

rotate90 :: RealFloat a => Complex a -> Complex a
rotate90 (a:+b) = b:+(-a)

-- pick elements out of given vector for recursive ffts.
-- Normalizes bounds to 1.
shuffle :: ComplexVector -> (ComplexVector, ComplexVector)
shuffle v =
  let bnds@(l,u) = bounds v
      size = sizeRange bnds
      halfsize = size `div` 2
  in (array (1,halfsize) [ (i, v!(i*2+l-2)) | i <- [1..halfsize]],
      array (1,halfsize) [ (i, v!(i*2+l-1)) | i <- [1..halfsize]])

fft :: ComplexVector -> ComplexVector -> ComplexVector
fft v roU =
  let bnds = bounds v
      size = sizeRange bnds
  in  if (size == 4) then
        let [i1,i2,i3,i4] = range bnds
            l1 = v!i1 + v!i3
            l2 = v!i1 - v!i3
            r1 = v!i2 + v!i4
            r2 = v!i2 - v!i4
            r2' = rotate90 r2
        in array bnds 
             [(i1, l1 + r1),
              (i2, l2 + r2'),
              (i3, l1 - r1),
              (i4, l2 - r2')]
      else
        let (left_v, right_v) = shuffle v
            fft_left          = fft left_v  roU
            fft_right         = fft right_v roU
        in combine fft_left fft_right roU

-- combine recursively fft'd arrays.  Assumes their bounds came from "shuffle".
-- Note how the final comprehension generates two array elements at a time.
combine :: ComplexVector -> ComplexVector -> ComplexVector -> ComplexVector
combine u v roU =
  let bnds@(1,m) = bounds u
      (1,n)      = bounds roU
      index      = n `div` m
  in array (1, 2*m) [ element | i <- [1..m],
                                vprod <- [roU!((i-1)*index + 1) * v!i],
                                element <- [(i,   u!i + vprod), 
                                            (m+i, u!i - vprod)]]

-- computeRoots computes the nth roots of 1 and forms the array roU used above.
computeRoots :: Int -> ComplexVector
computeRoots n =
  let theta = -twoPi / (fromInt n)
      halfn = n `div` 2
      wprWpi = (-2.0) * (sin (0.5 * theta) ^ 2) :+ sin theta
      roU = array (1,halfn) ([(1, 1.0:+0.0)]
                             ++ [(i, wprWpi * roU!(i-1) + roU!(i-1)) | i <- [2..halfn]])
  in roU



-- Some possible inputs to FFT
test1FFT n =
  let c = array (1,n) [(i, fromInt i * 1.0 :+ 0.0) | i <- [1..n]]
  in fft c (computeRoots n)

constFFT n =
  let c = array (1,n) [(i,10.0) | i <- [1..n]]
  in fft c (computeRoots n)

rotFFT n m =
  let c = array (1,n) [(i, cos theta :+ sin theta) |
			i <- [1..n],
			theta <- [fromInt (i-1) * twoPi / fromInt m]]
  in fft c (computeRoots n)

-- throw away all but four decimal places in answer so that it's readable.
nicely a = array (bounds a) 
		[(i, a:+b) | (i,x:+y) <- assocs a, 
			     a <- [fourDec x],
			     b <- [fourDec y]]

fourDec x = (fromIntegral $ round $ x*10000.0) / 10000.0


main = (print . nicely) (test1FFT 64) >>
       (print . nicely) (constFFT 64) >>
       (print . nicely) (rotFFT 64 32)
