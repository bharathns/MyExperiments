
## CONSOLE APPLICATION : QueueSyncAsync Project Overview

The Main parameters I have concentrated on this solution.

	1. Design considerations.
	2. How extensible this can be.
	3. Ease of Use. which is evident when you see the code in main()
	4. I have tried the mimic the .NET Delegates and Async Call.
            
What are the things I would have loved to do.

	1. Provide variable parameter list using varadic templates.(right now it is limited to a single parameter)
	2. There are some not so elegant implementation which I would like to clean up.
	3. Port this code to cross platform
	
### Code Usage
	A* a = new A();
	Delegate<int,int> d1(a,&A::foo1);
	
	// The following would be a sync call
	d1(100);
	
	// The following would be an async call
	AsyncResult<int>* ar=d1.BeginInvoke(100); // Async Call returns immediately
        d1.EndInvoke(ar); // can wait to get the result.
	

