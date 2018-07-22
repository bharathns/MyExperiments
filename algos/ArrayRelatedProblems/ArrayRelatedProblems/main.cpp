//
//  main.cpp
//  ArrayRelatedProblems
//
//  Created by Bharath on 23/06/18.
//  Copyright © 2018 Bharath. All rights reserved.
//

#include <iostream>
#include <vector>
#include <stack>
using namespace std;
struct abc {
    int diff;
    
};
pair<int,int> findMinMax(vector<int> &arr) {
    int min  = arr[0];
    int max  = 0;
    for(int i=0;i<arr.size();i++) {
        if (min>arr[i])
            min = arr[i];
        if (max<arr[i])
            max  = arr[i];
    }
    return make_pair(min, max);
}
pair<int,int> unwind(stack<int>& stack, int target) {
    int max = 0;
    int sum = 0;
    int count = 0;
    int prev = stack.top();
    while(!stack.empty()) {
        if(stack.top() > target) {
            int temp = stack.top();
            stack.pop();
            if(prev==temp) {
                sum += temp;
                prev = temp;
            }else {
                sum = 0;
                sum += (temp * count);
                sum += temp;
            }
            if(max<sum) max = sum;
        }
        else
            break;
        count++;
    }
    return make_pair(max,count);
}
int findMaxRectangle(vector<int> &a) {
    //pair<int,int> mm  = findMinMax(a);
    int n  = (int)a.size();
    if (!n)  return 0;
    int i = 1;
    int max =0;
    stack<int> stack;
    stack.push(a[0]);
    while(n>i) {
        if(stack.top() <= a[i]) {
            stack.push(a[i]);
        }else { // unwind
            int sum = 0;
            int count = 0;
            
            while(!stack.empty()) {
                int temp = stack.top();
                if(a[i]>temp) {
                    break;
                }else {
                    pair<int,int> ret = unwind(stack, a[i]);
                    if(max<ret.first) max = ret.first;
                    count = ret.second+1;
                    break;
                }
            }
            if(max<sum) max = sum;
            while(count!=0) {
                stack.push(a[i]);
                count--;
            }
            count=0;
        }
        i++;
    }
    if(max == 0 || !stack.empty()) {
        pair<int,int> ret = unwind(stack, 0);
        if(max< ret.first) max =  ret.first;
    }
    return max;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    vector<int> arr = {5,4,1,2};//{2,0,1,0,1,0};//{2,1,2};//{2,1,5,6,2,3};
    cout<<findMaxRectangle(arr)<<endl;
    return 0;
}
