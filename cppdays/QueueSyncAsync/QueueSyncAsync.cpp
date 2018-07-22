// QueueSyncAsync.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "QueueSyncAsync.h"
#include "QueueMgr.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object

CWinApp theApp;
	/*

			The Main parameters I have concentrated on this solution.
			1. Design considerations.
			2. How extensible this can be.
			3. Ease of Use. which is evident when you see the code in main()
			4. I have tried the mimic the .NET Delegates and Async Call.

			What are the things I would have loved to do.
			1. Provide variable parameter list.(right now it is limited to a single parameter)
			2. There are some not so elegant implementation which I would like to clean up.
			3. I have not tested it througly i am sure it would fail certain test cases.
			    what I wanted to achieve the code gives broad overview of what can be done.

			4. And couple more, once I do my code review i will get to know if there are some leaks left.


			*/


int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	int nRetCode = 0;

	HMODULE hModule = ::GetModuleHandle(NULL);

	if (hModule != NULL)
	{
		// initialize MFC and print and error on failure
		if (!AfxWinInit(hModule, NULL, ::GetCommandLine(), 0))
		{
			// TODO: change error code to suit your needs
			_tprintf(_T("Fatal Error: MFC initialization failed\n"));
			nRetCode = 1;
		}
		else
		{
			// TODO: code your application's behavior here.
			cout<<"**************Main thread : "<<GetCurrentThreadId()<<"**********************"<<endl;
			A* a = new A();
			Delegate<int,int> d1(a,&A::foo1);
			cout<<"****************Start of Sync Call*******************************"<<endl;
			cout<<"Main thread id : "<<GetCurrentThreadId()<<endl;
			cout<<"Return value : "<<d1(100)<<" back in main "<<endl;
			cout<<"****************End of Sync Call*******************************"<<endl;
			cout<<endl;
			cout<<endl;
			cout<<endl;
			cout<<"****************Start of ASync Call*******************************"<<endl;

			AsyncResult<int>* ar=d1.BeginInvoke(100); // Async Call

			cout<<"Returned immediately"<<endl;

			cout<<"waiting to get the result : "<<d1.EndInvoke(ar)<<"  back in main thread"<<endl; // Ofcourse this can be executed anywhere like another thread or after sleep of 5 to 10 secs
			delete ar;
			cout<<"****************End of ASync Call*******************************"<<endl;

			delete a;



		


			//sample<A,Method> d1(a,&A::foo1);
			//MethodCallback<int,int,A>* mc  = new MethodCallback<int,int,A>(a,&A::foo1);
			//CWorkQueueMgr<dummy,int>* pwqm = CWorkQueueMgr<dummy,int>::Instance();
			
			//pwqm->QueueIt(a);
			getchar();
		}
	}
	else
	{
		// TODO: change error code to suit your needs
		_tprintf(_T("Fatal Error: GetModuleHandle failed\n"));
		nRetCode = 1;
	}

	return nRetCode;
}
