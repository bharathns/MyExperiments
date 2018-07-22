


#include "stdafx.h"
 
template<typename T,typename Ret,typename Param0>
class CWorkQueueMgr;

template <typename Ret>
class AsyncResult
{
public:
	HANDLE m_hEvent;
	Ret m_retVal;
	BOOL isCompleted;
	// The Above variable should  be private
	//// I should have kept all the variables as private I had thought earlier but right now no time so please excuse me :-)

	AsyncResult()
	{
		isCompleted=FALSE;
		m_hEvent = CreateEvent(NULL,TRUE,FALSE,NULL);
	}
	~AsyncResult()
	{
		CloseHandle(m_hEvent);
	}
	Ret GetVal()
	{
		cout<<"start GetVal"<<endl;
		WaitForSingleObject(m_hEvent,INFINITE);
		cout<<"end GetVal"<<endl;
		return m_retVal;
	}
	BOOL IsCompleted()
	{
		return isCompleted;
	}

private:
	// I should have kept all the variables her as I thought earlier but right now no time so please excuse me :-)
	
};

template <typename Ret,typename Param0>
class Callback
{
public:
	//typedef int (T::*fn)(int)
	virtual Ret Invoke(Param0 param0)=0;
	virtual void SetAR(AsyncResult<Ret>*)=0;
	virtual AsyncResult<Ret>* GetAR() = 0;
};

template <typename Ret,typename Param0,typename T,typename Method>
class MethodCallback : public Callback<typename Ret,typename Param0>
{
private:
	typedef int (T::*Method)(int);
	T* m_pObject;
	Method m_pmfnFunc;
	AsyncResult<Ret>* par;
public:
				
		MethodCallback(T* pobj,Method memfunc) : m_pObject(pobj),m_pmfnFunc(memfunc)
		{

		}
		virtual Ret Invoke(Param0 param0)
		{
			return (m_pObject->*m_pmfnFunc)(param0);
		}	
		void SetAR(AsyncResult<Ret>* ar)
		{
			par= ar;
		}
		AsyncResult<Ret>* GetAR()
		{
			return par;
		}
		~MethodCallback()
		{
			delete par;
		}
};

template <typename Ret,typename Param0>
class APCCall
{
public:
		Callback<typename Ret,typename Param0>* m_CallBack;
		Param0 param0;
		APCCall(Callback<typename Ret,typename Param0>* pCallback,Param0 par0):m_CallBack(pCallback),param0(par0)
		{

		}
		
};

template <typename Ret,typename Param0>
class Delegate 
{
public:
		typedef Callback<Ret,Param0> CB;

		template <typename T,typename Method>
		Delegate(T* obj,Method method):m_CallBack((Callback<Ret,Param0> *)new MethodCallback<Ret,Param0,T,Method>(obj,method))
		{
			//par = new AsyncResult<Ret>();
		}
		~Delegate()
		{
			delete m_CallBack;
		}

		AsyncResult<Ret>* BeginInvoke(Param0 param0) // Async Call
		{
			//shared_ptr<CB*> sc(m_pCallback);
			cout<<"AsyncCall"<<endl;
			CWorkQueueMgr<CB,Ret,Param0>::Instance()->InitThread();
			AsyncResult<Ret>* par = CWorkQueueMgr<CB,Ret,Param0>::Instance()->QueueIt(m_CallBack,param0);
			return par;
		}

		Ret operator()(Param0 param0) //Sync Call
		{
			cout<<"SyncCall"<<endl;
			CWorkQueueMgr<CB,Ret,Param0>::Instance()->InitThread();
			AsyncResult<Ret>* par = CWorkQueueMgr<CB,Ret,Param0>::Instance()->QueueIt(m_CallBack,param0);
			m_CallBack->SetAR(par);
			
			return par->GetVal(); //This will be Sync Call since AsynResult Waits.
		}
		Ret EndInvoke(AsyncResult<Ret>* par)
		{
			return par->GetVal();
		}
private:
		Callback<typename Ret,typename Param0>* m_CallBack;
		
		
};
template<typename T, typename Method>
class sample
{
public:
	
	sample(T* obj,Method method):m_pObject(obj),m_pmfnFunc(method)
	{

	}
	void makecall()
	{
		m_pObject->*m_pmfnFunc();
	}
private:
	T* m_pObject;
	Method* m_pmfnFunc;
};

class SampleResult
{

	
};



class A
{
public:
	int foo()
	{
		cout<<"In foo This: "<<this<<" Threadid : "<<GetCurrentThreadId()<<endl;
		return 100;
	};
	int foo1(int a)
	{
		cout<<"In foo param: "<<a<<" This: "<<this<<" Threadid : "<<GetCurrentThreadId()<<endl;
		return 100;
	};
	int roo(int a)
	{
		cout<<"In foo param: "<<a<<" This: "<<this<<" Threadid : "<<GetCurrentThreadId()<<endl;
		return 200;
	};
	A()
	{

	}
private:
	
};



template<typename T,typename Ret,typename Param0>
class CWorkQueueMgr
{

public:
	HANDLE m_hQueueMgrThread;
	HANDLE m_hEvent;
	DWORD dwThreadId;
	//static CWorkQueueMgr<T,Ret>* instance;
	static CWorkQueueMgr* Instance()
	{
		static CWorkQueueMgr<T,Ret,Param0> wqm;
		return &wqm;
	}
	static DWORD WINAPI FnQueueThread(LPVOID lpvoid)
	{
		
		CWorkQueueMgr<T,Ret,Param0>* obj = ( CWorkQueueMgr<T,Ret,Param0>*)lpvoid;
		cout<<"CWorkQueueMgr !=NULL :  "<<obj<<endl;
		while(WAIT_OBJECT_0!=WaitForSingleObjectEx(obj->m_hEvent,INFINITE,TRUE)) // Alertable
		{

		}
		cout<<"afterwaitforsingleobject :  "<<obj<<endl;
		return 21;
	}
	static VOID NTAPI APCFunc(__in ULONG_PTR lpvoid) // Execute the Delegate as  well as the member function pointer
	{
		cout<<"Inside APC function call"<<endl;
		//A* obj = (A*)lpvoid;
		APCCall<Ret,Param0>* obj = (APCCall<Ret,Param0>*)lpvoid;
		
		T* pObj =  obj->m_CallBack; // Delegate object as we discussed
		
		pObj->GetAR()->m_retVal = pObj->Invoke(obj->param0);
		
		SetEvent(pObj->GetAR()->m_hEvent);
		
		pObj->GetAR()->isCompleted=TRUE;
		
		//obj->invoke();//Set result obj->ar->result =
		//obj->ar->//Set AR event
		//set AR iscomplete
	}


	AsyncResult<Ret>* QueueIt(T* a,Param0 parm0)
	{
		cout<<"Inside QueueIt function call"<<endl;
		AsyncResult<Ret>* ar = new AsyncResult<Ret>();
		a->SetAR(ar);
		//Embedd AR to delgate
		APCCall<Ret,Param0>* apccall  =   new APCCall<Ret,Param0>(a,parm0); 
		//cout<<"Just before QueueUserAPC function call"<<endl;
		QueueUserAPC(APCFunc,m_hQueueMgrThread,(ULONG_PTR)apccall);//Send Delegate
		//cout<<"Just after QueueUserAPC function call"<<endl;
		return ar;
	}
	void InitThread()
	{
		//cout<<"InitThread"<<this<<endl;
		if(m_hQueueMgrThread==NULL)
		{
			//cout<<"InitThread1"<<this<<endl;
			m_hQueueMgrThread =  CreateThread(NULL,NULL,FnQueueThread,this,0,&dwThreadId);
		}
		//cout<<"InitThread2"<<this<<endl;
	}
	~CWorkQueueMgr()
	{
		cout<<"destructor of CWorkQueueMgr"<<endl;
		ResetEvent(m_hEvent); // Event is SIGNALLED now the APC thread will exit
		
	}
private:
	CWorkQueueMgr()
	{
		m_hEvent = CreateEvent(NULL,TRUE,FALSE,"Wait"); // Event is NON-SIGNALLED initially since I want to have a in Alertable state, which I will use to process APCCalls thro' the APC Queue
	}

};


/*HANDLE CWorkQueueMgr<Callback<Ret,Param0>,int>::m_hQueueMgrThread = NULL;
HANDLE CWorkQueueMgr<Callback<Ret,Param0>,int>::m_hEvent=NULL;
DWORD CWorkQueueMgr<Callback<Ret,Param0>,int>::dwThreadId=0;*/