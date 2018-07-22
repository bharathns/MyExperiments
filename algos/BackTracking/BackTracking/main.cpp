//
//  main.cpp
//  BackTracking
//
//  Created by Bharath on 16/06/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#include <iostream>
#include <string>
#include <stdlib.h>
#include <vector>
#include <unordered_map>
#define MAKEVECTOR(TYPE, ROWSIZE, COLSIZE, VECTORNAME) vector<vector<TYPE> > VECTORNAME((ROWSIZE), vector<TYPE>(COLSIZE));

using namespace std;

void printBinary(int noOfBits, string s="") {
    if(noOfBits == s.length()) {
        cout<<s<<endl;
    }else  {
        printBinary(noOfBits, s+"0");
        printBinary(noOfBits, s+"1");
    }
}

void printBinaryWithKBitsSet(int noOfBits, int kSetBits, string s="") {
    if(noOfBits == s.length()) {
        if (kSetBits == std::count(s.begin(), s.end(), '1')) {
            cout<<s<<endl;
        }
    }else  {
        printBinaryWithKBitsSet(noOfBits, kSetBits, s+"0");
        printBinaryWithKBitsSet(noOfBits, kSetBits, s+"1");
    }
}

void indent(int size,string s) {
    for (int i=0; i<size; i++) {
        cout<<"\t";
    }
    cout<<s<<endl;
}

void printDecimal(int noOfBits, string s = "") {
    if(noOfBits == s.length()) {
        cout<<s<<endl;
    }else  {
        for (int i=0; i<10; i++) {
            printDecimal(noOfBits, s+to_string(i));
        }
    }
}

void permuteString(string s, string choosen="") {
    static int i=0;
    if (s.length() == 0) {
        cout<<i++<<" : "<<choosen<<endl;
        return;
    }else {
        for (int i=0; i<s.length(); i++) {
            char c =  s[i];
            choosen += c;
            s.erase(i,1);
            permuteString(s, choosen);
            s.insert(i,1,c);
            choosen.erase(choosen.length()-1,1);
        }
    }
}

void printVector(vector<int> print) {
    cout<<"{";
    std::for_each(
                  print.begin(), print.end(),
                  [&](auto&& x){ std::cout << x << ','; });
    cout<<"}"<<endl;
}
void printSubsets(vector<int> &given,vector<int> &subset) {
    if (given.size()==0) {
        printVector(subset);
        return;
    }
    for (auto iter=given.begin(); iter != given.end(); iter++) {
        vector<int> newVec(iter+1, given.end());
        subset.push_back(*iter);
        printSubsets(newVec, subset);
        subset.pop_back();
    }
    printVector(subset);
}

void printDice(int dice, vector<int>& choosen) {
    
    if(dice==0) {
        printVector(choosen);
        return;
    }else  {
        for(int i=1;i<=6;i++) {
            choosen.push_back(i);
            printDice(dice-1, choosen);
            choosen.pop_back();
        }
    }
}
void rollDice(int dice) {
        vector<int> vec = {};
        printDice(dice, vec);
}

void rollDiceWithSumHelper(int dice, int desiredSum, int sumSoFar, vector<int>& choosen){
    static int i=0;
    if(dice==0) {
        cout<<++i<<" : ";
        printVector(choosen);
        return;
    }else  {
        for(int i=1;i<=6;i++) {
            if (sumSoFar + i + 1*(dice-1) <= desiredSum &&
                sumSoFar + i + 6*(dice-1) >= desiredSum ) {
                choosen.push_back(i);
                rollDiceWithSumHelper(dice-1,desiredSum, sumSoFar + i, choosen);
                choosen.pop_back();
            }
        }
    }
}
void rollDiceWithSum(int dice, int sum){
    vector<int> vec = {};
    rollDiceWithSumHelper(dice, sum, 0, vec);
    
}

bool isRowClear(int row, vector<vector<int> >& chessBoard) {
    //cout<<"******* isRowClear *********"<<endl;
    for (int col = 0;col< chessBoard.size();col++) {
        if (chessBoard[row][col]==1) {
            return false;
        }
    }
    return true;
}

bool isColClear(int col, vector<vector<int> >& chessBoard) {
    //cout<<"******* isColClear *********"<<endl;
    for (int row = 0;row< chessBoard.size();row++) {
        if (chessBoard[row][col]==1) {
            return false;
        }
    }
    return true;
}

bool isDiagonalClear(pair<int, int> square, vector<vector<int> >& chessBoard) {
    
    //cout<<"******* isDiagonalClear *********"<<endl;
    int col = square.second;
    int row = square.first;
    for (; row>=0 && col >= 0; row--, col--) {
        cout<<"row : "<<row<<" : col : "<<col<<endl;
        if(chessBoard[row][col]) {
            return false;
        }
    }
    //cout<<"****************"<<endl;
    col = square.second;
    row = square.first;
    for (; row < chessBoard.size() && col >= 0; row++, col--) {
        cout<<"row : "<<row<<" : col : "<<col<<endl;
        if(chessBoard[row][col]) {
            return false;
        }
    }
    //cout<<"****************"<<endl;
    col = square.second;
    row = square.first;
    for (; row >=0 && col < chessBoard.size(); row--, col++) {
        cout<<"row : "<<row<<" : col : "<<col<<endl;
        if(chessBoard[row][col]) {
            return false;
        }
    }
    //cout<<"****************"<<endl;
    col = square.second;
    row = square.first;
    for (; row < chessBoard.size() && col < chessBoard.size(); row++, col++) {
        cout<<"row : "<<row<<" : col : "<<col<<endl;
        if(chessBoard[row][col]) {
            return false;
        }
    }
    return true;
}

bool isValidSquare(pair<int, int> square, vector<vector<int> >& chessBoard) {
    if (isRowClear(square.first, chessBoard)
        && isColClear(square.second, chessBoard)
        && isDiagonalClear(square, chessBoard)) {
        cout<<"isValid Square"<<endl;
        return true;
    }
    return false;
}

bool solveNQueenHelper(vector<vector<int> > &chessBoard, int col) {
    if (col >= chessBoard.size()) return true;
    for (int row = 0; row < chessBoard.size(); row++) {
        pair<int,int> square = make_pair(row,col);
        if(isValidSquare(square, chessBoard)) {
            chessBoard[row][col] = 1; // add Queen to square and try next
            if(solveNQueenHelper(chessBoard, col+1)) return true;
            chessBoard[row][col] = 0; // remove Queen from previous square and backtrack
        }
    }
    return false;
}

void printBoard(vector<vector<int> > &chessBoard) {
    for (int row=0; row<chessBoard.size(); row++) {
        for (int col =0; col<chessBoard.size(); col++) {
            cout<<chessBoard[row][col]<<" ";
        }
        cout<<endl;
    }
}
bool solveNQueen(int N) {
    MAKEVECTOR(int, N, N, chessBoard)
    pair<int,int> square = make_pair(3,2);
    auto start = chrono::steady_clock::now();

    solveNQueenHelper(chessBoard, 0);
    auto end = chrono::steady_clock::now();
    auto diff = end - start;
    cout << chrono::duration <double, milli> (diff).count() << " ms" << endl;
    cout<<"******* printBoard *********"<<endl;
    printBoard(chessBoard);
    return false;
}

    void reverseWords(vector<char>& str) {
        //reverse(str.begin(), str.end());
        vector<int> indexVec = {};
        cout<<str.size()<<endl;
        vector<char>::iterator startIt = str.begin();
        vector<char>::iterator endIt = str.end();
        while (startIt < endIt) {
            
            char temp = *startIt;
            *startIt = *endIt;
            *endIt = temp;
            cout<<*startIt<<" : "<<*endIt<<endl;
            if(*startIt == ' ') indexVec.push_back(startIt- str.begin());
            if(*endIt == ' ') indexVec.push_back(endIt- str.begin());
            startIt++;
            endIt--;
        }
        //cout<<str<<endl;
        std::sort(indexVec.begin(), indexVec.end(),
                  [] (int const& a, int const& b) { return a < b; });
        //cout<<indexVec<<endl;
    }

static vector<string> tens = {"hunderd", "thousand", "million", "billion"};

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    printBinary(4);
    cout<<endl;
    printBinaryWithKBitsSet(4,1);
    cout<<endl;
    printDecimal(2);
    cout<<endl;
    permuteString("ABC");
    cout<<endl;
    std::vector<int> v = {1, 2, 3};
    std::vector<int> subset = {};
    printSubsets(v,subset);
    cout<<endl;
    rollDice(2);
    cout<<endl;
    rollDiceWithSum(2,4);
    cout<<endl;
    solveNQueen(8);
    cout<<endl;
    vector<char> str= {'t','h','e',' ','s','k','y',' ','i','s',' ','b','l','u','e'};
    cout<<str.size()<<endl;
    reverseWords(str);
    return 0;
}

