{- 6.827 Problem Set 4, Problem 2.

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

import Array
import PHArray

data MQueue a = MQueue (MCell Int)       -- front
                       (MCell Int)       -- qsize
                       Int               -- buflen
                       (MArray Int a)    -- buffer

-- Part a:

makeQueue :: (Imperative a) => Int -> MQueue a


-- Part b:

enqueue :: (Imperative a) => MQueue a -> a -> MQueue a

testEnqueue :: 


-- Part c:

dequeue :: a -> MQueue a -> a

testDequeue :: 


-- Pard d:

-- testEnqueueDequeue returns the list of dequeued elements
testEnqueueDequeue :: MQueue Int -> Int -> [Int]




main = 
  let q = makeQueue 50
  in  
     print (testEnqueueDequeue q 25) >>= \_ ->
     print (testEnqueueDequeue q 25) >>= \_ ->
     print (testEnqueueDequeue q 51)
