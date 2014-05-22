#!/bin/bash

export HOME=/home/xtong
export TEST=$HOME/test
export CORE=llvm-core

cd $HOME
rm -rf $TEST 
mkdir  $TEST 
cd $TEST

echo "O^O PERFORM: cloning LLVM tree"
git clone https://trent.tong@code.google.com/p/llvm-core/ 

cd $TEST/$CORE 

echo "O^O PERFORM: LLVM tree debug building using `which clang`"
./configure && make clean && make -j16
export PATH=$TEST/$CORE/Debug+Asserts/bin:$PATH

echo "O^O PERFORM: LLVM tree release built using `which clang`"
./configure --enable-optimized && make clean && make -j16
export PATH=$TEST/$CORE/Release+Asserts/bin:$PATH

echo "O^O PERFORM: Building helloworld with systemcall specialization using `which clang`"
clang -O3 -fsccore helloworld.c -o helloworld
./helloworld






 
