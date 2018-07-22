//
//  ThreadFunctions.cpp
//  NSThreadAnatomy2
//
//  Created by Bharath Nadampalli on 22/02/17.
//  Copyright © 2017 EMC. All rights reserved.
//

#include <stdio.h>
#include <pthread.h>


int getThreadId() {
    return pthread_mach_thread_np(pthread_self());
}
