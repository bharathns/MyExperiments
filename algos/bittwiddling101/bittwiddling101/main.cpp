//
//  main.cpp
//  bittwiddling101
//
//  Created by Bharath Nadampalli on 26/04/18.
//  Copyright © 2018 com.samples. All rights reserved.
//
//


#include <iostream>
#include <vector>
#include <math.h>
using namespace std;
#define MASK_01010101 (((unsigned int)(-1))/3)
#define MASK_00110011 (((unsigned int)(-1))/5)
#define MASK_00001111 (((unsigned int)(-1))/17)

#define TWO(c)     (0x1u << (c))
#define MASK(c) \
(((unsigned int)(-1)) / (TWO(TWO(c)) + 1u))
//#define COUNT(x,c) \
((x) & MASK(c)) + (((x) >> (TWO(c))) & MASK(c))

#define COUNT0(x) ((x & 0x55555555) + ((x >> 1) & 0x55555555))
#define COUNT1(x) ((x & 0x33333333) + ((x >> 2) & 0x33333333))
#define COUNT2(x) ((x & 0x0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F))
#define COUNT3(x) ((x & 0x00FF00FF) + ((x >> 8) & 0x00FF00FF))
#define COUNT4(x) ((x & 0x0000FFFF) + ((x >> 16) & 0x0000FFFF))

#define COUNT(x,c) \
COUNT##c(x)


void printBits(unsigned  n) {
    if (!n) {
        cout<<0;
    }
    while (n) {
        printf("%i, ", n & 0x01);
        n = n >> 1;
    }
    cout<<endl;
}
// Donald Knuth
//11010101

// int bitcount (unsigned int n) {
//     printBits(n);
//    n = (n & MASK_01010101) + ((n << 1) & MASK_01010101) ;
//     printBits(n);
//    n = (n & MASK_00110011) + ((n << 2) & MASK_00110011) ;
//     printBits(n);
//    n = (n & MASK_00001111) + ((n << 4) & MASK_00001111) ;
//     printBits(n);
//    return n % 255 ;
//}

//Nifty count
int bitcount (unsigned int n)  {
    n = COUNT(n, 0) ;
    n = COUNT(n, 1) ;
    n = COUNT(n, 2) ;
    n = COUNT(n, 3) ;
    n = COUNT(n, 4) ;
    /* n = COUNT(n, 5) ;    for 64-bit integers */
    return n ;
}

unsigned int count_bit(unsigned int x)
{
    cout<<endl;
    printBits(x);
    x = (x & 0x55555555) + ((x >> 1) & 0x55555555);
    printBits(x);
    x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
    printBits(x);
    x = (x & 0x0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F);
    printBits(x);
    x = (x & 0x00FF00FF) + ((x >> 8) & 0x00FF00FF);
    printBits(x);
    x = (x & 0x0000FFFF) + ((x >> 16)& 0x0000FFFF);
    printBits(x);
    return x;
}


vector<int> countBits(int num) {
    int count = 0;
    std::vector<int> countVec;
    while (count<=num) {
        countVec.push_back(bitcount (count));
        count++;
    }
    return countVec;
}
int isPowerOf2(unsigned int n) {
    unsigned int x = n;
    int isPowerOf2 = x && !(x & (x-1));
    cout<<"isPowerOf2 : "<<~x<<endl;
    printBits(~x);
    cout<<"isPowerOf2 + 1: "<<~x+1<<endl;
    printBits(~x+1);
    cout<<"isPowerOf2 + 1: "<<(x&(~x+1))<<endl;
    printBits((x&(~x+1)));
    return (n!=0) && ((x&(~x+1)) == n);
}

int add ( int a , int b) {
    cout<<"sum : ";
    printBits(a);
    cout<<"carry : ";
    printBits(b);
    
    if(b == 0)
        return a;
    int sum  = a ^ b;
    int carry = (a & b) << 1;
   
    return add (sum, carry);
}

int swapBit(unsigned int n, int i, int j) {
    cout<<"*********swap bits start************"<<endl<<endl;
    cout<<"Input: ";
    printBits(n);
    int delta  =  i > j ? (i - j) : (j-i);
    int y = (n >> delta) & (int)pow(2, j);

    int z = (n & (int)pow(2,j)) << delta;

    int m = (int)pow(2,j) | (int)pow(2,i);

    int x  = (n & ~m) | y | z;
    cout<<"Output: ";
    printBits(x);
    cout<<endl<<"************swap bits end**************"<<endl;
    return x;
}
unsigned int lowestBitSet(unsigned int n) {
    return n & ~(n-1);
}
unsigned int lowestZerothBit(unsigned int n) {
    return ~n & (n+1);
}

unsigned int closestIntWithSameWeightEx(unsigned int n){
    printBits(n);
    unsigned int zb=lowestZerothBit(n);
    unsigned int ob=lowestBitSet(n);
   
//    if (zb>ob){
//
//        n ^= (zb | (zb>>1)); //0000 1111 ^ 0001 1000 = 00010111
//    }
//    else{
//
//        n ^= (ob | ob>>1); // 0000 1010 ^ 0000 0011 = 0000 1001
//    }
    n ^= zb>ob ?(zb | (zb>>1)) : (ob | (ob>>1));
    printBits(n);
    return n;
}

unsigned int closestIntWithSameWeight(unsigned int n) {
    int i = 0;
    int tempn =n;
    while(n) {
        i++;
        int curBit =  n&1;
        n >>= 1;
        if(curBit != (n&1)) {
            break;
        }
    }
    return tempn ^ ((1U << i) | (1U << (i-1)));
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    int *p1,p2;
    p2 =100;
    cout<<"closestIntWithSameWeight : "<<closestIntWithSameWeightEx(8)<<endl;
    return 0;
    cout<<swapBit(11, 2, 0)<<endl; // assuming i > j
    //cout<<add(15,24)<<endl;
    return 0;
    int result = isPowerOf2(4);
    
    cout<<"result : "<<result<<endl;
    printf("%d \n", p2);
    cout<<(unsigned int)-1<<endl;
    cout<<UINT_MAX<<" : "<<UINT_MAX/3<<" : "<<UINT_MAX/5<<" : "<<UINT_MAX/17<<endl;
    
    //countBits(5);
    cout<<"count_bit : "<<count_bit(213) << endl;
    cout<< bitcount (213) <<endl;
    return 0;
}

